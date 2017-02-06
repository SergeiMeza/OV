
import UIKit

/// Description: Subclass SMBaseTableViewController class to easily create a custom TableViewController object.
/// Call the family of methods setupProperties(...) at viewDidLoad() in order to easily customize this class.
/// Override the method setupCell(_ cell: at:) to customize the cells of this class.
/// Override the method setupTableView to further customize the tableView property at viewDidLoad()
/// Override the method setupHeaderView to further customize the headerView property at viewDidLoad()
open class SMBaseTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
   open let cellID = "CellID"
   
   open var _tableView : UITableView {get { return tableView } set {tableView = newValue}}
   open var _headerView: SMHeaderView01 { get { return headerView } set {headerView = newValue}}
   
   open func setUpTableView(_ tableView: UITableView) {
      tableView.backgroundColor = .white
      tableView.tableFooterView = UIView()
      tableView.separatorStyle = .none
      tableView.showsVerticalScrollIndicator = false
   }
   
   open func setupHeaderView(_ headerView: SMHeaderView01) {
         headerView.rightButton.contentEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
   }
   
   open func setupProperties(tableviewTitle: String, myCellClass: Swift.AnyClass?) {
      self.headerView.titleLabel.text = tableviewTitle
      self.myCellClass = myCellClass
      self.tableView.register(myCellClass.self, forCellReuseIdentifier: cellID)
   }
   
   open func setupProperties(_ data: [Any?]) {
      self.dataSource = data
   }
   
   open func setupProperties(headerHeight: CGFloat, separatorWidth: CGFloat) {
      self.headerHeight = headerHeight
      self.separatorWidth = separatorWidth
   }
   
   open func setupCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
      
   }
   
   @objc open func rightButtonAction() {
      presentingViewController?.dismiss(animated: true, completion: nil)
      _ = navigationController?.popViewController(animated: true)
   }
   
   @objc open func leftButtonAction() {
      
   }
   
   var constraint = Constraint()
   
   fileprivate var dataSource: [Any?] = []
   fileprivate var myCellClass: Swift.AnyClass?
   
   fileprivate var headerHeight: CGFloat = 44 {
      didSet {
         constraint.constant = headerHeight
         updateViewConstraints()
      }
   }
   
   fileprivate var separatorWidth: CGFloat = 6 {
      didSet {
         headerView.separatorWidth = separatorWidth
         updateViewConstraints()
      }
   }
   
   fileprivate lazy var headerView: SMHeaderView01 = { [unowned self] in
      let v = SMHeaderView01()
      v.rightButton.addTarget(self, action: #selector(rightButtonAction), for: [.touchUpInside])
      v.leftButton.addTarget(self, action: #selector(leftButtonAction), for: [.touchUpInside])
      v.separatorWidth = self.separatorWidth
      return v
      }()
   
   fileprivate lazy var tableView : UITableView = { [unowned self] in
      let tv = UITableView.init(frame: .zero, style: .plain)
      tv.backgroundColor = .white
      tv.separatorStyle = .none
      tv.delegate = self
      tv.dataSource = self
      return tv
   }()
   
   override open var prefersStatusBarHidden: Bool {
      return true
   }
   
   override open func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      navigationController?.setNavigationBarHidden(true, animated: true)
   }
   
   override open func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
      setupConstraints()
      setUpTableView(tableView)
      setupHeaderView(headerView)
   }
   
   open func setupViews() {
      view.addSubviews(tableView, headerView)
   }
   
   open func setupConstraints() {
      Constraint.make("H:|[v0]|", views: headerView)
      Constraint.make("H:|[v0]|", views: tableView)
      
      Constraint.make(headerView, .top, superView: .top, 1, 0)
      constraint = Constraint.init(item: headerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: headerHeight)
      headerView.translatesAutoresizingMaskIntoConstraints = false
      constraint.isActive = true
      Constraint.make(headerView, .bottom, tableView, .top, 1, 0)
      Constraint.make(tableView, .bottom, tableView.superview, .bottom, 1, 0)
   }
   
   // MARK: - Table view data source
   
   public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return dataSource.count
   }
   
   
   public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
      setupCell(cell, at: indexPath)
      return cell
   }
}
