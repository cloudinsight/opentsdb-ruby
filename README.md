# opentsdb-ruby

Ruby client for OpenTSDB HTTP Query API. 

[![Gem Version](http://img.shields.io/gem/v/opentsdb-ruby.svg)](https://rubygems.org/gems/opentsdb-ruby) [![Build Status](https://travis-ci.org/cloudinsight/opentsdb-ruby.png)](https://travis-ci.org/cloudinsight/opentsdb-ruby) [![Code Climate](https://codeclimate.com/github/cloudinsight/opentsdb-ruby/badges/gpa.svg)](https://codeclimate.com/github/cloudinsight/opentsdb-ruby) [![Test Coverage](https://codeclimate.com/github/cloudinsight/opentsdb-ruby/badges/coverage.svg)](https://codeclimate.com/github/cloudinsight/opentsdb-ruby/coverage)

## Installation

Add this line to your application's Gemfile:

```ruby
  gem 'opentsdb-ruby', require 'opentsdb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install opentsdb-ruby


## Quick Start Guide

### Configure opentsdb

```ruby
  #config/initializers/opentsdb.rb
  #require 'opentsdb'
  Opentsdb.configure do |config|
    config.host = 'localhost'  # opentsdb server host default: localhost
    config.port =  4242        # opentsdb server port default: 4242
  end 
```

### Usage

```ruby

  # define simple query params
  params = { begin: Time.now.ago(1.hour), q: 'avg:system.load.1{host=*}' }
  client = Opentsdb::Client.new(params)
  result = client.query
  # => { status: 'ok', condition: #<Opentsdb::QueryParam: @metric="system.load.1",..., result: '[{"metric": "system.load.1", "tags": ... "dps":[...]}]}'

  # complicate query params
  params = { begin: Time.now.ago(1.hour), end: Time.now, q: 'avg:system.load.1{host=server1, host=server2, tagk=tagv}by{host}', interval: 360 }
  client = Opentsdb::Client.new(params)
  result = client.query
  # => { status: 'ok', condition: #<Opentsdb::QueryParam: @metric="system.load.1",..., result: '[{"metric": "system.load.1", "tags": ... "dps":[...]}]}'

  # reconfig opentsdb host and port
  params = { host: '192.168.0.100', port: 8000, q: 'avg:system.load.1{host=*}' }
  client = Opentsdb::Client.new(params)
  result = client.query
  # => { status: 'ok', condition: #<Opentsdb::QueryParam: @metric="system.load.1",..., result: '[{"metric": "system.load.1", "tags": ... "dps":[...]}]}'

  #query exception
  client = Opentsdb::Client.new(q: 'avg:unknown_metric')
  result = client.query
  # => { status: 'error', condition: #<Opentsdb::QueryParam: @metric="system.load.1",..., result: '{"error":{"code":400,"message":"No such name for 'metrics'...}}'

```

### Contributing
  
#### Fork the Project
  
  ```
  $ git https://github.com/cloudinsight/opentsdb-ruby.git
  $ cd opentsdb-ruby
  $ git remote add upstream https://github.com/cloudinsight/opentsdb-ruby.git  
  ```
#### Create a Toptic Branch

  ```
  $ git checkout master
  $ git pull upstream master
  $ git checkout -b my-feature-branch
  ```
#### Run Test 
  ```
  $ bundle exec rake test
  ```
#### Make a Pull Request

  Click the `'Pull Request'` button and fill out the form.

### License

MIT License. See [LICENSE](https://github.com/cloudinsight/opentsdb-ruby/blob/master/LICENSE.md) for details.


