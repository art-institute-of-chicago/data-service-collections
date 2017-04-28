![Art Institute of Chicago](https://raw.githubusercontent.com/Art-Institute-of-Chicago/template/master/aic-logo.gif)


# Collections Data Service
> A slim API in front of our collections management system

Most data that this API provides is already available through the Art Institute of
Chicago's public Solr index. This project aims to make interacting with our data in 
Solr easier. Clients don't have to know how to filter data to retrieve different 
object types, or details of the mechanisms of our Solr instance. They have a few simple 
endpoints to retrieve the data they're most likely going to need. 

This API was built in-house and is maintained by in-house developers. It is 
planned to go to production in 2017. 


## Features

This project provides a few simple endpoints. You can see them all in our 
[API Blueprint](tests/apiary.apib). But here are a few major ones:

* `/v1/artworks` - Get a list of all artworks, sorted by the date they were 
  last updated in descending order. Includes pagination options.
* `/v1/artworks/X` - Get a single artwork
* `/v1/artists` - Get a list of all artists, in the same manner as `/artworks/`.
* `/v1/artists/X` - Get a single artist
* `/v1/galleries` - Get a list of all galleries, in the same manner as `/artworks/`.
* `/v1/galleries/X` - Get a single gallery


## Overview

This API is part of a larger project at the Art Institute of Chicago to build a data hub 
for all of our published data--a single point that our forthcoming website and future 
products can access all the data they might be interested in in a simple, normalized, RESTful
way. This project provides an API in front of our collections that will feed into the 
data hub.


## Requirements

We've run this on our local machines with the following software as minimums:

* Ruby >= 2.3.1
* Node.js >= v0.12.7
* Node Package Manger >= 2.11.3 (comes with node.js)


## Installing

To get started with this project, use the following commands:

```shell
# Clone the repo to your computer
git clone https://github.com/art-institute-of-chicago/data-service-collections.git

# Enter the folder that was created by the clone
cd data-service-collections

# Install all the project's Ruby gems
bundle install

# Install all the project's Node.js packages
npm install
```

Each `install` command uses the languages package managers to install this project's 
dependencies. 


## Configuration

In order for this API to work, you'll need to create a [`config/conf.yaml`](config/conf.yaml)
file with a URL to your Solr index. See our [example](config/conf.yaml.example) file for
a sample.


## Developing

To run this project on a local server, use the command:

```shell
shotgun
```
 
This will spin up this project on a local server on port `9393`. You can hit
all the endpoints at `localhost:9393/v1`.Shotgun allows you to make changes to 
the code and see them reflected without needing to restart the server. If this is not 
a necessity for you, you can also start up the server with the following command:

```shell
rackup
```

This will spin up this project on a local server on port `9292`. You can hit
all the endpoints at `localhost:9292/v1`.


## Testing

You can run a test on all this project's endpoints using `dredd`:

```
npm run dredd
```

This will run through our [API Blueprint](tests/apiary.apib) document,
construct requests for each documented response, and execute the query to 
verify that the documented response is actually what is received.

## Contributing

We encourage your contributions. Please fork this repository and make your changes in 
a separate branch. We like to use [git-flow](https://github.com/nvie/gitflow) to make this process easier.

```bash
# Clone the repo to your computer
git clone git@github.com:your-github-account/data-service-collections.git

# Enter the folder that was created by the clone
cd data-service-collections

# Run the installs
bundle install
npm install

# Start a feature branch
git flow start feature yourinitials-good-description-issuenumberifapplicable

# ... make some changes, commit your code

# Push your branch to GitHub
git push origin yourinitials-good-description-issuenumberifapplicable
```

Then on github.com, create a Pull Request to merge your changes into our 
`develop` branch. 

This project is released with a Contributor Code of Conduct. By participating in 
this project you agree to abide by its [terms](CODE_OF_CONDUCT.md).

We also welcome bug reports and questions under GitHub's [Issues](issues).


## Licensing

This project is licensed under the [GNU Affero General Public License 
Version 3](LICENSE).
