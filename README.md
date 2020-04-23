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
To find the TLSH associated with a SHA256:
```bash
curl -X GET "localhost:9200/test_index/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "bool": {
      "must": {
        "match": {
          "sha256": "hash://sha256/3eff98d4b66368fd8d1f8fa1af6a057774d8a407a4771490beeb9e7add76f362"
        }
      }
    }
  }
}
'
```
To find similar TLSHs and their SHA256s:
```bash
$ curl -X GET "localhost:9200/test_index/_search?pretty" -H 'Content-Type: application/json' -d'
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
' | grep -E 'tlsh|sha256'

          "sha256" : "hash://sha256/8df7c66811c1160215bc74e01a95e329de7cfe02964c661bb9fd75c1fbaf6752",
          "tlsh" : "hash://tlsh/2C51EFFADBC0960C19EA4691B371F920971291F353D045D0F856CAEBBF14C26F9979E0"
          "sha256" : "hash://sha256/e17e7f4fcc4c4baa39ff22898a5822a31dea4076c44fa039b2011028e5565abe",
          "tlsh" : "hash://tlsh/8451EFFADBC0960C19EA4681B371F920971291F353D045D0F856CAEBBF54C26F9A79E0"
          "sha256" : "hash://sha256/495373d366be41c1fc6e64c46f326ba01a4042015059863122755b968153e073",
          "tlsh" : "hash://tlsh/C451DEFADBC0960C19EA4681B371F9209B12A1F353D045D0F856CAEBBE54C26F9979E0"
          "sha256" : "hash://sha256/578440a17a8dd9c829cd1eed5fa6aed7731c0a42f10a4097630fc64c6cfdd1a6",
          "tlsh" : "hash://tlsh/0851D0F9DBC0960C19E64681B371F9209B1291F353D045D0F856CAEBBF14C26F9979E0"
          "sha256" : "hash://sha256/e5433b854e83aa264bb0edda817e4d660e968176f4785deda72a651f0cefb325",
          "tlsh" : "hash://tlsh/1E51EEFADBC0860C19EB4681B371F9208B12A1F353D045D0F856CAEBBE14C26F9978E0"
          "sha256" : "hash://sha256/e57d4d922b9050587f5bb9933664aa7cad190cb9faa47e96be47b0acddcebf32",
          "tlsh" : "hash://tlsh/2451BDE9EF61861899C64784B370F9204B2291F713C142E5F857CFEABE08C60F96B6D1"
          "sha256" : "hash://sha256/f73125d5fcdbac4a1d62b3c929a13ffee18d6321e3f72ea98fd6f083771f47ce",
          "tlsh" : "hash://tlsh/7B51BFE9EF61861899C64744B370F9204B2291F713C142E5F857CFE6BE08C60F96B6D1"
          "sha256" : "hash://sha256/31e5308902ffd0cc76cba9bab970306a13034327d8daa5318b84d4ac0aea0669",
          "tlsh" : "hash://tlsh/9651BFE9EF61861899C64744B374F9204B2291F713C142E5F857CFE6BE08C60F96B6D1"
          "sha256" : "hash://sha256/61f1f40d9f51e81177795f6bfb3d5c7ae3b6d3cacaac0a85ee4e1d5865fdf18e",
          "tlsh" : "hash://tlsh/6A51BDE9EF61861899C64784B370F9204B2291F713C142E5F857CFEABE08C60F96B6D1"
          "sha256" : "hash://sha256/7a4d781b6c857227c18afa71b8d2e60533956a34673c55e7ece6af7d144368cf",
          "tlsh" : "hash://tlsh/2A51FEE5E7628A1879C7A78472B0F8340A2291F717D041E4FC6BCBD67E18960FA279D1"
```
Just the TLSHs:
```
          "tlsh" : "hash://tlsh/2C51EFFADBC0960C19EA4691B371F920971291F353D045D0F856CAEBBF14C26F9979E0"
          "tlsh" : "hash://tlsh/8451EFFADBC0960C19EA4681B371F920971291F353D045D0F856CAEBBF54C26F9A79E0"
          "tlsh" : "hash://tlsh/C451DEFADBC0960C19EA4681B371F9209B12A1F353D045D0F856CAEBBE54C26F9979E0"
          "tlsh" : "hash://tlsh/0851D0F9DBC0960C19E64681B371F9209B1291F353D045D0F856CAEBBF14C26F9979E0"
          "tlsh" : "hash://tlsh/1E51EEFADBC0860C19EB4681B371F9208B12A1F353D045D0F856CAEBBE14C26F9978E0"
          "tlsh" : "hash://tlsh/2451BDE9EF61861899C64784B370F9204B2291F713C142E5F857CFEABE08C60F96B6D1"
          "tlsh" : "hash://tlsh/7B51BFE9EF61861899C64744B370F9204B2291F713C142E5F857CFE6BE08C60F96B6D1"
          "tlsh" : "hash://tlsh/9651BFE9EF61861899C64744B374F9204B2291F713C142E5F857CFE6BE08C60F96B6D1"
          "tlsh" : "hash://tlsh/6A51BDE9EF61861899C64784B370F9204B2291F713C142E5F857CFEABE08C60F96B6D1"
          "tlsh" : "hash://tlsh/2A51FEE5E7628A1879C7A78472B0F8340A2291F717D041E4FC6BCBD67E18960FA279D1"
```

# Funding

This work is funded in part by grant [NSF OAC 1839201](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1839201&HistoricalAwards=false) from the National Science Foundation.
