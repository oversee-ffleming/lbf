# Each Quote is a proposal from LBF for the requested trip.  Its trips are the legs of the flight: there will
# be one trip in :trips if it is a one-way flight, and two if it is a round-trip flight.  Each quote has a
# pile of IDs that are used to create the appropriate URL string for checkout (which currently doesn't seem
# to work, but was created according to the API docs).
#
# Of particular note are the all_cabins? and nearby_airports? methods.  If all_cabins? is true, then the
# quote will include at least one segment in a cabin type other than that specified in the LBF::Request.
# Similarly, if :nearby_airports? is true, then either the origin or destination is not that which was
# requested, but rather an airport that is nearby.
#
# If :offline_only? is true, then we can't display actual inforamtion about the trip.  We can just display
# the price and a number to call for booking information.
class LBF::Quote
  # Has Trip(s) and IDs and Travelers
  attr_reader :arrival, :departure, :fare, :trips, :travelers, :warnings, :cabin_comments,
              :id, :group_id, :session_id, :tickets, :seats_remaining

  def initialize(quote_hash)
    @hash            = quote_hash
    @arrival         = DateTime.strptime("#{quote_hash[:arr_dt]} #{quote_hash[:arr_tm]}", '%m/%d/%Y %H%M')
    @departure       = DateTime.strptime("#{quote_hash[:dep_dt]} #{quote_hash[:dep_tm]}", '%m/%d/%Y %H%M')
    @fare            = LBF::Fare.new quote_hash[:quote_air_fare]
    @trips           = trips_from(quote_hash.deep_fetch :quote_air_trips, :quote_air_trip)
    @travelers       = travelers_from(quote_hash.deep_fetch :quote_air_travelers, :quote_air_traveler)
    @warnings        = warnings_from(quote_hash[:warning])
    @cabin_comments  = cabin_comments_from(quote_hash[:cabin_comments])
    @id              = quote_hash[:air_quote_id]
    @group_id        = quote_hash[:session_air_id]
    @session_id      = quote_hash[:visit_session_id]
    @tickets         = quote_hash[:tickets].to_i
    @seats_remaining = quote_hash[:seats_remaining].to_i
    @all_cabins      = quote_hash[:cabin_indicator].to_i == 1
    @international   = !!quote_hash[:international]
    @nearby_airports = !!quote_hash[:nearby_airport_indicator]
    @offline_only    = !!quote_hash[:offline_airline_indicator]
    @tournet         = !!quote_hash[:tournet_indicator]
  end

  def to_h
    @hash
  end

  def query_string
    "?AirSID=#{group_id}&FARE=#{id}&SesnID=#{session_id}"
  end

  def tournet?
    @tournet
  end

  def all_cabins?
    @all_cabins
  end

  def online?
    !offline_only?
  end

  def offline_only?
    @offline_only
  end

  def international?
    @international
  end

  def domestic?
    !international?
  end

  private

  def cabin_comments_from(comments_str)
    return '' if comments_str.nil?
    comments_str.to_s
  end

  # The API doc don't specify how this works, so I'm assuming it's the same as the comments field.
  def warnings_from(warning_str)
    return '' if warning_str.nil?
    warning_str.to_s
  end

  # The appropriate deep_fetch can return either a hash or an array of hashes,
  # so we have to handle that in this method
  def trips_from(trip_arr)
    return [] if trip_arr.nil?
    trip_arr = [trip_arr].flatten
    trip_arr.map {|t| LBF::Trip.new(t)}
  end

  # The appropriate deep_fetch can return either a hash or an array of hashes,
  # so we have to handle that in this method
  def travelers_from(trav_arr)
    return [] if trav_arr.nil?
    trav_arr = [trav_arr].flatten
    trav_arr.map {|t| LBF::Traveler.new(t)}
  end
end
