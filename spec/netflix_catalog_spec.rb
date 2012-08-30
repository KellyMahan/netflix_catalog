require File.dirname(__FILE__) + '/spec_helper'
require 'netflix_catalog'

describe "NetflixCatalog" do
  before :each do
    @netflix = NetflixCatalog.new
  end
  
  it "should load the gem" do
    @netflix.should be_a(NetflixCatalog::Connection)
  end
end
