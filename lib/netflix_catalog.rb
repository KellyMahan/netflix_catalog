require 'connection.rb'

module NetflixCatalog

  def self.new
    NetflixCatalog::Connection.new
  end

end