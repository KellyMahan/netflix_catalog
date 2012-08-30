require File.dirname(__FILE__) + '/spec_helper'
require 'netflix_catalog'
require 'yaml'
require "cgi"

describe "NetflixCatalog::Connection" do
    

  before :each do
    @options = YAML::load( File.open( 'keys.yml' ) )
    @connection = NetflixCatalog::Connection.new(@options['consumer_key'], @options['consumer_secret'])
  end
  
  # simple connection that doesn require signed queries
  
  it " should escape strings correctly" do
    CGI.escape("! * ' ( ) ; : @ & = + $ , / ? % # [ ]").should eq("%21+%2A+%27+%28+%29+%3B+%3A+%40+%26+%3D+%2B+%24+%2C+%2F+%3F+%25+%23+%5B+%5D")
  end
  
  it "should have the consumer key" do
    @options['consumer_key'].should_not be_nil
  end
  
  it "should return autocomplete results" do
    @connection.autocomplete("frances mc").should eq(["Frances McDormand", "Frances Lee McCain"])
  end
  
  ### signed requests
  
  it "should have a proper base string" do
    params = {}
    params.merge!(oauth_consumer_key: @options['consumer_key'])
    params.merge!(oauth_nonce: "12345")
    params.merge!(oauth_signature_method: 'HMAC-SHA1')
    params.merge!(oauth_timestamp: "123456789")
    params.merge!(oauth_version: "1.0")
    @connection.send(:base_string, "GET", "catalog/titles/movies/70144647", params).should eq(
      "GET&http%3A%2F%2Fapi-public.netflix.com%2Fcatalog%2Ftitles%2Fmovies%2F70144647&oauth_consumer_key%3D4e4vpzwsgt2qab7gt56sameh%26oauth_nonce%3D12345%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D123456789%26oauth_version%3D1.0"
    )
  end
  
  # it "should return return movie info" do
  #   @connection.movie("70144647").should eq("this")
  # end
  
end
