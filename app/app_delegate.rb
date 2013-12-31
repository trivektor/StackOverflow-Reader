class AppDelegate

  attr_accessor :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
  	self.window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    self.window.backgroundColor = UIColor.whiteColor
    self.window.makeKeyAndVisible

    topQuestionsController = TopQuestionsController.alloc.init
    navController = UINavigationController.alloc.initWithRootViewController(topQuestionsController)
    self.window.rootViewController = navController
    true
  end
end
