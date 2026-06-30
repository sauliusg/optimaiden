#!/bin/sh

./bin/parse_filter 'a CONTAINS "foo"'

./bin/parse_filter 'a STARTS "foo"'

./bin/parse_filter 'a STARTS WITH "foo"'

./bin/parse_filter 'a ENDS "foo"'

./bin/parse_filter 'a ENDS WITH "foo"'
