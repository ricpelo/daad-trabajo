#!/bin/bash

python3 triz2DAAD.py -dsf $1map.json $1.dsf
python3 triz2DAAD.py $1map.json $1.sce
