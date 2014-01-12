module UIViewControllerExtension

  def createTable(options={})
    table = UITableView.alloc.initWithFrame(
      options[:frame] || self.view.bounds,
      style: options[:style] || UITableViewStylePlain
    )

    table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    table.delegate = self
    table.dataSource = self

    if options[:scrollEnabled].nil?
      table.setScrollEnabled(true)
    else
      table.setScrollEnabled(options[:scrollEnabled])
    end

    unless options[:cell].nil?
      table.registerClass(options[:cell], forCellReuseIdentifier: options[:cell].reuseIdentifier)
    end

    table.backgroundView = nil
    table
  end

  def createWebView(options={})
    webView = UIWebView.alloc.initWithFrame(options[:frame] || self.view.bounds)
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    webView.delegate = self
    webView
  end

  def createFontAwesomeButton(options={})
    btn = UIBarButtonItem.titled(FontAwesome.icon(options[:icon])) do
      self.send(options[:touchHandler])
    end

    btn.setTitleTextAttributes({
      UITextAttributeFont => FontAwesome.fontWithSize(options[:size] || 20),
      UITextAttributeTextColor => (options[:color] || :black).uicolor
    }, forState: UIControlStateNormal)
  end

  def loadTemplate(path, type='mustache')
    file = NSBundle.mainBundle.pathForResource(path, ofType: type)
    html = NSString.stringWithContentsOfFile(file, encoding: NSUTF8StringEncoding, error: nil)
    GRMustacheTemplate.templateFromString(html, error: nil)
  end

end