class QuestionController < BaseController

  attr_accessor :question

  def initWithQuestion(question)
    @question = question
    self
  end

  private

  def viewDidLoad
    super
    performHousekeepingTasks
    registerEvents
    fetchAnswers
    showProgress
  end

  def registerEvents
    'AnswersFetched'.add_observer(self, 'displayAnswers:')
  end

  def fetchAnswers
    @question.fetchAnswers
  end

  def displayAnswers(notification)
    file = NSBundle.mainBundle.pathForResource('templates/question', ofType: 'mustache')
    html = NSString.stringWithContentsOfFile(file, encoding: NSUTF8StringEncoding, error: nil)

    renderedHtml = GRMustacheTemplate.renderObject(NSDictionary.dictionaryWithDictionary({
      question: question.to_json,
      answers: notification.object.map { |a| a.to_json }
    }), fromString: html, error: nil)
    @webView.loadHTMLString(AppHelper.decodeHTMLEntities(renderedHtml), baseURL: NSURL.fileURLWithPath(NSBundle.mainBundle.bundlePath))
    hideProgress
  end

  def performHousekeepingTasks
    navigationItem.title = 'Question'
    @webView = createWebView
    view.addSubview(@webView)
    navigationItem.rightBarButtonItem = createFontAwesomeButton(icon: 'cog', color: UIColor.whiteColor, touchHandler: 'displayOptions')
  end

  def displayOptions
  end

end