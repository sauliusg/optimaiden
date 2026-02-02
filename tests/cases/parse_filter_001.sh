#!/bin/sh

./bin/parse_filter 'a = b'

./bin/parse_filter 'a != b'

./bin/parse_filter 'abc <= def'

./bin/parse_filter '_cod_abc >= _rod_def'
