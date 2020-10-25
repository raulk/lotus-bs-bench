package sqlite3bs

import (
	"io/ioutil"
	"os"
	"testing"

	blockstore "github.com/ipfs/go-ipfs-blockstore"

	"github.com/raulk/lotus-bs-bench/bstest"
)

func TestSqlite3Blockstore(t *testing.T) {
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
	db, err := Open(path, Options{})
	if err != nil {
		tb.Fatal(err)
	}

	tb.Cleanup(func() {
		_ = os.RemoveAll(path)
	})

	return db, path
}

func openBlockstore(tb testing.TB, path string) (blockstore.Blockstore, error) {
	return Open(path, Options{})
}
