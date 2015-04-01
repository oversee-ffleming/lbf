# A segment of an LBF trip.  Since not everything from the incoming segment_hash is exposed, see comment
# below for segment information
class LBF::Segment
  attr_reader :plane, :origin, :destination, :airline, :comments, :arrival, :departure, :flight
  def initialize(segment_hash)
    # {
    # :equipment=>"Canadair Regional Jet 900", :e_ticket=>true, :equipment_code=>"CR9", :flight_stops=>"0",
    # :airline=>"US", :orig=>"DFW", :duration=>nil, :dest=>"SDF", :airline_name=>"Us Airways",
    # :flight_operator=>nil, :codeshare_comments=>"MESA AIRLINES AS AMERICAN EAGLE",
    # :flight_operator_name=>"MESA AIRLINES AS AMERICAN EAGLE", :flight_number=>"5746",
    # :orig_name=>"Dallas, Fort Worth Intl", :dest_name=>"Louisville,  Louisville Intl",
    # :arr_dt=>"04/04/2015", :dep_dt=>"04/04/2015", :arr_tm=>"1819", :dep_tm=>"1510", :arr_terminal=>nil,
    # :dep_terminal=>"B", :connection_duration=>"0",
    # :seats=>"7", :class_of_service=>"V", :cabin=>"Y",
    # :cabin_name=>"Economy",
    # :comments=> {
    #   :string=>"Operated By MESA AIRLINES AS AMERICAN EAGLE"
    #   },
    # :segment_stops=> {
    #   :quote_air_segment_stop=> {
    #     :airport=>"DEN",
    #     :arrive_date=>"4/8/2015",
    #     :arrive_time=>"1531",
    #     :depart_date=>"4/8/2015",
    #     :depart_time=>"1621"
    #     }
    #   }
    # }
    @plane            = LBF::Plane.new(segment_hash[:equipment], segment_hash[:equipment_code])
    @e_ticket         = segment_hash[:e_ticket]
    @stops            = segment_hash[:flight_stops].to_i
    @origin           = segment_hash[:orig]
    @destination      = segment_hash[:dest]
    @airline          = segment_hash[:airline_name]
    @comments         = comments_from segment_hash[:comments]
    @arrival          = DateTime.strptime("#{segment_hash[:arr_dt]} #{segment_hash[:arr_tm]}", '%m/%d/%Y %H%M')
    @departure        = DateTime.strptime("#{segment_hash[:dep_dt]} #{segment_hash[:dep_tm]}", '%m/%d/%Y %H%M')
    @flight           = segment_hash[:flight_number].to_i
  end

  def e_ticket?
    @e_ticket
  end

  private

  def comments_from(comments_hash)
    return [] if comments_hash.nil?
    comments_hash.values
  end
end
