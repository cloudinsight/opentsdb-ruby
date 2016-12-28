$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'simplecov'
SimpleCov.start

require 'pry'
require 'opentsdb'

require 'minitest/autorun'
require 'mocha/mini_test'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new
