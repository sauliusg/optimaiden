#!/bin/sh

./bin/parse_filter 'aa:bbbb:ccc HAS "C":"H":"O"'

./bin/parse_filter 'aa:bbbb:ccc HAS ALL "C":"H":"O"'

./bin/parse_filter 'aa:bbbb:ccc HAS ANY "C":"H":"O"'

./bin/parse_filter 'aa:bbbb:ccc HAS ONLY "C":"H":"O"'
