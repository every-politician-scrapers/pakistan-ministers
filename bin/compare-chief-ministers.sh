#!/bin/bash

bundle exec ruby bin/scraper/chief-ministers-wikipedia.rb | ifne tee data/chief-ministers-wikipedia.csv
# TODO: bring WD fetch in-place
bundle exec ruby bin/diff-chief-ministers.rb | ifne tee data/diff-chief-ministers.csv

