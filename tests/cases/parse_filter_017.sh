#!/bin/sh

./bin/parse_filter 'a < 1 AND x >= 2'   'foo < bar OR a = 1 AND c != 0'
