package bbolt

import (
	"context"
	"fmt"
	"math"

	blocks "github.com/ipfs/go-block-format"
	"github.com/ipfs/go-cid"
	blockstore "github.com/ipfs/go-ipfs-blockstore"
	bolt "go.etcd.io/bbolt"
)

type Options = bolt.Options

type Blockstore struct {
	db      *bolt.DB
	buckets [][]byte
}

var _ blockstore.Blockstore = (*Blockstore)(nil)

func Open(path string, opts *Options) (*Blockstore, error) {
	db, err := bolt.Open(path, 0666, opts)
	if err != nil {
		return nil, fmt.Errorf("failed to open boltdb: %w", err)
	}

	bs := &Blockstore{
		db:      db,
		buckets: make([][]byte, 0, 0xffff),
	}

	// create all buckets.
	err = db.Update(func(tx *bolt.Tx) error {
		for i := 0; i < math.MaxUint16; i++ {
			b := []byte{byte(i >> 8 & 0xff), byte(i & 0xff)}
			if _, err := tx.CreateBucketIfNotExists(b); err != nil {
				return err
			}
			bs.buckets = append(bs.buckets, b)
		}
		return nil
	})
	return bs, err
}

func (b *Blockstore) Close() error {
	return b.db.Close()
}

func (b *Blockstore) Has(cid cid.Cid) (bool, error) {
	var exists bool
	err := b.db.View(func(tx *bolt.Tx) error {
		h := cid.Hash()
		b := tx.Bucket(h[:2])
		exists = b.Get(h) != nil
		return nil
	})
	return exists, err
}

func (b *Blockstore) Get(cid cid.Cid) (blocks.Block, error) {
	var val []byte
	err := b.db.View(func(tx *bolt.Tx) error {
		h := cid.Hash()
		b := tx.Bucket(h[:2])
		v := b.Get(h)
		if v == nil {
			return nil
		}
		val = make([]byte, len(v))
		copy(val, v)
		return nil
	})
	if err != nil {
		return nil, fmt.Errorf("failed while getting block from boltdb blockstore: %w", err)
	}
	if val == nil {
		return nil, blockstore.ErrNotFound
	}
	return blocks.NewBlockWithCid(val, cid)
}

func (b *Blockstore) GetSize(cid cid.Cid) (int, error) {
	var size int
	err := b.db.View(func(tx *bolt.Tx) error {
		h := cid.Hash()
		b := tx.Bucket(h[:2])
		v := b.Get(h)
		if v == nil {
			size = -1
		} else {
			size = len(v)
		}
		return nil
	})
	if err != nil {
		return -1, fmt.Errorf("failed while getting block from boltdb blockstore: %w", err)
	}
	if size == -1 {
		return size, blockstore.ErrNotFound
	}
	return size, nil
}

func (b *Blockstore) Put(block blocks.Block) error {
	return b.db.Update(func(tx *bolt.Tx) error {
		h := block.Cid().Hash()
		b := tx.Bucket(h[:2])
		return b.Put(h, block.RawData())
	})
}

func (b *Blockstore) PutMany(blocks []blocks.Block) error {
	return b.db.Update(func(tx *bolt.Tx) error {
		for _, block := range blocks {
			h := block.Cid().Hash()
			b := tx.Bucket(h[:2])
			if err := b.Put(h, block.RawData()); err != nil {
				return err
			}
		}
		return nil
	})
}

func (b *Blockstore) DeleteBlock(cid cid.Cid) error {
	return b.db.Update(func(tx *bolt.Tx) error {
		h := cid.Hash()
		b := tx.Bucket(h[:2])
		return b.Delete(h)
	})
}

func (b *Blockstore) AllKeysChan(ctx context.Context) (<-chan cid.Cid, error) {
	ch := make(chan cid.Cid)
	go func() {
		_ = b.db.View(func(tx *bolt.Tx) error {
			defer close(ch)

			for _, b := range b.buckets {
				c := tx.Bucket(b).Cursor()
				for k, _ := c.First(); k != nil; k, _ = c.Next() {
					if ctx.Err() != nil {
						return nil // context has fired.
					}
					ch <- cid.NewCidV1(cid.Raw, k)
				}
			}
			return nil
		})
	}()

	return ch, nil
}

func (b *Blockstore) HashOnRead(_ bool) {
	// ignore
}
