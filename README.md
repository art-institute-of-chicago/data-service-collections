![Art Institute of Chicago](https://raw.githubusercontent.com/Art-Institute-of-Chicago/template/master/aic-logo.gif)

# Collections Data Service
> A slim internal API in front of our collections management system

Part proxy, part transformer, this service facilitates the flow of data from our [collections management system (CITI)](https://4dmethod.com/demos/4d-at-the-art-institute-of-chicago/) into our [data hub](https://github.com/art-institute-of-chicago?q=data).


## Looking for our data?

You are in the wrong place. Check out this repo:

https://github.com/art-institute-of-chicago/data-aggregator

Our collections data service is not directly accessible to the public. Instead, its data gets fed into the aggregator, which offers outbound APIs to all of our public-facing applications. We are working towards opening these APIs to the public.


## Overview

Before February 2019, this service used to provide  digital asset data alongside collections data. We are currently working on spliting up these responsibilities. _This_ service will continue to provide collections data, while _that_ one will be providing digital asset data:

https://github.com/art-institute-of-chicago/data-service-assets

We are also rewriting this service from Ruby (Grape) to PHP (Laravel). All of our other services, as well as our website, are based on Laravel, so consolidating to ease development makes a lot of sense. Pardon the dust.

You can find the old Ruby implementation at the `release/1.0.0` branch:

https://github.com/art-institute-of-chicago/data-service-collections/tree/release/1.0.0
