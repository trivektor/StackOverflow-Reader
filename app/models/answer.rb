class Answer
  
  attr_accessor :data

  def initialize(data={})
    @data = data
  end
  
  def body
    @data[:body]
  end
  
  def owner
    User.new(@data[:owner])
  end

  def to_json
    @data.merge(owner: owner.to_json)
  end

end