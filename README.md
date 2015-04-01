# LBF

This is a big ol' pile of nested service objects for interacting with the Look
Buy Fly SOAP API.

**This is a work in progress**

#### Todo:
* Make dependencies leaner (don't require activesupport/all)
* Tests!

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'lbf'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lbf

## Usage

```ruby
require 'lbf'

client = LBF::Client.new(username:  'lbf_username', # required
                         url_id:    '42',           # required
                         password:  'lbf_password', # required
                        )

request = LBF::Request.new(origin:        'sdf',                  # required
                           destination:   'sna',                  # required
                           ip:            '208.73.215.97',        # required
                           departure_date: Date.tomorrow,         # required
                           return_date:    Date.tomorrow + 7.days # optional
                          )
client.search request
```

## Contributing

1. Fork it ( https://github.com/oversee-ffleming/lbf/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
