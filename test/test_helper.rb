$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pry'
require 'cloudinsight/opentsdb'

require 'minitest/autorun'
require 'mocha/mini_test'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
