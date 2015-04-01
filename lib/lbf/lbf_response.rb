# Returned by LBF::Client.search. This object contains an array of LBF::Quotes and an array of
# LBF::SearchErrors.  :quotes will have a single element if a one-way flight was requeted, and two
# if a roundtrip flight was requested.
class LBF::Response
  attr_reader :quotes, :errors
  def initialize(hsh)
    @hash = hsh
    @errors = errors_from(@hash.deep_fetch :afs1_response, :afs1_result, :quote_air, :error_list)
    @quotes = quotes_from(@hash.deep_fetch :afs1_response, :afs1_result, :quote_air)
  end

  def to_h
    @hash
  end

  def error?
    !errors.empty?
  end

  private

  def errors_from(err_hash)
    return [] if err_hash.nil?
    err_hash.values.map { |msg| LBF::SearchError.new(msg) }
  end

  # Can be a hash or an array of hashes, so we have to handle that
  def quotes_from(quotes_arr)
    return [] if quotes_arr.nil?
    quotes_arr = [quotes_arr].flatten
    quotes_arr.map { |q| LBF::Quote.new(q) }
  end
end
