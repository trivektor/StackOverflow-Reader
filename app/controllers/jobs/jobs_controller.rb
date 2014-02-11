class JobCell < UITableViewCell

  attr_accessor :job, :titleLabel, :subTitleLabel

  CELL_SPACING = 12
  MAX_WIDTH = 276
  TITLE_FONT = 'HelveticaNeue-Medium'.uifont(16)
  SUB_TITLE_FONT = 'HelveticaNeue-Light'.uifont(15)

  def render
    contentView.subviews.each { |v| v.removeFromSuperview }
    maximumLabelSize = CGSizeMake(MAX_WIDTH, CGFLOAT_MAX)

    titleLabelHeight = @job.title.sizeWithFont(TITLE_FONT, constrainedToSize: maximumLabelSize).height
    @titleLabel = UILabel.alloc.initWithFrame([[11, CELL_SPACING], [MAX_WIDTH, titleLabelHeight]])
    @titleLabel.lineBreakMode = NSLineBreakByWordWrapping
    @titleLabel.text = AppHelper.decodeHTMLEntities(@job.title)
    @titleLabel.numberOfLines = 0
    @titleLabel.font = TITLE_FONT
    @titleLabel.sizeToFit

    self.contentView.addSubview(@titleLabel)

    categories = @job.categories.join(', ')
    subTitleLabelHeight = categories.sizeWithFont(SUB_TITLE_FONT, constrainedToSize: maximumLabelSize).height
    @subTitleLabel = UILabel.alloc.initWithFrame([[11, @titleLabel.frame.size.height + CELL_SPACING*3/2], [MAX_WIDTH, subTitleLabelHeight + CELL_SPACING]])
    @subTitleLabel.lineBreakMode = NSLineBreakByWordWrapping
    @subTitleLabel.text = AppHelper.decodeHTMLEntities(categories)
    @subTitleLabel.numberOfLines = 0
    @subTitleLabel.font = SUB_TITLE_FONT
    @subTitleLabel.textColor = '#999'.uicolor
    @subTitleLabel.sizeToFit

    contentView.addSubview(@subTitleLabel)
    defineAccessoryType
  end

end

class JobsController < BaseController

  def init
    super
    @jobs = []
    self
  end

  protected

  def viewDidLoad
    super
    performHousekeepingTasks
    registerEvents
    Job.top
  end

  def performHousekeepingTasks
    super
    @table = createTable(cell: JobCell)
    view.addSubview(@table)
  end

  def registerEvents
    'JobsFetched'.add_observer(self, 'displayJobs:')
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @jobs.count
  end

  def tableView(tableView, jobForRowAtIndexPath: indexPath)
    @jobs[indexPath.row]
  end

  def sizeOfLabel(label, withText: text)
    text.sizeWithFont(label.font, constrainedToSize:label.frame.size, lineBreakMode:label.lineBreakMode)
  end

  def tableView(tableView, heightForRowAtIndexPath: indexPath)
    # Calculate title label height
    job = tableView(tableView, jobForRowAtIndexPath: indexPath)
    maximumLabelSize = CGSizeMake(JobCell::MAX_WIDTH, CGFLOAT_MAX)
    expectedLabelSize1 = AppHelper.decodeHTMLEntities(job.title).sizeWithFont(QuestionCell::TITLE_FONT, constrainedToSize: maximumLabelSize)
    expectedLabelSize2 = AppHelper.decodeHTMLEntities(job.categories.join(', ')).sizeWithFont(QuestionCell::SUB_TITLE_FONT, constrainedToSize: maximumLabelSize)
    [QuestionCell::CELL_SPACING, expectedLabelSize1.height, QuestionCell::CELL_SPACING, expectedLabelSize2.height, QuestionCell::CELL_SPACING/2].reduce(:+)
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier(JobCell.reuseIdentifier) || begin
      JobCell.alloc.initWithStyle(UITableViewCellStyleDefault, JobCell.reuseIdentifier)
    end

    cell.job = tableView(tableView, jobForRowAtIndexPath: indexPath)
    cell.render
    cell
  end

  def displayJobs(notification)
    @jobs = notification.object
    @table.reloadData
  end

end