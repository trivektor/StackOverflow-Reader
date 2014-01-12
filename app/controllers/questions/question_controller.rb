class QuestionController < UIViewController

  include UIViewControllerExtension
  include AppHelper

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
    @webView.loadHTMLString(decodeHTMLEntities(renderedHtml), baseURL: NSURL.fileURLWithPath(NSBundle.mainBundle.bundlePath))
  end

  def performHousekeepingTasks
    navigationItem.title = decodeHTMLEntities(@question.title)
    @webView = createWebView
    view.addSubview(@webView)
    navigationItem.rightBarButtonItem = createFontAwesomeButton(icon: 'cog', color: UIColor.whiteColor, touchHandler: 'displayOptions')
  end

  def displayOptions
  end

end