module Fitkit
  class Client

    API_VERSION = 1

    def initialize(opts)
      missing = [:consumer_key, :consumer_secret] - opts.keys
      if missing.size > 0
        raise Fitgem::InvalidArgumentError, "Missing required options: #{missing.join(',')}"
      end
      @consumer_key = opts[:consumer_key]
      @consumer_secret = opts[:consumer_secret]

      #@ssl = opts[:ssl]

      @token = opts[:token]
      @secret = opts[:secret]

      #@proxy = opts[:proxy] if opts[:proxy]
      @user_id = opts[:user_id] || '-'

      #@api_unit_system = opts[:unit_system] || Fitgem::ApiUnitSystem.US
      @api_version = API_VERSION
    end

    # Finalize authentication and retrieve an oauth access token
    #
    # @param [String] token The OAuth token
    # @param [String] secret The OAuth secret
    # @param [Hash] opts Additional data
    # @option opts [String] :oauth_verifier The verifier token sent by
    #   fitbit after user has logged in and authorized the application.
    #   Is included in the body of the callback request, if there was
    #   one.  Otherwise is shown onscreen for the user to copy/paste
    #   back into your application.  See {https://wiki.fitbit.com/display/API/OAuth-Authentication-API} for more information.
    #
    # @return [OAuth::AccessToken] An oauth access token; this is not
    #   needed to make API calls, since it is stored internally.  It is
    #   returned so that you may make general OAuth calls if need be.
    def authorize(token, secret, opts={})
      request_token = OAuth::RequestToken.new(consumer, token, secret)
      @access_token = request_token.get_access_token(opts)
      @token = @access_token.token
      @secret = @access_token.secret
      @api_unit_system = "en_GB"
      @access_token
    end    

    def access_token
      @access_token ||= OAuth::AccessToken.new(consumer, @token, @secret)
    end

    def request_token(opts={})
      t = consumer.get_request_token(opts)
      puts "http://www.fitbit.com/oauth/authorize?oauth_token=#{t.token}"
      t
    end 

    def reconnect(token, secret)
      @token = token
      @secret = secret
      access_token
    end       

    def consumer
      @consumer ||= OAuth::Consumer.new(@consumer_key, @consumer_secret, {
        :site => "http://api.fitbit.com",
        :proxy => @proxy
      })
    end    

    def user_info(opts={})
      get("/user/#{@user_id}/profile.json", opts)
    end    

    def get(path, headers={})
      extract_response_body raw_get(path, headers)
    end    

    private
      def raw_get(path, headers={})
        headers.merge!('User-Agent' => "Fitkit gem v#{Fitkit::VERSION}", 'Accept-Language' => @api_unit_system)
        uri = "/#{@api_version}#{path}"
        access_token.get(uri, headers)
      end

      def post(path, body='', headers={})
        extract_response_body raw_post(path, body, headers)
      end

      def raw_post(path, body='', headers={})
        headers.merge!('User-Agent' => "Fitkit gem v#{Fitkit::VERSION}", 'Accept-Language' => @api_unit_system)
        uri = "/#{@api_version}#{path}"
        access_token.post(uri, body, headers)
      end

      def delete(path, headers={})
        extract_response_body raw_delete(path, headers)
      end

      def raw_delete(path, headers={})
        headers.merge!('User-Agent' => "Fitkit gem v#{Fitkit::VERSION}", 'Accept-Language' => @api_unit_system)
        uri = "/#{@api_version}#{path}"
        access_token.delete(uri, headers)
      end

      def extract_response_body(resp)
        resp.nil? || resp.body.nil? ? {} : JSON.parse(resp.body)
      end

  end

end