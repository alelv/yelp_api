
require 'httparty'
require_relative "./yelp_api/version"
require_relative "./cli"
require_relative "./api_manager"
require_relative "./business_getter"

ENV["runtime"] ||= "development"

if ENV["runtime"] == "development"
  require_relative "../secrets"
end


module YelpApi
  class Error < StandardError; end
  # Your code goes here...
end