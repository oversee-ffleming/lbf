# A traveler, according to LBF
class LBF::Traveler
  TRAVELER_CATEGORY = LBF::Request::CABINS.invert
  def initialize(trav_hash)
    @category       = TRAVELER_CATEGORY[trav_hash[:category].upcase]
    @fare           = BigDecimal.new trav_hash[:fare]
    @taxes_and_fees = BigDecimal.new trav_hash[:fare_tax_and_fees]
    @total_price    = BigDecimal.new trav_hash[:fare_total]
  end
end
