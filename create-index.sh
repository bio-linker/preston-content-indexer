#!/bin/bash
# Create a new index for SHA256-TLSH pairs

curl -X DELETE "localhost:9200/test_index?pretty"

curl -X PUT "localhost:9200/test_index?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "analysis": {
      "analyzer": {
        "my_analyzer": {
          "tokenizer": "my_tokenizer",
          "filter" : ["lowercase"]
        }
      },
      "tokenizer": {
        "my_tokenizer": {
          "type": "ngram",
          "min_gram": 3,
          "max_gram": 3,
          "token_chars": [
            "letter",
            "digit"
          ]
        }
      }
    }
  },
  "mappings": {
    "_doc": {
      "properties": {
        "sha256": { "type": "keyword" }, 
        "tlsh": {
            "type": "text",
            "analyzer": "my_analyzer",
            "fields": {
                "raw": { "type": "keyword" }
            }
        }
      }
    }
  }
}
'

# curl -s -H "Content-Type: application/x-ndjson" -XPOST localhost:9200/test_index/_doc/_bulk?pretty --data-binary "@requests"; echo

# curl -X POST "localhost:9200/text_index/_doc/_bulk" -H 'Content-Type: application/json' -d'
# { "index" : {} }
# { "sha256" : "very nice", "tlsh" : "coolcool" }
# { "index" : {} }
# { "sha256" : "very nice2", "tlsh" : "coolcoolhaha" }
# { "index" : {} }
# { "sha256" : "hash://sha256/3eff98d4b66368fd8d1f8fa1af6a057774d8a407a4771490beeb9e7add76f362", "tlsh" : "hash://tlsh/C493859C2B08947D8BE9A75B21C52F14E7CBB87782F81CE451EACF7D81845BB930D219" }
# '

# cat small-hash-tlsh.nq | awk '{ print "{ \"index\" : {} }\n{ \"sha256\" : \"" $1 "\", \"tlsh\" : \"" $2 "\" }"}' > requests

curl -X GET "localhost:9200/test_index/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "bool": {
      "must": {
        "match": {
          "tlsh": "hash://tlsh/8451EFFADBC0960C19EA4681B371F920971291F353D045D0F856CAEBBF54C26F9A79E0"
        }
      }
    }
  }
}
'

curl -X GET "localhost:9200/test_index/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "fuzzy": {
      "tlsh": {
          "value": "hash://tlsh/C493859C2B08947D8BE9A75B21C52F14E7CBB87782F81CE451EACF7D81845BB930D219",
          "transpositions": false
      }
    }
  }
}
'
