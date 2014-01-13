class BaseController < UIViewController

  include UIViewControllerExtension
  include AppHelper

  def performHousekeepingTasks
    if navigationController.viewControllers.count == 1
      menuButton = UIBarButtonItem.alloc.initWithImage('399-list1.png'.uiimage, landscapeImagePhone: nil, style: UIBarButtonItemStyleBordered, target: self, action: 'showMenu')
      navigationItem.leftBarButtonItem = menuButton
    end
  end

  def showMenu
    sideMenuViewController.presentMenuViewController
  end

end