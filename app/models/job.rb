class Job

  attr_accessor :data

  def initialize(data={})
    @data = data
  end

  def title
    @data['title']['text']
  end

  def link
    @data['link']['text']
  end

  def description
    @data['description']['text']
  end

  def created_at
    @data['pubDate']['text']
  end

  def updated_at
    @data['a10:updated']['text']
  end

  def categories
    @data['category'].to_a.map do |c|
      c.is_a?(Hash) ? c['text'] : c.last
    end.compact
  end

  def to_json
    {
      'title' => title,
      'description' => description,
      'created_at' => created_at,
      'updated_at' => updated_at,
      'categories' => categories
    }
  end

  def self.top(options={})
    url = 'http://careers.stackoverflow.com/jobs/feed'
    request = NSURLRequest.requestWithURL(url.nsurl)
    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue, completionHandler: lambda do |response, data, error|
      dictionary = XMLReader.dictionaryForXMLData(data, error: nil)
      'JobsFetched'.post_notification(dictionary['rss']['channel']['item'].map { |h| self.new(h) })
    end)
  end

end