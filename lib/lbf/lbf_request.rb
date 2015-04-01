# This class just creates a (very specific) XML document with the appropriate request information to send
# to the LBF API.
class LBF::Request
  AIRPORT_METHODS = %i(origin destination)
  INT_METHODS = %i(adults children infants)
  DATE_METHODS = %i(departure_date return_date)
  OTHER_METHODS = %i(cabin ip)
  ALL_METHODS = (AIRPORT_METHODS + INT_METHODS + DATE_METHODS + OTHER_METHODS)
  CABINS = {coach: 'Y', business: 'C', first_class: 'F'}

  attr_reader *ALL_METHODS
  attr_accessor :client

  AIRPORT_METHODS.each do |meth|
    define_method("#{meth}=".to_sym) do |arg|
      raise ArgumentError, "Argument must be a 3-letter airport code" unless arg =~ /[a-zA-Z]{3}/
      instance_variable_set("@#{meth}", arg.upcase)
    end
  end

  INT_METHODS.each do |meth|
    define_method("#{meth}=".to_sym) do |arg|
      raise ArgumentError, "Argument must be an Integer" unless arg.is_a?(Integer)
      instance_variable_set("@#{meth}", arg)
    end
  end

  DATE_METHODS.each do |meth|
    define_method("#{meth}=".to_sym) do |arg|
      raise ArgumentError, "Date must respond to :strftime" unless arg.respond_to?(:strftime)
      instance_variable_set("@#{meth}", arg)
    end
  end

  def initialize(opts=defaults)
    %i(origin destination
       departure_date ip).each { |key| raise ArgumentError, "Must specify :#{key}" unless opts.keys.include? key }
    options = defaults.merge(opts).select { |k,v| ALL_METHODS.include? k }
    options.each { |k, v| self.send("#{k}=", v) }
  end

  def cabin=(symbol)
    raise ArgumentError, "Cabin must be one of #{CABINS.keys}" unless CABINS.keys.include? symbol
    @cabin = symbol
  end

  def ip=(arg)
    @ip = IPAddr.new("#{arg}")
  end

  def roundtrip?
    departure_date.present? && return_date.present?
  end

  def to_xml
    <<-XML.strip_heredoc
    <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      #{header}
      #{body}
    </soap:Envelope>
    XML
  end

  private

  def defaults
    {
      adults:         1,
      children:       1,
      infants:        0,
      cabin:          :coach
    }
  end

  def header
    <<-HEADER.strip_heredoc
    <soap:Header>
      <AuthHeader xmlns="ezgds">
        <Uname>#{client.username}</Uname>
        <Pwd>#{client.password}</Pwd>
        <URL>#{client.url_id}</URL>
        <VisitSessionID>0</VisitSessionID>
        <IP>#{ip}</IP>
      </AuthHeader>
    </soap:Header>
    HEADER
  end

  def body
    <<-BODY.strip_heredoc
    <soap:Body>
      <AFS1 xmlns="ezgds">
        <ezQuoteAirRequest>
          <QuoteAirRequestTrips>
          #{depart_trip_xml}
          #{return_trip_xml if roundtrip?}
          </QuoteAirRequestTrips>
          <PreferredAirline />
          <Cabin>#{CABINS[cabin]}</Cabin>
          <Adt>#{adults}</Adt>
          <Chd>#{children}</Chd>
          <Inf>#{infants}</Inf>
          <PromoID>0</PromoID>
          <CMPCode>0</CMPCode>
       </ezQuoteAirRequest>
     </AFS1>
    </soap:Body>
    BODY
  end

  def depart_trip_xml
    <<-DEPART.strip_heredoc
     <QuoteAirRequestTrip>
       <DepDt>#{departure_date.strftime '%m/%d/%Y'}</DepDt>
       <Orig>#{origin}</Orig>
       <Dest>#{destination}</Dest>
     </QuoteAirRequestTrip>
    DEPART
  end

  def return_trip_xml
    <<-RETURN.strip_heredoc
     <QuoteAirRequestTrip>
       <DepDt>#{return_date.strftime '%m/%d/%Y'}</DepDt>
       <Orig>#{destination}</Orig>
       <Dest>#{origin}</Dest>
     </QuoteAirRequestTrip>
    RETURN
  end
end
