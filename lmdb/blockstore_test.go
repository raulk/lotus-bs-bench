package lmdbbs

import (
	"io/ioutil"
	"os"
	"testing"

	blockstore "github.com/ipfs/go-ipfs-blockstore"

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

	path, err := ioutil.TempDir("", "")
	if err != nil {
		tb.Fatal(err)
	}

	db, err := Open(path)
	if err != nil {
		tb.Fatal(err)
	}

	tb.Cleanup(func() {
		_ = os.RemoveAll(path)
	})

	return db, path
}

func openBlockstore(tb testing.TB, path string) (blockstore.Blockstore, error) {
	return Open(path)
}
