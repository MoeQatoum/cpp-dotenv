#!/bin/bash

clear

rm -rf ./build ./out

cmake -B build

cmake --build build #--target install -j #-v
