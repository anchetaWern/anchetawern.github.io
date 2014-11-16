---
layout: post
title: "Getting Started With Zillow API"
date: 2014-03-20 14:01
comments: true
categories: [zillow, api, php]
published: true
---

In this tutorial were going to have a quick look at the Zillow API. But before we move on with actually writing some code lets first define what Zillow is. Taken from the [Zillow about page](http://www.zillow.com/corp/About.htm) itself:

{% blockquote %}
Zillow is a home and real estate marketplace dedicated to helping homeowners, home buyers, sellers, renters, real estate agents, mortgage professionals, landlords and property managers find and share vital information about homes, real estate, mortgages and home improvement.
{% endblockquote %}

To sum it up Zillow is a place where you can find useful information on real estate properties that are up for sale or rent. 

<!-- more -->

####Getting a Zillow Web Service ID

In order to start making requests to the Zillow API you must first register an account with them. Registering with zillow is free, all you have to do is visit the [zillow homepage](http://www.zillow.com/) and click on the join link. After that just enter all the information that is being asked. Once registered go to the [API registration page](http://www.zillow.com/webservice/Registration.htm) and enter the necessary information:

![zillow api registration](/images/posts/2014-03-20-getting-started-with-zillow-api/api-signup.png)

Just check the specific API that you will need for your project, agree to the terms of use then click on the submit button. Zillow will also ask about a sample URL where you will use the API, if you do not have a specific URL in mind you can just place `http://localhost` or some other URL which you can use for testing purposes.

Once that's done zillow will email you the API details. All you need here is the value for the Zillow Web Services Identification (ZWSID).

####GetSearchResults API

Now that we have a zillow web service ID its time to test out some of the API methods that are available. First on the list is the `GetSearchResults API` which you can use to find real estate information for a specific address. Note that an address must be posted first by an owner or an agent in the [Zillow site](http://www.zillow.com/for-sale-by-owner/) before it can be viewed.

The URL for requesting search results is `http://www.zillow.com/webservice/GetSearchResults.htm`. 

It requires 3 url encoded arguments to be passed in:

- **zws-id** - the zillow web service id
- **address** - the address of the property to search (e.g. 3799 S Las Vegas Blvd, Las Vegas, NV 89109, United States)
- **citystatezip** - the city + state combination or the zip code of the address that you specified in the `address` field.

A successful request will return an XML file containing all the search results. Here's a JSON string representation of the XML file that will be returned:

```json
{
	request: {
		address: '',
		citystatezip: ''
	},
	message: {
		text: '',
		code: ''
	},
	response: {
		results: {
			result: [
				{
					zpid: '',
					link: {
						homedetails: '',
						graphsanddata: '',
						comparables: ''
					},
					address: {
						street: '',
						zipcode: '',
						city: '',
						state: '',
						latitude: '',
						longitude: ''
					},
					zestimate: {
						amount: '',
						last-updated: '',
						oneWeekChange: {
							@attributes: {
								deprecated: ''
							}
						},
						valueChange: '',
						valuationRange: {
							low: '',
							high: ''
						},
						percentile: ''
					},
					localRealEstate: {
						region: {
							@attributes: {
								id: '',
								type: '',
								name: ''
							},
							links: {
								overview: '',
								forSaleByOwner: '',
								forSale: ''
							}
						}
					}
				}
			]
		}
	}
}
```

And no the results doesn't exactly return empty strings for the values of each of the properties. I just did it that way so you can focus on the actual properties that are returned.

Here's an example PHP code that makes a request to the zillow API using `file_get_contents`. You can also use `curl` to have the benefit of error handling but to keep things simple lets stick with `file_get_contents` for this tutorial:

```php
<?php
$zillow_id = 'xxx'; //the zillow web service ID that you got from your email

$search = $_GET['address'];
$citystate = $_GET['citystate'];
$address = urlencode($search);
$citystatezip = urlencode($citystate);

$url = "http://www.zillow.com/webservice/GetSearchResults.htm?zws-id=$zillow_id&address=$address&citystatezip=$citystatezip";

$result = file_get_contents($url);
$data = simplexml_load_string($result);
?>
```

Once the request is completed you can just access individual properties using the arrow notation. In the example below were accessing the `zpid` property:

```
<?php
echo $data->response->results->result[0]->zpid;
?>
```

But what happens when we enter an address which doesn't exist in the zillow database? For that you can check the value for the `message.code`:

```
<?php
$code = $data->message->code;
?>
```

This contains a 1-3 digit number. `0` basically means that the request was successful and that there are results that are returned. `507` or `508` means that there's no exact match for the inputted address. There are a bunch of other error codes which you can use so check out the messages and codes section in the [search results api page](http://www.zillow.com/howto/api/GetSearchResults.htm) for more information.

For more information regarding the search results API check out [this page](http://www.zillow.com/howto/api/GetSearchResults.htm)


####GetZestimate API

Another API Method that we can use is the `GetZestimate`. This returns information regarding the zestimate of a specific property. A Zestimate is Zillow's estimated market value, computed using a proprietary formula. You can use the `GetZestimate` method by making a request to this URL: `http://www.zillow.com/webservice/GetZestimate.htm`.

The `GetZestimate` method only requires 2 arguments: the `zws-id` and the `zpid`. Of this 2 arguments the `zpid` is of interest since we didn't use it in the previous method. The `zpid` is basically a unique ID assigned by zillow to a specific property. 

If you might have noticed earlier the `SearchResults` method already returns some zestimate data:

```json
zestimate: {
    amount: '',
    last-updated: '',
    oneWeekChange: {
        @attributes: {
            deprecated: ''
        }
    },
    valueChange: '',
    valuationRange: {
        low: '',
        high: ''
    },
    percentile: ''
}
```

You can pretty much use this one if you don't need detailed information about a specific zestimate of a property. But if need more detailed information the `GetZestimate` method is the one that you need to use. Here's the JSON string representation of the result that it returns:

```
{
    request: {
        zpid: ''
    },
    message: {
       text: '',
       code: ''
    },
    response: {
        zpid: '',
        links: {
            homedetails: '',
            graphsanddata: '',
            mapthishome: '',
            comparables: ''
        },
        address: {
            street: '',
            zipcode: '',
            city: '',
            state: '',
            latitude: '',
            longitude: ''
        },
        zestimate: {
            amount: '',
            last-update: '',
            oneWeekChange: '',
            valueChange: '',
            valuationRange: {
                low: '',
                high: ''
            },
            percentile: ''
        },
        localRealEstate: {
            region: {
                links: {
                    overview: '',
                    forSaleByOwner: '',
                    forSale
                }
            }
        },
        regions: {
            zipcode-id: '',
            city-id: '',
            county-id: '',
            state-id: ''
        }
    }
}
```

The one caveat about the `GetZestimate` method is that it cannot be used without having information on the `zpid`. And you can only get the `zpid` with the `GetSearchResults` method so the `GetZestimate` method is always used in tandem with the `GetSearchResults` method unless you're saving `zpid`'s in your database.

If you want to know more about the `GetZestimate` method check out the [documentation](http://www.zillow.com/howto/api/GetZestimate.htm)

####GetChart

The last method that I'm going to talk about in this tutorial is the `GetChart` method. You can use the `GetChart` method to get a URL to an image which shows the historical zestimates for a specific property. You can make a request to this method by using this URL: `http://www.zillow.com/webservice/GetChart.htm`

The `GetChart` method requires the following argument to be passed in:

- `zws-id`
- `zpid` - the unique ID assigned by zillow to the specific property
- `unit-type` - you can either use `dollar` or `percent` as the value. This is basically use for specifying whether to display the dollar changed or the percent changed of a specific property
- `height` - the height of the image to return in pixels
- `width` - the width of the image to return in pixels



You can pretty much guess the `unit-type` that was used for this image. Yep that's right its in dollars. So the image above is basically showing that the value for the specific property went up from 96,000 dollars to 104,000 dollars over a period of about one year. You can actually specify this value by passing in the `chartDuration` argument. Then you can have values like `1year`, `2years` or `10years`. If you don't specify anything it defaults to '1year'.

For more information regarding the `GetChart` method check out its [documentation](http://www.zillow.com/howto/api/GetChart.htm).

###Conclusion

That's it! Like with any other getting started guide we've only scratched the surface with this tutorial. There's a lot more that you can do with Zillow API so be sure to check out the resources below to learn more.

###Resources

 - [Zillow API Documentation](http://www.zillow.com/howto/api/APIOverview.htm)
