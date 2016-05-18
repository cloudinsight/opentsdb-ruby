# opentsdb-ruby

Ruby client for OpenTSDB HTTP Query API. 

[![Gem Version](http://img.shields.io/gem/v/opentsdb-ruby.svg)](https://rubygems.org/gems/opentsdb-ruby) [![Build Status](https://travis-ci.org/cloudinsight/opentsdb-ruby.png)](https://travis-ci.org/cloudinsight/opentsdb-ruby) [![Code Climate](https://codeclimate.com/github/cloudinsight/opentsdb-ruby/badges/gpa.svg)](https://codeclimate.com/github/cloudinsight/opentsdb-ruby) [![Test Coverage](https://codeclimate.com/github/cloudinsight/opentsdb-ruby/badges/coverage.svg)](https://codeclimate.com/github/cloudinsight/opentsdb-ruby/coverage)

## Installation

Add this line to your application's Gemfile:

```ruby
  gem 'opentsdb-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install opentsdb-ruby


## Quick Start Guide

### Configure opentsdb

```ruby
    #config/initializers/opentsdb.rb
    
      Opentsdb.configure do |config|
        config.host = 'localhost'  # opentsdb server host default: localhost
        config.port =  4242        # opentsdb server port default: 4242
      end 
```

### Usage

```ruby

  # define simple query params
  params = { begin: Time.now.ago(1.hour), q: 'avg:system.load.1{host=*}' }
  # opensted
  client = Opentsdb::Client.new(params)
  result = client.query # opentsdb json result


  # complicate query params
  params = { begin: Time.now.ago(1.hour), end: Time.now, q: 'avg:system.load.1{host=server1, host=server2, tagk=tagv}by{host}', interval: 360 }
  client = Opentsdb::Client.new(params)
  result = client.query # opentsdb json result
  

  # reconfig opentsdb host port
  params = { host: '192.168.0.100', port: 8000, q: 'avg:system.load.1{host=*}' }
  client = Opentsdb::Client.new(params)
  result = client.query # opentsdb json result
```


