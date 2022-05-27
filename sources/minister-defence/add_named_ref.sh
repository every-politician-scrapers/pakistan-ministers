#!/bin/zsh

SCRAPED_NAME=itemLabel
WIKIDATA_ITEM=item
WIKIDATA_PSID=psid

wikidata_count=$(qsv search -u -i $1 wikidata.csv | qsv count)
if [[ $wikidata_count != 1 ]]
then
  echo "No unique match to wikidata.csv:"
  qsv search -u -i $1 wikidata.csv | qsv behead
  return
fi
item=$(qsv search -u -i $1 wikidata.csv | qsv select $WIKIDATA_ITEM | qsv behead)
statementid=$(qsv search -u -i $1 wikidata.csv | qsv select $WIKIDATA_PSID | qsv behead)

scraped_count=$(qsv search -u -i $1 scraped.csv | qsv count)
if [[ $scraped_count != 1 ]]
then
  echo "No unique match to scraped.csv:"
  echo $(qsv search -u -i $1 scraped.csv | qsv behead)
  return
fi

name=$(qsv search -u -i $1 scraped.csv | qsv select $SCRAPED_NAME | qsv behead)
claims=$(qsv search -u -i $1 scraped.csv | qsv select $SCRAPED_NAME | qsv behead | qsv fmt --out-delimiter " ")

echo "$statementid $claims"
echo "$statementid $claims" | xargs wd ar --maxlag 20 add-source-name.js > /dev/null

existing=$(wd label $item)
if [[ $existing != $name ]]
then
  echo "Add alias: $item -> $name ($existing)"
  wd add-alias $item en $name > /dev/null
fi
