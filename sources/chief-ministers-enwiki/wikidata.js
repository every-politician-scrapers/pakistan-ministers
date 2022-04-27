module.exports = function () {
  return `SELECT DISTINCT ?region ?regionLabel ?position ?positionLabel ?person ?personLabel ?start
         (STRAFTER(STR(?ps), '/statement/') AS ?psid)
  WHERE {
    ?region wdt:P31|wdt:P31/wdt:P279 wd:Q270496 ; wdt:P31/wdt:P279* wd:Q10864048 ; wdt:P1313 ?position .
    MINUS { ?region wdt:P576 [] }

    OPTIONAL {
      ?person wdt:P31 wd:Q5 ; p:P39 ?ps .
      ?ps ps:P39 ?position ; pq:P580 ?start .
      FILTER NOT EXISTS { ?ps pq:P582 ?end }
    }

    SERVICE wikibase:label { bd:serviceParam wikibase:language "en"  }
  }
  ORDER BY ?regionLabel ?start`
}
