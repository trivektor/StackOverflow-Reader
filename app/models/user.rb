class User

  include AFNetworkingClient

  attr_accessor :data

  def initialize(data={})
    @data = data
    initAFNetworkingClient
  end

  def avatar
    @data[:profile_image]
  end

  def display_name
    @data[:display_name]
  end

  def to_json
    @data
  end

end