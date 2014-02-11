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

  def categories
    @data['category'].to_a.map do |c|
      c.is_a?(Hash) ? c['text'] : c.last
    end.compact
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