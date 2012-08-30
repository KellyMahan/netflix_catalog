require 'nokogiri'
require 'open-uri'
require 'uri'
require 'cgi'
require 'base64'
require 'openssl'

module NetflixCatalog
  
  
  class Connection
    
    BASE_URL = "http://api-public.netflix.com"
    attr_accessor :oauth_consumer_key
    attr_accessor :oauth_consumer_secret
    
    def initialize(oauth_consumer_key=nil, oauth_consumer_secret=nil)
      @oauth_consumer_key=oauth_consumer_key
      @oauth_consumer_secret=oauth_consumer_secret
    end
    
    def autocomplete(name)
      request = get("catalog/titles/autocomplete", term: name, signed: false)
      return request.xpath("//title").map{|t| t["short"]}
    end
    
    def movie(id)
      request = get("catalog/titles/movies/#{id}")
      return request
    end
        
    def unsigned_url(path, params = {})
      url = "#{BASE_URL}/#{path}?#{to_query(params)}"
      return url
    end
    
    def get(path, params = {})
      begin
        if params[:signed] == false

          params.merge!(oauth_consumer_key: @oauth_consumer_key)
          url = unsigned_url(path, params)
        else
          params.merge!(oauth_consumer_key: @oauth_consumer_key)
          params.merge!(oauth_nonce: Random.rand(100000).to_s)
          params.merge!(oauth_signature_method: 'HMAC-SHA1')
          params.merge!(oauth_timestamp: Time.now.to_i.to_s)
          params.merge!(oauth_version: "1.0")
          url = signed_url("GET", path, params)
        end
        return Nokogiri::HTML(open(url))
      rescue OpenURI::HTTPError => e
        puts "\n\n"
        puts "**#{e.message}**"
        puts "#{url}"
        puts "\n\n"
      end
    end
    
    def to_query(hash)
      hash.delete(:signed)
      hash.collect do |key, value|
        "#{key}=#{URI.encode(value)}"
      end.sort * '&'
    end
    
    def base_string(verb, path, params = {})
      string = verb
      string << "&"
      string << CGI.escape("#{BASE_URL}/#{path}")
      string << "&"
      string << CGI.escape(to_query(params))
      return string
    end
    
    def signed_url(verb, path, params = {})

      #puts base_string
      _base_string = base_string(verb, path, params)
      oauthsig = CGI.escape(
        Base64.encode64(
          OpenSSL::HMAC::SHA1.digest( "#{@oauth_consumer_secret}&",_base_string)
        ).chomp.gsub(/\n/,'')
      )
      url = "#{unsigned_url(path, params)}&oauth_signature=#{oauthsig}"
      puts url
      return url
    end
        
  end
  
  #not working - 401 unauthorized error
  # class Auth    
  #   
  #   ##############################################################################################
  #   
  #   # only needed to get the access token once
  #   def get_request_token_url(key = nil, secret = nil, app_name = nil)
  #     @oauth = OAuth::Consumer.new(
  #       key,
  #       secret,
  #       site: "http://api.netflix.com", 
  #       request_token_url: "http://api.netflix.com/oauth/request_token", 
  #       access_token_url: "http://api.netflix.com/oauth/access_token", 
  #       authorize_url: "https://api-user.netflix.com/oauth/login"
  #     )
  #     @oauth = @oauth.get_request_token
  #     url = @oauth.authorize_url(oauth_consumer_key: key, application_name: app_name )
  #   end
  #   
  #   # gets the access token after a successful auth
  #   def get_access_token
  #     @oauth.get_access_token
  #   end
  #   
  #   ###############################################################################################
  # end

end