package main

import (
	"encoding/binary"
	"encoding/hex"
	"fmt"
	"io"
	"log"
	"math/rand"
	"os"
	"strings"
	"sync/atomic"

	blocks "github.com/ipfs/go-block-format"
	"github.com/ipfs/go-cid"
	blockstore "github.com/ipfs/go-ipfs-blockstore"
)

type Manifest struct {
	File *os.File
}

func (m *Manifest) Count() uint64 {
	b := make([]byte, 16) // hex
	_, err := m.File.ReadAt(b, 0)
	if err != nil {
		panic(err)
	}
	c := make([]byte, 8)
	if n, err := hex.Decode(c, b); err != nil || n != 8 {
		panic(fmt.Sprintf("failed to decode hex length; err: %s", err))
	}
	return binary.BigEndian.Uint64(c)
}

func (m *Manifest) Get(count uint64, repeatRate float64, repeatWindow int64) (<-chan cid.Cid, <-chan error) {
	var (
		window = make([]cid.Cid, repeatWindow)
		cidCh  = make(chan cid.Cid, 128)
		errCh  = make(chan error, 1)

		sentRepeat, sentUnique int64
		size                   int64
	)

	if stat, err := m.File.Stat(); err != nil {
		panic(err)
	} else {
		size = stat.Size()
	}

	go func() {
		defer close(cidCh)
		defer close(errCh)

		buf := make([]byte, 256)
		for remaining := count; remaining > 0; remaining-- {
			// check if we've already filled the repeat window; if so, draw a
			// number to compare against the repeat rate.
			if sentUnique > repeatWindow && rand.Float64() <= repeatRate {
				// we are repeating, draw from the repeat window.
				v := window[rand.Int63n(repeatWindow)]
				cidCh <- v
				sentRepeat++
				continue
			}

			// this algorithm biases a little against the _first_ CID, because
			// 'pos' only has 17 character positions to land on such that the
			// first CID will be chosen, versus all other ones which have 63
			// character positions they can land on (previous CID + \n).
			//
			// HIGHLY OPTIMIZABLE, but I don't have time, and not worth it.
			for {
				// seek to a random position in the File.
				pos := rand.Int63n(size)
				n, err := m.File.ReadAt(buf, pos)
				if err != nil && err != io.EOF {
					err = fmt.Errorf("failed to read offset %d (manifest size: %d)", pos, size)
					errCh <- err
					return
				}
				splt := strings.Split(string(buf[:n]), "\n")
				if len(splt) < 3 {
					// we expected something like
					//  (abc)\n(abcdef)\n(abc)....
					// if we didn't get it, repeat.
					continue
				}

				// pick the middle token.
				c, err := cid.Decode(splt[1])
				if err != nil {
					err = fmt.Errorf("failed to decode CID %s: %w)", splt[1], err)
					errCh <- err
					return
				}
				cidCh <- c
				sentUnique++

				// add the CID to the repeat window.
				window[sentUnique%repeatWindow] = c
				break
			}
		}

		log.Printf("read: CIDs read: total=%d, unique=%d, repeated=%d", sentUnique+sentRepeat, sentUnique, sentRepeat)
		errCh <- nil
	}()

	return cidCh, errCh
}

// ManifestedBlockstore traces all CIDs that were put in the blockstore into a
// text File, writing one CID per line, so they can be enumerated later.
type ManifestedBlockstore struct {
	blockstore.Blockstore

	file *os.File
	cnt  uint64
}

var _ blockstore.Blockstore = (*ManifestedBlockstore)(nil)

func ManifestBlockstore(inner blockstore.Blockstore, path string) *ManifestedBlockstore {
	f, err := os.Create(path)
	if err != nil {
		panic(err)
	}
	// reserve space at the beginning for the count in hex + \n
	_, _ = f.Write(make([]byte, 8*2+1))
	return &ManifestedBlockstore{Blockstore: inner, file: f}
}

func (t *ManifestedBlockstore) Manifest() *Manifest {
	// write the number of items imported, and close the File for writing.
	b := make([]byte, 8)
	binary.BigEndian.PutUint64(b, atomic.LoadUint64(&t.cnt))
	b = []byte(hex.EncodeToString(b))
	_, _ = t.file.WriteAt(b, 0)
	_ = t.file.Sync()
	_ = t.file.Close()

	// reopen for reading.
	f, err := os.Open(t.file.Name())
	if err != nil {
		panic(err)
	}
	return &Manifest{f}
}

func (t *ManifestedBlockstore) Put(block blocks.Block) error {
	if err := t.Blockstore.Put(block); err != nil {
		return err
	}
	atomic.AddUint64(&t.cnt, 1)
	_, _ = fmt.Fprintln(t.file, block.Cid())
	return nil
}

func (t *ManifestedBlockstore) PutMany(blocks []blocks.Block) error {
	if err := t.Blockstore.PutMany(blocks); err != nil {
		return err
	}
	for _, block := range blocks {
		_, _ = fmt.Fprintln(t.file, block.Cid())
	}
	atomic.AddUint64(&t.cnt, uint64(len(blocks)))
	return nil
}
