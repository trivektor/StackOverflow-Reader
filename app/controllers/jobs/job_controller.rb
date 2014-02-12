class JobController < BaseController

  attr_accessor :job

  def initWithJob(job)
    @job = job
    self
  end

  def viewDidLoad
    performHousekeepingTask
    showProgress
    displayJob
  end

  def performHousekeepingTask
    navigationItem.title = 'Job'
    @webView = createWebView
    view.addSubview(@webView)
  end

  def displayJob
    file = NSBundle.mainBundle.pathForResource('templates/job', ofType: 'mustache')
    html = NSString.stringWithContentsOfFile(file, encoding: NSUTF8StringEncoding, error: nil)
    puts @job.to_json
    renderedHtml = GRMustacheTemplate.renderObject(NSDictionary.dictionaryWithDictionary({
      job: @job.to_json
    }), fromString: html, error: nil)
    @webView.loadHTMLString(AppHelper.decodeHTMLEntities(renderedHtml), baseURL: NSURL.fileURLWithPath(NSBundle.mainBundle.bundlePath))
    hideProgress
  end

end