class LoginController < UIViewController

  include UIViewControllerExtension

  private

  def viewDidLoad
    performHousekeepingTasks
    registerEvents
    loadLoginPage
  end

  def registerEvents
    'MyselfFetched'.add_observer(self, 'reloadApp:')
  end

  def performHousekeepingTasks
    navigationItem.title = 'Login'
    @webView = createWebView
    view.addSubview(@webView)
  end

  def loadLoginPage
    # file = NSBundle.mainBundle.pathForResource('templates/login', ofType: 'mustache')
    # html = NSString.stringWithContentsOfFile(file, encoding: NSUTF8StringEncoding, error: nil)
    #
    # renderedHtml = GRMustacheTemplate.renderObject({}, fromString: html, error: nil)
    # @webView.loadHTMLString(decodeHTMLEntities(renderedHtml), baseURL: NSURL.fileURLWithPath(NSBundle.mainBundle.bundlePath))
    @webView.loadRequest("https://stackexchange.com/oauth?client_id=#{STACK_EXCHANGE_CLIENT_ID}&scope=#{STACK_EXCHANGE_SCOPES.join(',')}&redirect_uri=#{STACK_EXCHANGE_REDIRECT_URI}".nsurl.nsurlrequest)
  end

  def webViewDidFinishLoad(webView)
    url = webView.request.URL.absoluteString

    if url.include? 'stackmotion.herokuapp.com'
      puts url
      parser = DDURLParser.alloc.initWithURLString(url)
      code = parser.valueForVariable('code')
      puts "code is #{code}"

      params = {
        client_id: STACK_EXCHANGE_CLIENT_ID,
        client_secret: STACK_EXCHANGE_SECRET,
        code: code,
        redirect_uri: STACK_EXCHANGE_REDIRECT_URI
      }

      client = AFMotion::Client.build('https://stackexchange.com') do
        response_serializer :form
      end

      client.post("/oauth/access_token", params) do |result|
        if result.success?
          token = result.object.to_s.gsub('access_token=', '')
          SSKeychain.setPassword(token, forService: 'access_token', account: APP_KEYCHAIN_ACCOUNT)
          User.fetchMe(token)
        else
          puts result.error.localizedDescription
        end
      end
    end

    true
  end

  def reloadApp(notification)
    'PostLoginReload'.post_notification
    dismissModalViewControllerAnimated(true)
  end

end