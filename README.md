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
  -d '{ 
    "origin_url" : "http://www.amazon.com/Apple-iPhone-16GB-Black-Verizon/dp/B004ZLV5UE", 
    "columns" : [{ 
      "col_name" : "product name", 
      "dom_query" : "#productTitle" 
    }, { 
      "col_name" : "product price", 
      "dom_query" : "#priceblock_ourprice" 
    }] }' \
  http://krake.io:9701/extract
```

#### Response from server
```console
{
  "status" : "success",
  "message" : {
    "logs" : [
      "[PHANTOM_SERVER] extract using jQuery\r\n\t\tcol_name:product name\r\n\t\tdom_query:#productTitle",
      "[PHANTOM_SERVER] extract using jQuery\r\n\t\tcol_name:product price\r\n\t\tdom_query:#priceblock_ourprice"
    ],
    "result_rows":[{
      "product name" : "Apple iPhone 4 16GB (Black) - CDMA Verizon",
      "product price" : "$219.95"
    }]
  }
}
```

#### To scrape a single page on yahoo
```console
coffee simple_client.coffee
```

#### Response from server
```console
{
  "result_rows":[{
    "address" : "90 Tremont St, Boston, MA, 02108",
    "hotel" : "Nine Zero Hotel, A Kimpton Hotel",
    "phone" : "(617) 772-5800","web":"www.ninezero.com"
  },{
    "address" : "40 Dalton St, Boston, MA, 02115",
    "hotel" : "Hilton Boston Back Bay",
    "phone" : "(617) 236-1100",
    "web" : "www3.hilton.com"
  },{
    "address" : "155 Portland St, Boston, MA, 02114",
    "hotel" : "Onyx Hotel, A Kimpton Hotel",
    "phone" : "(617) 557-9955",
    "web" : "www.onyxhotel.com"
  }]
}
```

## Reference to full API
see [Krake Definition API] (https://getdata.io/docs/define-data)

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

## Deployment

#### Monit and Upstart

Copy upstart configuration files
```
cp ./upstart/krake_phantomjs.conf /etc/init
```

Monit
```
Copy Monit configuration files
cp ./config/monit/krake_phantomjs.conf /etc/monit/conf.d
cp ./config/monit/status.conf /etc/monit/conf.d

# Check for syntax error
monit -t

# load the services
monit reload
```

#### Docker
###### Building the latest image
```console
cd <<PATH/TO/REPOSITORY>>
docker build -t mbp .
```

###### Spin up a container using the latest image
```console
docker run -p 9701:9701 -v <<PATH/TO/REPOSITORY>>/:/root/krake_phantomjs -d mbp
```

###### Observing the log
```console
docker ps # to get the docker <<container_id>>
docker logs -f <<container_id>>
```

###### Pinging the server
Mac OS
```console
boot2docker ip # to get the IP address of the docker container running locally
curl http://<<IP address>>:9701
```

Ubuntu
```console
curl http://0.0.0.0:9701
```