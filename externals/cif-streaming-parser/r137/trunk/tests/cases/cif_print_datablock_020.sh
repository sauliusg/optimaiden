#!/bin/bash
cat tests/data/concatenated_cif.cif | ./bin/cif_print_datablock '1553297 1553256 XYZ 1553259'
