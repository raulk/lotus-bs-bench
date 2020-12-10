package nullbs

import (
	"context"
	"log"

	blocks "github.com/ipfs/go-block-format"
	"github.com/ipfs/go-cid"
	blockstore "github.com/ipfs/go-ipfs-blockstore"
)

// Blockstore is a sqlite backed IPLD blockstore, highly optimized and
// customized for IPLD query and write patterns.
type Blockstore struct {
	// placeholder
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
	bs := &Blockstore{ }

	return bs, nil
}

func (b *Blockstore) Has(cid cid.Cid) (bool, error) {
	//key, keylen := keyFromCid(cid)
	//defer C.free(key)
	return true, nil
}

func (b *Blockstore) Get(cid cid.Cid) (blocks.Block, error) {
	//key, keylen := keyFromCid(cid)
	//defer C.free(key)
	//val := (*C.char)(C.malloc(0))
	//vallen := C.size_t(0)
        //
	//return blocks.NewBlockWithCid(C.GoBytes(unsafe.Pointer(val), (C.int)(vallen)), cid)
	return blocks.NewBlock([]byte("abc")), nil
}

func (b *Blockstore) GetSize(cid cid.Cid) (int, error) {
	//key, keylen := keyFromCid(cid)
	//defer C.free(key)

	return (int)(0), nil
}

func (b *Blockstore) Put(block blocks.Block) error {
	return nil
}

func (b *Blockstore) put(block blocks.Block) error {
	//var (
	//	cid  = block.Cid()
	//	data = block.RawData()
	//)
        //
	//key, keylen := keyFromCid(cid)
	//defer C.free(key)
	//val, vallen := C.CBytes(data), len(data)
	//defer C.free(val)
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
	//key, keylen := keyFromCid(cid)
	//defer C.free(key)
	return nil
}

func (b *Blockstore) AllKeysChan(ctx context.Context) (<-chan cid.Cid, error) {
	ret := make(chan cid.Cid)

	return ret, nil
}

func (b *Blockstore) HashOnRead(_ bool) {
	log.Print("null blockstore ignored HashOnRead request")
}

func (b *Blockstore) Close() error {
	return nil
}
