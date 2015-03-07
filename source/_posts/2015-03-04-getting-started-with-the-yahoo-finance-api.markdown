---
layout: post
title: "Getting Started with the Yahoo Finance API"
date: 2015-03-04 17:33
comments: true
categories: [yahoo-finance, api, php]
published: false
---

The Yahoo Finance API provides a way for developers to get the latest information about the stock market. How the different stocks are doing. What's the current buying price for a single stock. How much is the difference of the current market value to that of yesterday's, etc. 

First thing that you need to do is to install the Guzzle library for PHP. This allows us to easily make http requests to the server. You can do that by adding the following on your `composer.json` file:

```
 {
   "require": {
      "guzzlehttp/guzzle": "~5.0"
   }
}
```

Then execute `composer install` from your terminal. 

Next create a `test.php` file and put the following code:

```php
<?php
require 'vendor/autoload.php';
$client = new GuzzleHttp\Client();
?>
```

This allows us to use guzzle from our file.

Before we move on here are the specific data that you can get from the API:

**Pricing**

- `a` - ask
- `b` - bid
- `b2` - ask (realtime)
- `b3` - bid (realtime)
- `p` - previous close
- `o` - open

**Dividends**

- `y` - dividend yield
- `d` - dividend per share
- `r1` - dividend pay date
- `q` - ex-dividend date

**Date**

- `c1` - change
- `c` - change & percentage change
- `c6` - change (realtime)
- `k2` - change percent
- `p2` - change in percent
- `d1` - last trade date
- `d2` - trade date
- `t1` - last trade time 

**Averages**

- `c8` - after hours change
- `c3` - commission
- `g` - day's low
- `h` - day's high
- `k1` - last trade (realtime) with time
- `l` - last trade (with time)
- `l1` - last trade (price only)
- `t8` - 1 yr target price
- `m5` - change from 200 day moving average
- `m6` - percent change from 200 day moving average
- `m7` - change from 50 day moving average
- `m8` - percent change from 50 day moving average
- `m3` - 50 day moving average
- `m4` - 200 day moving average

**Misc**

- `w1` - day's value change
- `w4` - day's value change (realtime)
- `p1` - price paid
- `m` - day's range
- `m2` - day's range (realtime)
- `g1` - holding gain percent
- `g3` - annualized gain
- `g4` - holdings gain
- `g5` - holdings gain percent (realtime)
- `g6` - holdings gain (realtime)
- `t7` - ticker trend
- `t6` - trade links
- `i5` - order book (realtime)
- `l2` - high limit
- `l3` - low limit
- `v1` - holdings value
- `v7` - holdings value (realtime)
- `s6` - revenue

**52 Week Pricing**

- `k` - 52 week high
- `j` - 52 week low
- `j5` - change from 52 week low
- `k4` - change from 52 week high
- `j6` - percent change from 52 week low
- `k5` - percent change from 52 week high
- `w` - 52 week range

**Symbol Info**

- `v` - more info
- `j1` - market capitalization
- `j3` - market cap (realtime)
- `f6` - float shares
- `n` - name
- `n4` - notes
- `s` - symbol
- `s1` - shares owned
- `x` - stock exchange
- `j2` - shares outstanding

**Volume**

- `v` - volume
- `a5` - ask size 
- `b6` - bid size
- `k3` - last trade size
- `a2` - average daily volume

**Ratios**

- `e` - earnings per share
- `e7` - eps estimate current year
- `e8` - eps estimate next year
- `e9` - eps estimate next quarter
- `b4` - book value
- `j4` - EBITDA
- `p5` - price / sales
- `p6` - price / book
- `r` - P/E ratio
- `r2` - P/E ratio (realtime)
- `r5` - PEG ratio
- `r6` - price / eps estimate current year 
- `r7` - price /eps estimate next year
- `s7` - short ratio

Wew! Ok so that's a lot. I'll let you catch your breath for a second. Ready?

Ok so now were ready to make a request to the API. You can either do that from here:

```
http://download.finance.yahoo.com/d/quotes.csv?s={SYMBOLS}&f={DATA THAT WE WANT}
```

Or here:

```
http://finance.yahoo.com/d/quotes.csv?s={SYMBOLS}&f={DATA THAT WE WANT}
```

Doesn't really matter which. Both returns the same thing. Here's an example which you can just copy and paste into your browser's address bar:

```
http://finance.yahoo.com/d/quotes.csv?s=GOOGL&f=abo
```

Breaking it down. We make a request to this URL:

```
http://finance.yahoo.com/d/quotes.csv
```

And then we pass in some query parameters: `s` and `f`. `s` represents the symbol or symbols that you want to query. And `f` represents the data that you want. That's the big list that we just went through earlier. So if you want the API to return the ask, bid and open. We just need to pass in:

```
f=abo
```

In the example that we have. Were requesting this information for the `GOOGL` symbol. Which is basically Google. When this is requested in the browser, it downloads a `quotes.csv` file which contain something similar to the following:

```
580.36,575.90,576.35
```

Its a comma-separated list of all the values you requested. So 580.36 is the ask price, 575.90 is the bidding price, and 576.35 is the open price. 

If you want to query more than one symbol, you just separate each symbol with a comma. So for example you want to request the stock information about Google, Apple, Microsoft and Facebook:

```
http://finance.yahoo.com/d/quotes.csv?s=GOOGL,AAPL,MSFT,FB&f=abo
```

Now let's proceed with actually making this all work with PHP. First we need to create a table that will store all the information that we need. In this case, we only need the symbol, ask, bid and open values:

```sql
CREATE TABLE symbols (
    id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    symbol VARCHAR(30) NOT NULL,
    ask DOUBLE,
    bid DOUBLE,
    open DOUBLE
)
```

Next create an `indexer.php` file. What this file does is to query the yahoo finance api and then save the results to a csv file. Note that we can only query up to 200 symbols per request. So we'll have to work based on that on our code. 

The first thing that the code below does is to query the number of symbols currently in the database. And then we calculate how many times we need to loop in order to update all the symbols. We also need to declare the file path of the csv file in which will save all the results from the API. And initialize it by setting its value to an empty string. Then we declare the format `sabo`. Which means symbol, ask, bid and open. Next we create a for loop that will keep on executing until the value of `$x` reaches the total loop times that we got from dividing the total number of symbols by the API limit. Inside the loop we calculate the offset value by multiplying the current value of `$x` by the API limit. After that, we select the symbols that we need based on that. Then we loop through the results, specifically the symbol and then put them in an array. After looping through all the results, we convert the array into a comma separated list. This allows us to use this value for querying the API. Once we get the result back, we just save it to the csv file using `file_put_contents`.

```php
<?php
require 'vendor/autoload.php';
$db = new Mysqli(HOST, USER, PASS, DB);
$client = new GuzzleHttp\Client();

$symbols_count_result = $db->query("SELECT COUNT(id) FROM symbols");
$symbol_row = $symbols_count_result->fetch_row(); 
$symbol_count = $symbol_row[0];

$api_limit = 200;

$loop_times = $symbol_count / $api_limit;
$loop_times = floor($loop_times) + 1;

$file = 'uploads/csv/stocks.csv';
file_put_contents($file, '');

$format = 'sabo'; 

for($x = 0; $x < $loop_times; $x++){

    $from = $x * $api_limit;
    $symbols_result = $db->query("SELECT * FROM symbols LIMIT '$api_limit' OFFSET '$from'");

    if($symbols_result->num_rows > 0){

        $symbols = array();
        while($row = $symbols_result->fetch_object()){
            symbols[] = $row->symbol;
        } 
        
        $symbols_str = implode(',', $symbols);
        $stocks = $client->get("http://download.finance.yahoo.com/d/quotes.csv?s={$symbols_str}&f={$format}");

        file_put_contents($file, $stocks->getBody(), FILE_APPEND);
    }
}        
?>
```

That's it! The Yahoo Finance API is a really nice way of getting financial information about specific companies.