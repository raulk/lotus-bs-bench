#!/bin/bash
set -euxo pipefail

DATA_DIR="/data"
LOG_DIR="~"
CAR_PATH="$HOME/complete_chain_with_finality_stateroots_149924_2020-10-15_23-32-00.car"

# bbolt 1M
go run . --car $CAR_PATH --store-type boltdb --store-path ${DATA_DIR}/tmp_bbolt_1M --import-limit=1M --read=false 2>&1 | tee ${LOG_DIR}/bbolt.1M.import.out
go run . --car $CAR_PATH --store-type boltdb --store-path ${DATA_DIR}/tmp_bbolt_1M --import-limit=1M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ${LOG_DIR}/bbolt.1M.read.out

# bbolt 10M
go run . --car $CAR_PATH --store-type boltdb --store-path ${DATA_DIR}/tmp_bbolt_10M --import-limit=10M --read=false 2>&1 | tee ${LOG_DIR}/bbolt.10M.import.out
go run . --car $CAR_PATH --store-type boltdb --store-path ${DATA_DIR}/tmp_bbolt_10M --import-limit=10M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ${LOG_DIR}/bbolt.10M.read.out

# bbolt all
go run . --car $CAR_PATH --store-type boltdb --store-path ${DATA_DIR}/tmp_bbolt_all --read=false 2>&1 | tee ${LOG_DIR}/bbolt.all.import.out
go run . --car $CAR_PATH --store-type boltdb --store-path ${DATA_DIR}/tmp_bbolt_all --import=false 2>&1 --read-repeat-rate=0.25 --read-repeat-window=1000 | tee ${LOG_DIR}/bbolt.all.read.out



# badger 1M
go run . --car $CAR_PATH --store-type badger --store-path ${DATA_DIR}/tmp_badger_1M --import-limit=1M --read=false 2>&1 | tee ${LOG_DIR}/badger.1M.import.out
go run . --car $CAR_PATH --store-type badger --store-path ${DATA_DIR}/tmp_badger_1M --import-limit=1M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ${LOG_DIR}/badger.1M.read.out

# badger 10M
go run . --car $CAR_PATH --store-type badger --store-path ${DATA_DIR}/tmp_badger_10M --import-limit=10M --read=false 2>&1 | tee ${LOG_DIR}/badger.10M.import.out
go run . --car $CAR_PATH --store-type badger --store-path ${DATA_DIR}/tmp_badger_10M --import-limit=10M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ${LOG_DIR}/badger.10M.read.out

# badger all
go run . --car $CAR_PATH --store-type badger --store-path ${DATA_DIR}/tmp_badger_all --read=false 2>&1 | tee ${LOG_DIR}/badger.all.import.out
go run . --car $CAR_PATH --store-type badger --store-path ${DATA_DIR}/tmp_badger_all --import=false 2>&1 --read-repeat-rate=0.25 --read-repeat-window=1000 | tee ${LOG_DIR}/badger.all.read.out



# lmdb 1M
go run . --car $CAR_PATH --store-type lmdb --store-path ${DATA_DIR}/tmp_lmdb_1M --import-limit=1M --read=false 2>&1 | tee ${LOG_DIR}/lmdb.1M.import.out
go run . --car $CAR_PATH --store-type lmdb --store-path ${DATA_DIR}/tmp_lmdb_1M --import-limit=1M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ${LOG_DIR}/lmdb.1M.read.out

# lmdb 10M
go run . --car $CAR_PATH --store-type lmdb --store-path ${DATA_DIR}/tmp_lmdb_10M --import-limit=10M --read=false 2>&1 | tee ${LOG_DIR}/lmdb.10M.import.out
go run . --car $CAR_PATH --store-type lmdb --store-path ${DATA_DIR}/tmp_lmdb_10M --import-limit=10M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ${LOG_DIR}/lmdb.10M.read.out

# lmdb all
go run . --car $CAR_PATH --store-type lmdb --store-path ${DATA_DIR}/tmp_lmdb_all --read=false 2>&1 | tee ${LOG_DIR}/lmdb.all.import.out
go run . --car $CAR_PATH --store-type lmdb --store-path ${DATA_DIR}/tmp_lmdb_all --import=false 2>&1 --read-repeat-rate=0.25 --read-repeat-window=1000 | tee ${LOG_DIR}/lmdb.all.read.out



## sqlite3 1M
go run . --car $CAR_PATH --store-type sqlite3 --store-path ${DATA_DIR}/tmp_sqlite3_1M --import-limit=1M --read=false 2>&1 | tee ${LOG_DIR}/sqlite3.1M.import.out
go run . --car $CAR_PATH --store-type sqlite3 --store-path ${DATA_DIR}/tmp_sqlite3_1M --import-limit=1M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ${LOG_DIR}/sqlite3.1M.read.out

## sqlite3 10M
go run . --car $CAR_PATH --store-type sqlite3 --store-path ${DATA_DIR}/tmp_sqlite3_10M --import-limit=10M --read=false 2>&1 | tee ${LOG_DIR}/sqlite3.10M.import.out
go run . --car $CAR_PATH --store-type sqlite3 --store-path ${DATA_DIR}/tmp_sqlite3_10M --import-limit=10M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ${LOG_DIR}/sqlite3.10M.read.out

# sqlite3 all
go run . --car $CAR_PATH --store-type sqlite3 --store-path ${DATA_DIR}/tmp_sqlite3_all --read=false 2>&1 | tee ${LOG_DIR}/sqlite3.all.import.out
go run . --car $CAR_PATH --store-type sqlite3 --store-path ${DATA_DIR}/tmp_sqlite3_all --import=false 2>&1 --read-repeat-rate=0.25 --read-repeat-window=1000 | tee ${LOG_DIR}/sqlite3.all.read.out



# pebble 1M
go run . --car $CAR_PATH --store-type pebble --store-path ${DATA_DIR}/tmp_pebble_1M --import-limit=1M --read=false 2>&1 | tee ${LOG_DIR}/pebble.1M.import.out
go run . --car $CAR_PATH --store-type pebble --store-path ${DATA_DIR}/tmp_pebble_1M --import-limit=1M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ${LOG_DIR}/pebble.1M.read.out

# pebble 10M
go run . --car $CAR_PATH --store-type pebble --store-path ${DATA_DIR}/tmp_pebble_10M --import-limit=10M --read=false 2>&1 | tee ${LOG_DIR}/pebble.10M.import.out
go run . --car $CAR_PATH --store-type pebble --store-path ${DATA_DIR}/tmp_pebble_10M --import-limit=10M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ${LOG_DIR}/pebble.10M.read.out

# pebble all
go run . --car $CAR_PATH --store-type pebble --store-path ${DATA_DIR}/tmp_pebble_all --read=false 2>&1 | tee ${LOG_DIR}/pebble.all.import.out
go run . --car $CAR_PATH --store-type pebble --store-path ${DATA_DIR}/tmp_pebble_all --import=false 2>&1 --read-repeat-rate=0.25 --read-repeat-window=1000 | tee ${LOG_DIR}/pebble.all.read.out



# gonudb 1M
rm -f ${DATA_DIR}/tmp_gonudb_1M.*
go run . --car $CAR_PATH --store-type gonudb --store-path ${DATA_DIR}/tmp_gonudb_1M --import-limit=1M --read=false 2>&1 | tee ${LOG_DIR}/gonudb.1M.import.out
go run . --car $CAR_PATH --store-type gonudb --store-path ${DATA_DIR}/tmp_gonudb_1M --import-limit=1M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ${LOG_DIR}/gonudb.1M.read.out

# gonudb 10M
rm -f ${DATA_DIR}/tmp_gonudb_10M.*
go run . --car $CAR_PATH --store-type gonudb --store-path ${DATA_DIR}/tmp_gonudb_10M --import-limit=10M --read=false 2>&1 | tee ${LOG_DIR}/gonudb.10M.import.out
go run . --car $CAR_PATH --store-type gonudb --store-path ${DATA_DIR}/tmp_gonudb_10M --import-limit=10M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ${LOG_DIR}/gonudb.10M.read.out

# gonudb all
rm -f ${DATA_DIR}/tmp_gonudb_all.*
go run . --car $CAR_PATH --store-type gonudb --store-path ${DATA_DIR}/tmp_gonudb_all --read=false 2>&1 | tee ${LOG_DIR}/gonudb.all.import.out
go run . --car $CAR_PATH --store-type gonudb --store-path ${DATA_DIR}/tmp_gonudb_all --import=false 2>&1 --read-repeat-rate=0.25 --read-repeat-window=1000 | tee ${LOG_DIR}/gonudb.all.read.out



# storethehash 1M
rm -f ${DATA_DIR}/tmp_storethehash_1M.*
go run . --car $CAR_PATH --store-type storethehash --store-path ${DATA_DIR}/tmp_storethehash_1M --import-limit=1M --read=false 2>&1 | tee ${LOG_DIR}/storethehash.1M.import.out
go run . --car $CAR_PATH --store-type storethehash --store-path ${DATA_DIR}/tmp_storethehash_1M --import-limit=1M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ${LOG_DIR}/storethehash.1M.read.out

# storethehash 10M
rm -f ${DATA_DIR}/tmp_storethehash_10M.*
go run . --car $CAR_PATH --store-type storethehash --store-path ${DATA_DIR}/tmp_storethehash_10M --import-limit=10M --read=false 2>&1 | tee ${LOG_DIR}/storethehash.10M.import.out
go run . --car $CAR_PATH --store-type storethehash --store-path ${DATA_DIR}/tmp_storethehash_10M --import-limit=10M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ${LOG_DIR}/storethehash.10M.read.out

## storethehash all
rm -f ${DATA_DIR}/tmp_storethehash_all.*
go run . --car $CAR_PATH --store-type storethehash --store-path ${DATA_DIR}/tmp_storethehash_all --read=false 2>&1 | tee ${LOG_DIR}/storethehash.all.import.out
go run . --car $CAR_PATH --store-type storethehash --store-path ${DATA_DIR}/tmp_storethehash_all --import=false 2>&1 --read-repeat-rate=0.25 --read-repeat-window=1000 | tee ${LOG_DIR}/storethehash.all.read.out
