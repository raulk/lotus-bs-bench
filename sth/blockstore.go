package sthbs

/*
#include "/usr/include/storethehash_db_cid/storethehash_db_cid.h"
#cgo pkg-config: /usr/lib/pkgconfig/storethehash_db_cid.pc --static
#cgo LDFLAGS: -L/usr/lib -lstorethehash_db_cid -lm -luuid -ltbb -laio -lpthread -lgcc -lstdc++ -lstdc++fs
*/
import "C"
import (
	"context"
	"fmt"
	"log"
	"unsafe"

	blocks "github.com/ipfs/go-block-format"
	"github.com/ipfs/go-cid"
	blockstore "github.com/ipfs/go-ipfs-blockstore"
)

// Blockstore is a sqlite backed IPLD blockstore, highly optimized and
// customized for IPLD query and write patterns.
type Blockstore struct {
	db *C.StoreTheHashCidDb
}

var _ blockstore.Blockstore = (*Blockstore)(nil)

type Options struct {
	// placeholder
}

const (
	OK = iota
	ERROR
)

// Open creates a new storethehash-backed blockstore.
func Open(path string, _ Options) (*Blockstore, error) {
	cPath := C.CString(path)
	defer C.free(unsafe.Pointer(cPath))

	db := C.open_db(cPath)
	if db == nil {
		return nil, fmt.Errorf("failed to open storethehash database")
	}

	bs := &Blockstore{db: db}

	return bs, nil
}

func (b *Blockstore) Has(cid cid.Cid) (bool, error) {
	key, keylen := keyFromCid(cid)
	defer C.free(key)

	cHas := C.has(b.db, (*C.char)(key), (C.ulong)(keylen))
	return cHas == 1, nil
}

func (b *Blockstore) Get(cid cid.Cid) (blocks.Block, error) {
	key, keylen := keyFromCid(cid)
	defer C.free(key)
	val := (*C.char)(C.malloc(0))
	vallen := C.size_t(0)

	ret := C.get(b.db, (*C.char)(key), (C.ulong)(keylen), &val, &vallen)
	defer C.f_free_buf(val, vallen)

	if ret != OK {
		return nil, fmt.Errorf("failed get")
	}
	
	return blocks.NewBlockWithCid(C.GoBytes(unsafe.Pointer(val), (C.int)(vallen)), cid)
}

func (b *Blockstore) GetSize(cid cid.Cid) (int, error) {
	key, keylen := keyFromCid(cid)
	defer C.free(key)

	size := C.get_len(b.db, (*C.char)(key), (C.ulong)(keylen))
	if size == -1 {
		return -1, blockstore.ErrNotFound
	}
	return (int)(size), nil
}

func (b *Blockstore) Put(block blocks.Block) error {
	err := b.put(block)

	return err
}

func (b *Blockstore) put(block blocks.Block) error {
	var (
		cid  = block.Cid()
		data = block.RawData()
	)

	key, keylen := keyFromCid(cid)
	defer C.free(key)
	val, vallen := C.CBytes(data), len(data)
	defer C.free(val)

	ret := C.set(b.db, (*C.uchar)(key), (C.ulong)(keylen), (*C.uchar)(val), (C.ulong)(vallen))
	if ret != OK {
		return fmt.Errorf("failed to put block")
	}

	return nil
}

func (b *Blockstore) PutMany(blocks []blocks.Block) error {
	var err error
	for _, blk := range blocks {
		if err = b.put(blk); err != nil {
			break
		}
	}
	
	return err
}

func (b *Blockstore) DeleteBlock(cid cid.Cid) error {
	key, keylen := keyFromCid(cid)
	defer C.free(key)

	ret := C.del(b.db, (*C.char)(key), (C.ulong)(keylen), 1)
	if ret != OK {
		return fmt.Errorf("failed to delete block")
	}

	return nil
}

func (b *Blockstore) AllKeysChan(ctx context.Context) (<-chan cid.Cid, error) {
	ret := make(chan cid.Cid)

	cIter := C.iter(b.db)
	if cIter == nil {
		close(ret)
		return nil, fmt.Errorf("failed to query all keys from sqlite3 blockstore")
	}

	go func() {
		var key *C.char
		key = (*C.char)(C.malloc(0))
		keylen := C.size_t(0)

		defer func() {
			close(ret)
			C.free_iter(cIter)
			C.f_free_buf(key, keylen)
		}()

		for C.iter_next_key(cIter, &key, (*C.ulong)(&keylen)) != 0 {
			goBytes := C.GoBytes(unsafe.Pointer(key), (C.int)(keylen))
			id, err := cid.Cast(goBytes)
			if err != nil {
				log.Printf("failed to parse multihash when querying all keys in sqlite3 blockstore: %s: %v %d", err, goBytes, keylen)
			}
			ret <- id
		}
	}()
	return ret, nil
}

func (b *Blockstore) HashOnRead(_ bool) {
	log.Print("storethehash blockstore ignored HashOnRead request")
}

func (b *Blockstore) Close() error {
	if b.db != nil {
		// TODO vmx 2020-12-09: Make this work again. The storethehash FFI currenly doens't support closing.
		//C.close(b.db)
		b.db = nil
	}
	return nil
}

func keyFromCid(c cid.Cid) (unsafe.Pointer, int) {
	bytes := c.Bytes()
	return C.CBytes(bytes), len(bytes)
}
