class LBF::Layover
  attr_reader :duration, :airport

  # NB: The :duration method (and corresponding ivar) are in seconds
  def initialize(segment_hash)
    @duration = segment_hash[:connection_duration].to_i.minutes
    @airport  = segment_hash[:dest]
    @comment  = segment_hash[:connection_comment]
  end
end

