# phantomjs_server
PhantomJS Plugin-Based server that interprets a data definition via HTTP post/RESTFUL API and returns an array of scraped results
from a single corresponding Web Page.

## Sample calls
#### Fetching iPhone product name and price from amazon
```console
curl -v \
  -H "Accept: application/json" \
  -H "Content-type: application/json" \
  -X POST \
  -d '{ "origin_url" : "http://www.amazon.com/Apple-iPhone-16GB-Black-Verizon/dp/B004ZLV5UE", "columns" : [{ "col_name" : "product name", "dom_query" : "#productTitle" }, { "col_name" : "product price", "dom_query" : "#priceblock_ourprice" }] }' \
  http://localhost:9701/extract
```

#### To scrape a single page on yahoo
```console
coffee simple_client.coffee
```

## Reference to full API
see [Krake Definition API] (https://krake.io/docs/define-krake)

## Running the harvesting service
```console
phantomjs server.js
```

## Setup
- PhantomJS 1.9.2

#### General settings
- The PhantomJS server will reside on port 9701
- The main file to call in this repository is server.js

## Documentation

#### File System

- server.js
    - the main phantomJS server
    
- test/
    - a series of test files written to coffee-script that utitlizes jasmine-node in NodeJS for testing

- logs/
    - where the log files are written to

- shell/
    - the shell script for restarting the phantomjs server background process

## Unit testing
```console
phantomjs server.js # Start service
jasmine-node --coffee test # do unit test against server
```