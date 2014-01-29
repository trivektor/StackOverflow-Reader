class UserController < BaseController

  attr_accessor :user

  def initWithUser(user)
    @user = user
    self
  end

  private

  def viewDidLoad
    performHousekeepingTasks
    registerEvents
    @user.fetchQuestions
    showProgress
  end

  def performHousekeepingTasks
    navigationItem.title = 'Profile'
    @webView = createWebView
    view.addSubview(@webView)
  end

  def registerEvents
    'ProfileQuestionsFetched'.add_observer(self, 'fetchTags')
    'ProfileTagsFetched'.add_observer(self, 'fetchBadges')
    'ProfileBadgesFetched'.add_observer(self, 'displayProfile')
  end

  def fetchTags
    @user.fetchTags
  end

  def fetchBadges
    @user.fetchBadges
  end

  def displayProfile
    file = NSBundle.mainBundle.pathForResource('templates/user', ofType: 'mustache')
    html = NSString.stringWithContentsOfFile(file, encoding: NSUTF8StringEncoding, error: nil)

    renderedHtml = GRMustacheTemplate.renderObject(NSDictionary.dictionaryWithDictionary({
      user: @user.to_json,
      questions: @user.questions.map { |q| q.to_json },
      tags: @user.tags.map { |t| t.to_json },
      badges: @user.badges.map { |b| b.to_json }
    }), fromString: html, error: nil)
    @webView.loadHTMLString(AppHelper.decodeHTMLEntities(renderedHtml), baseURL: NSURL.fileURLWithPath(NSBundle.mainBundle.bundlePath))
    hideProgress
  end

end