#!/bin/sh

./bin/parse_filter 'aa:bbbb:ccc:dd HAS ALL "C":"H":"O":"Y"'

./bin/parse_filter 'aa:bbbb:ccc:dd HAS ANY "C":"H":"O":"Y"'

./bin/parse_filter 'aa:bbbb:ccc:dd HAS ONLY "C":"H":"O":"Y"'
