class LBF::Client
  attr_reader :username, :password, :url_id, :wsdl, :cart_path
  def initialize(opts=defaults)
    options = defaults.merge(opts)
    %i(username password url_id).each do |key|
      raise ArgumentError, "Must supply #{key}" unless options.has_key?(key)
    end
    @username  = options[:username]
    @password  = options[:password]
    @url_id    = options[:url_id]
    @wsdl      = options[:wsdl]
  end

  # Searches the LBF API and returns a response object
  # @param [LBF::Request] The Request object that will be sent to the API
  # @return [LBF::Response] The appropriate LBF::Response object
  def search(request=LBF::Request.new)
    client = Savon.client(pretty_print_xml: true, log_level: :debug,
                          log: true, wsdl: @wsdl)
    request.client = self
    savon_resp = client.call :afs1, xml: request.to_xml
    response = LBF::Response.new(savon_resp.body)
    response.errors.map {|e| raise e }
    response
  end

  private

  def defaults
    {
      wsdl: 'http://webservices.lbftravel.com/services/4.2/ezAirFareService.asmx?WSDL'
    }
  end

end
