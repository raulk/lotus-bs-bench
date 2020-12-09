lotus-bs-bench
==============

If you want to run the storethehash based benchmarks, you need to have it installed. If you followed the steps and have it installed into `/tmp/staging`, then you need to run this benchmark as:

    LD_LIBRARY_PATH=/tmp/staging/usr/lib PKG_CONFIG_PATH="/tmp/staging/usr/lib/pkgconfig" CGO_CFLAGS="-I/tmp/staging/usr/include" CGO_LDFLAGS="-L/tmp/staging/usr/lib" ./run.sh
