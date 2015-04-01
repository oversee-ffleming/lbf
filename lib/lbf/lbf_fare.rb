# This is fare information for LBF.  Not all keys from the fare_hash are exposed in the object; see below
# if we need to expand.
class LBF::Fare
  def initialize(fare_hash)
    # {:base=>"1653.9400", :tax_and_fees=>"272.4600", :total=>"1926.4000", :sale_total=>"1926.4000",
    # :promo_code=>nil, :promo_discount=>"0.0000", :insurance_total=>"0", :markup=>"0",
    # :tax_and_fees_adult=>"136.2300", :tax_and_fees_child=>"136.2300", :tax_and_fees_infant=>"0",
    # :fare_type=>"P", :insurance_per_traveler=>"0"}
    @base                   = BigDecimal.new fare_hash[:base]
    @taxes_and_fees         = BigDecimal.new fare_hash[:tax_and_fees]
    @total                  = BigDecimal.new fare_hash[:total]
    @markup                 = BigDecimal.new fare_hash[:markup]
    @fare_type              = fare_hash[:fare_type]
    @discount               = BigDecimal.new fare_hash[:promo_discount]
    @promo_code             = fare_hash[:promo_code] || 'None'
    @insurance_per_traveler = BigDecimal.new fare_hash[:insurance_per_traveler]
  end
end
