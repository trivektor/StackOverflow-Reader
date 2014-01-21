class LoginController < UIViewController

  include UIViewControllerExtension

  private

  def viewDidLoad
    @authenticated = false
    performHousekeepingTasks
    registerEvents
    loadLoginPage
  end

  def registerEvents
    'MyselfFetched'.add_observer(self, 'reloadApp:')
  end

  def performHousekeepingTasks
    navigationItem.title = 'Login'
    size = view.bounds.size
    @webView = createWebView(frame: [[0, 0], [size.width - 2, size.height - 2]])
    @webView2 = createWebView(frame: [[0, size.height - 2], [size.width, 2]])
    view.addSubview(@webView)
    view.addSubview(@webView2)
    loadLoginPage
  end

  def loadLoginPage
    puts 'start loading oauth url'
    @webView.loadRequest(OAUTH_URL.nsurl.nsurlrequest)
  end

  def webViewDidFinishLoad(webView)
    return if @authenticated
    @webView2.loadRequest(OAUTH_URL.nsurl.nsurlrequest)
    url = webView.request.URL.absoluteString
    puts "absolute url is #{url}"

    if webView == @webView2 && url.include?('http://stackmotion.herokuapp.com/#access_token')
      url = url.gsub('/#', '?')
      parser = DDURLParser.alloc.initWithURLString(url)
      access_token = parser.valueForVariable('access_token')
      puts "access_token is #{access_token}"

      return unless access_token

      SSKeychain.setPassword(access_token, forService: 'access_token', account: APP_KEYCHAIN_ACCOUNT)
      User.fetchMe(access_token)
      @authenticated = true
    end

    true
  end

  def reloadApp(notification)
    'PostLoginReload'.post_notification
    dismissModalViewControllerAnimated(true)
  end

end