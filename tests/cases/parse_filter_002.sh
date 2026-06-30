#!/bin/sh

./bin/parse_filter 'a = b AND c != d'

./bin/parse_filter 'a = b AND c != 12'

./bin/parse_filter 'abc <= 1.28 OR 555 >= _rod_def'
