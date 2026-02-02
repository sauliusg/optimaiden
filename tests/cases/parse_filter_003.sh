#!/bin/sh

./bin/parse_filter 'a = b AND c != d OR str != "foo bar"'

./bin/parse_filter 'a = b OR (c != 12 AND string < "bar baz" AND q <= 1)'

./bin/parse_filter '( abc <= 1.28 OR 555 >= _rod_def ) AND f = ff'
