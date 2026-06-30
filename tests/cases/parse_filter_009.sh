#!/bin/sh

./bin/parse_filter 'a:b HAS "A":"B"'

./bin/parse_filter 'a:b HAS ALL "A":"B"'

./bin/parse_filter 'a:b HAS ANY "A":"B"'

./bin/parse_filter 'a:b HAS ONLY "A":"B"'
