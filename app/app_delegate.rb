class AppDelegate

  attr_accessor :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
  	self.window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    self.window.backgroundColor = UIColor.whiteColor
    self.window.makeKeyAndVisible

    whiteColor = UIColor.whiteColor

    UINavigationBar.appearance.setTitleTextAttributes(
      NSForegroundColorAttributeName => whiteColor,
      UITextAttributeTextColor => whiteColor,
      UITextAttributeFont => NAVIGATION_BAR_FONT,
      UITextAttributeTextShadowColor => UIColor.clearColor
    )

    UINavigationBar.appearance.setBarTintColor(NAVIGATION_BAR_COLOR)
    UINavigationBar.appearance.setTintColor(whiteColor)

    UIBarButtonItem.appearance.setTintColor(whiteColor)

    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent

    topQuestionsController = TopQuestionsController.alloc.init
    navController = UINavigationController.alloc.initWithRootViewController(topQuestionsController)
    navController.navigationBar.translucent = false
    navController.navigationBar.tintColor = whiteColor

    menuController = MenuController.alloc.init

    sideMenuController = RESideMenu.alloc.initWithContentViewController(navController, menuViewController: menuController)
    sideMenuController.parallaxEnabled = false
    sideMenuController.panGestureEnabled = false
    sideMenuController.contentViewScaleValue = 0.8
    sideMenuController.delegate = UIApplication.sharedApplication.delegate

    self.window.rootViewController = sideMenuController
    # if AppHelper.access_token
    #   "access_token when app start is #{AppHelper.access_token}"
    #   User.fetchMe(AppHelper.access_token)
    # end
    true
  end
end
