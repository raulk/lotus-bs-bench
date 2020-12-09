#!/bin/bash
set -euxo pipefail

CAR_PATH="$HOME/complete_chain_with_finality_stateroots_149924_2020-10-15_23-32-00.car"

## bbolt 1M
go run . --car $CAR_PATH --store-type boltdb --store-path /data/tmp_bbolt_1M --import-limit=1M --read=false 2>&1 | tee ~/bbolt.1M.import.out
go run . --car $CAR_PATH --store-type boltdb --store-path /data/tmp_bbolt_1M --import-limit=1M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ~/bbolt.1M.read.out

## bbolt 10M
go run . --car $CAR_PATH --store-type boltdb --store-path /data/tmp_bbolt_10M --import-limit=10M --read=false 2>&1 | tee ~/bbolt.10M.import.out
go run . --car $CAR_PATH --store-type boltdb --store-path /data/tmp_bbolt_10M --import-limit=10M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ~/bbolt.10M.read.out

## bbolt all
go run . --car $CAR_PATH --store-type boltdb --store-path /data/tmp_bbolt_all --read=false 2>&1 | tee ~/bbolt.all.import.out
go run . --car $CAR_PATH --store-type boltdb --store-path /data/tmp_bbolt_all --import=false 2>&1 --read-repeat-rate=0.25 --read-repeat-window=1000 | tee ~/bbolt.all.read.out



## badger 1M
go run . --car $CAR_PATH --store-type badger --store-path /data/tmp_badger_1M --import-limit=1M --read=false 2>&1 | tee ~/badger.1M.import.out
go run . --car $CAR_PATH --store-type badger --store-path /data/tmp_badger_1M --import-limit=1M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ~/badger.1M.read.out

## badger 10M
go run . --car $CAR_PATH --store-type badger --store-path /data/tmp_badger_10M --import-limit=10M --read=false 2>&1 | tee ~/badger.10M.import.out
go run . --car $CAR_PATH --store-type badger --store-path /data/tmp_badger_10M --import-limit=10M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ~/badger.10M.read.out

## badger all
go run . --car $CAR_PATH --store-type badger --store-path /data/tmp_badger_all --read=false 2>&1 | tee ~/badger.all.import.out
go run . --car $CAR_PATH --store-type badger --store-path /data/tmp_badger_all --import=false 2>&1 --read-repeat-rate=0.25 --read-repeat-window=1000 | tee ~/badger.all.read.out



## lmdb 1M
go run . --car $CAR_PATH --store-type lmdb --store-path /data/tmp_lmdb_1M --import-limit=1M --read=false 2>&1 | tee ~/lmdb.1M.import.out
go run . --car $CAR_PATH --store-type lmdb --store-path /data/tmp_lmdb_1M --import-limit=1M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ~/lmdb.1M.read.out

## lmdb 10M
go run . --car $CAR_PATH --store-type lmdb --store-path /data/tmp_lmdb_10M --import-limit=10M --read=false 2>&1 | tee ~/lmdb.10M.import.out
go run . --car $CAR_PATH --store-type lmdb --store-path /data/tmp_lmdb_10M --import-limit=10M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ~/lmdb.10M.read.out

## lmdb all
go run . --car $CAR_PATH --store-type lmdb --store-path /data/tmp_lmdb_all --read=false 2>&1 | tee ~/lmdb.all.import.out
go run . --car $CAR_PATH --store-type lmdb --store-path /data/tmp_lmdb_all --import=false 2>&1 --read-repeat-rate=0.25 --read-repeat-window=1000 | tee ~/lmdb.all.read.out



## sqlite3 1M
go run . --car $CAR_PATH --store-type sqlite3 --store-path /data/tmp_sqlite3_1M --import-limit=1M --read=false 2>&1 | tee ~/sqlite3.1M.import.out
go run . --car $CAR_PATH --store-type sqlite3 --store-path /data/tmp_sqlite3_1M --import-limit=1M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ~/sqlite3.1M.read.out

## sqlite3 10M
go run . --car $CAR_PATH --store-type sqlite3 --store-path /data/tmp_sqlite3_10M --import-limit=10M --read=false 2>&1 | tee ~/sqlite3.10M.import.out
go run . --car $CAR_PATH --store-type sqlite3 --store-path /data/tmp_sqlite3_10M --import-limit=10M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ~/sqlite3.10M.read.out

## sqlite3 all
go run . --car $CAR_PATH --store-type sqlite3 --store-path /data/tmp_sqlite3_all --read=false 2>&1 | tee ~/sqlite3.all.import.out
go run . --car $CAR_PATH --store-type sqlite3 --store-path /data/tmp_sqlite3_all --import=false 2>&1 --read-repeat-rate=0.25 --read-repeat-window=1000 | tee ~/sqlite3.all.read.out



## pebble 1M
go run . --car $CAR_PATH --store-type pebble --store-path /data/tmp_pebble_1M --import-limit=1M --read=false 2>&1 | tee ~/pebble.1M.import.out
go run . --car $CAR_PATH --store-type pebble --store-path /data/tmp_pebble_1M --import-limit=1M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ~/pebble.1M.read.out

## pebble 10M
go run . --car $CAR_PATH --store-type pebble --store-path /data/tmp_pebble_10M --import-limit=10M --read=false 2>&1 | tee ~/pebble.10M.import.out
go run . --car $CAR_PATH --store-type pebble --store-path /data/tmp_pebble_10M --import-limit=10M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ~/pebble.10M.read.out

## pebble all
go run . --car $CAR_PATH --store-type pebble --store-path /data/tmp_pebble_all --read=false 2>&1 | tee ~/pebble.all.import.out
go run . --car $CAR_PATH --store-type pebble --store-path /data/tmp_pebble_all --import=false 2>&1 --read-repeat-rate=0.25 --read-repeat-window=1000 | tee ~/pebble.all.read.out


## gonudb 1M
rm /data/tmp_gonudb_1M.*
go run . --car $CAR_PATH --store-type gonudb --store-path /data/tmp_gonudb_1M --import-limit=1M --read=false 2>&1 | tee ~/gonudb.1M.import.out
go run . --car $CAR_PATH --store-type gonudb --store-path /data/tmp_gonudb_1M --import-limit=1M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ~/gonudb.1M.read.out

## gonudb 10M
rm /data/tmp_gonudb_10M.*
go run . --car $CAR_PATH --store-type gonudb --store-path /data/tmp_gonudb_10M --import-limit=10M --read=false 2>&1 | tee ~/gonudb.10M.import.out
go run . --car $CAR_PATH --store-type gonudb --store-path /data/tmp_gonudb_10M --import-limit=10M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ~/gonudb.10M.read.out

## gonudb all
rm /data/tmp_gonudb_all.*
go run . --car $CAR_PATH --store-type gonudb --store-path /data/tmp_gonudb_all --read=false 2>&1 | tee ~/gonudb.all.import.out
go run . --car $CAR_PATH --store-type gonudb --store-path /data/tmp_gonudb_all --import=false 2>&1 --read-repeat-rate=0.25 --read-repeat-window=1000 | tee ~/gonudb.all.read.out


## storethehash 1M
rm /data/tmp_storethehash_1M.*
go run . --car $CAR_PATH --store-type storethehash --store-path /data/tmp_storethehash_1M --import-limit=1M --read=false 2>&1 | tee ~/storethehash.1M.import.out
go run . --car $CAR_PATH --store-type storethehash --store-path /data/tmp_storethehash_1M --import-limit=1M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ~/storethehash.1M.read.out

## storethehash 10M
rm /data/tmp_storethehash_10M.*
go run . --car $CAR_PATH --store-type storethehash --store-path /data/tmp_storethehash_10M --import-limit=10M --read=false 2>&1 | tee ~/storethehash.10M.import.out
go run . --car $CAR_PATH --store-type storethehash --store-path /data/tmp_storethehash_10M --import-limit=10M --import=false --read-repeat-rate=0.25 --read-repeat-window=1000 2>&1 | tee ~/storethehash.10M.read.out

## storethehash all
rm /data/tmp_storethehash_all.*
go run . --car $CAR_PATH --store-type storethehash --store-path /data/tmp_storethehash_all --read=false 2>&1 | tee ~/storethehash.all.import.out
go run . --car $CAR_PATH --store-type storethehash --store-path /data/tmp_storethehash_all --import=false 2>&1 --read-repeat-rate=0.25 --read-repeat-window=1000 | tee ~/storethehash.all.read.out
