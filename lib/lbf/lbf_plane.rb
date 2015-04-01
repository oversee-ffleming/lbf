# A simple object representing an airplane.
class LBF::Plane
  attr_reader :name, :code
  def initialize(name, code)
    @name = name
    @code = code.to_i
  end
end
