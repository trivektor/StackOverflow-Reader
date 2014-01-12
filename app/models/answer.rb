class Answer
  
  attr_accessor :data

  def initialize(data={})
    @data = data
  end
  
  def body
    @data[:body]
  end
  
  def to_json
    @data
  end

end