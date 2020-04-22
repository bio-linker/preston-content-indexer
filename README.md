# preston-content-indexer

## Creating an Elasticsearch index

Elasticsearch can (hopefully) be installed with the provided script:
```bash
./install-elasticsearch.sh
```

Then build an empty index in ElasticSearch:
```bash
./create-index.sh
```

sha256-tlsh pairs can be added to the index in bulk like so:
```bash
curl -X POST "localhost:9200/text_index/_doc/_bulk" -H 'Content-Type: application/json' -d'
{ "index" : {} }
{ "sha256" : "hash://sha256/blahblah1", "tlsh" : "hash://tlsh/blupblup1" }
{ "index" : {} }
{ "sha256" : "hash://sha256/blahblah2", "tlsh" : "hash://tlsh/blupblup2" }
'
```

## Indexing Preston content hashes
To index the sha256-tlsh pairs listed in `small-hash-tlsh.nq`:
```bash
cat small-hash-tlsh.nq | awk '{ print "{ \"index\" : {} }\n{ \"sha256\" : \"" $1 "\", \"tlsh\" : \"" $2 "\" }"}' > requests
curl -s -H "Content-Type: application/x-ndjson" -XPOST localhost:9200/test_index/_doc/_bulk?pretty --data-binary "@requests"; echo
```

To construct sha256-tlsh pairs from an existing Preston observatory:
```bash
coming soon :)
```

## Searching for similar content
Coming soon!
