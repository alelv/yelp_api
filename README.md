# YelpApi

YelpAPI is a Ruby Command-Line program that searches Yelp to create a directory of businesses in a given location. The program can get more details, browse reviews, and add to or remove from a 'favorites' list any business that exists in the created directory. 

# Prerequisites

You'll need to get an API key for the Yelp Fusion API to run this program.

Follow the steps in the link below to get started with the Yelp Fusion API.
https://www.yelp.com/developers/documentation/v3


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yelp_api'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install yelp_api

## Usage

Once you acquire your API key, you can make search requests thorugh APIManager.search_businesses and APIManger.search_reviews

To run the program from the command line type ruby bin/console into the command line.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alelee93/yelp_api.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
