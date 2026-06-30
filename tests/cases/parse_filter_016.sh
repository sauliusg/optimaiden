#!/bin/sh

./bin/parse_filter 's.p : x.y : a.b.c HAS ALL ENDS WITH ".cif" : CONTAINS ".hkl" : STARTS WITH "foo"'
./bin/parse_filter 's.p : x.y : f : a.b.c : l HAS ALL ENDS WITH ".cif" : CONTAINS ".hkl" : > 12 : STARTS WITH "foo" : 22'
./bin/parse_filter 's.p : x.y : f : a.b.c : l.m HAS ALL ENDS WITH ".cif" : CONTAINS ".hkl" : > 12 : STARTS WITH "foo" : 12'
./bin/parse_filter 's.p : x.y : f : a.b.c : l.m HAS ALL ENDS WITH ".cif" : CONTAINS ".hkl" : > 12 : STARTS WITH "foo" : w.x'
./bin/parse_filter 's.p : x.y : f : a.b.c HAS ALL ENDS WITH ".cif" : CONTAINS ".hkl" : > 12 : STARTS WITH "foo"'
./bin/parse_filter 's.p : x.y HAS ALL ENDS WITH ".cif" : ENDS WITH ".hkl"'
