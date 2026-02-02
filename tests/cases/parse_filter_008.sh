#!/bin/sh

./bin/parse_filter 'aa HAS "C"'

./bin/parse_filter 'aa HAS ALL "C"'

./bin/parse_filter 'aa HAS ANY "C"'

./bin/parse_filter 'aa HAS ONLY "C"'
