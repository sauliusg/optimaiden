#!/bin/sh

./bin/parse_filter 'a ENDS "foo" AND x LENGTH = 5'
./bin/parse_filter 'a ENDS "foo" AND x LENGTH > 5'
./bin/parse_filter 'a ENDS "foo" AND x LENGTH < 5'
./bin/parse_filter 'a ENDS "foo" AND x LENGTH != 5'
./bin/parse_filter 'a ENDS "foo" AND x LENGTH >= 5'
./bin/parse_filter 'a ENDS "foo" AND x LENGTH <= 5'
