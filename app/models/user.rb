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

  def reputation
    @data[:reputation].to_i
  end

  def formatted_reputation
    reputation < 1000 ? reputation : reputation.string_with_style
  end

  def to_json
    @data.merge(
      formatted_reputation: formatted_reputation
    )
  end

end