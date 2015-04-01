# A trip, e.g. from LAS to LAX.  Will contain multiple segments if it isn't a non-stop flight.  Also
# includes layover information.  Segments can have segment stops, for stops that aren't segments. This might
# mean that the plane stops, but the traveler doesn't get off.  It's not clear from the documentation.
# Segment stops are not exposed.
class LBF::Trip
  attr_reader :duration, :arrival, :departure, :origin, :destination, :notes

  # NB: The :duration method (and corresponding ivar) are in seconds
  def initialize(trip_hash)
    @duration    = trip_hash[:duration].to_i.minutes
    @arrival     = DateTime.strptime("#{trip_hash[:arr_dt]} #{trip_hash[:arr_tm]}", '%m/%d/%Y %H%M')
    @departure   = DateTime.strptime("#{trip_hash[:dep_dt]} #{trip_hash[:dep_tm]}", '%m/%d/%Y %H%M')
    @origin      = trip_hash[:orig]
    @destination = trip_hash[:dest]
    @notes       = trip_hash[:duration_notes]
    @segments    = segments_from(trip_hash.deep_fetch :quote_air_segments, :quote_air_segment)
    @layovers    = layovers_from(trip_hash.deep_fetch :quote_air_segments, :quote_air_segment)
  end

  private

  def layovers_from(segment_arr)
    return [] if segment_arr.nil?
    segment_arr.map { |s| LBF::Layover.new(s) unless s[:connection_duration].to_i == 0 }.compact
  end

  def segments_from(segment_arr)
    return [] if segment_arr.nil?
    segment_arr.map { |s| LBF::Segment.new s }
  end

end
