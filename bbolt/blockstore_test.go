package bbolt

import (
	"io/ioutil"
	"os"
	"testing"

	blockstore "github.com/ipfs/go-ipfs-blockstore"
	bolt "go.etcd.io/bbolt"

	"github.com/raulk/lotus-bs-bench/bstest"
)

func TestBoltDBBlockstore(t *testing.T) {
	s := &bstest.Suite{
		NewBlockstore:  newBlockstore,
		OpenBlockstore: openBlockstore,
	}
	s.RunTests(t)
}

func newBlockstore(tb testing.TB) (blockstore.Blockstore, string) {
	tb.Helper()

	tmp, err := ioutil.TempFile("", "")
	if err != nil {
		tb.Fatal(err)
	}

	path := tmp.Name()
	db, err := Open(path, bolt.DefaultOptions)
	if err != nil {
		tb.Fatal(err)
	}

	tb.Cleanup(func() {
		_ = os.RemoveAll(path)
	})

	return db, path
}

func openBlockstore(tb testing.TB, path string) (blockstore.Blockstore, error) {
	return Open(path, bolt.DefaultOptions)
}
