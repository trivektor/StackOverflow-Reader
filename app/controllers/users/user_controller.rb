class UserController < BaseController

  attr_accessor :user

  def initWithUser(user)
    @user = user
    self
  end

  private

  def viewDidLoad
    performHousekeepingTasks
    displayProfile
  end

  def performHousekeepingTasks
    navigationItem.title = 'Profile'
    @webView = createWebView
    view.addSubview(@webView)
  end

  def displayProfile
    file = NSBundle.mainBundle.pathForResource('templates/user', ofType: 'mustache')
    html = NSString.stringWithContentsOfFile(file, encoding: NSUTF8StringEncoding, error: nil)
    renderedHtml = GRMustacheTemplate.renderObject(NSDictionary.dictionaryWithDictionary({
      user: user.to_json
    }), fromString: html, error: nil)
    @webView.loadHTMLString(AppHelper.decodeHTMLEntities(renderedHtml), baseURL: NSURL.fileURLWithPath(NSBundle.mainBundle.bundlePath))
  end

end