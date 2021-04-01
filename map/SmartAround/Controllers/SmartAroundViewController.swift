//
//  SmartAroundViewController.swift
//  map
//
//  Created by USER on 2021/01/25.
//
import UIKit

class SmartAroundViewController: UIViewController {

    @IBOutlet weak var smartAroundTableView: UITableView?
    private var isExpanded = false
    private var isScrolled = false
    private var addressString: String?
    private var places: [Place]?
    private var oldTime: Double = 0.0
    private var newTime: Double = 0.0
    private var timeCheckCounter = 0
    weak var defaultViewControllerDelegate: DefaultViewControllerDelegate?
    private let cacheManager = CacheManager()
    private let dataProvider = SmartAroundDataProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        cacheManager.clearMemoryCache()
    }

    private func setupTableView() {
        smartAroundTableView?.dataSource = self
        smartAroundTableView?.isScrollEnabled = false
        initializeNibs()
    }

    private func initializeNibs() {
        let firstSectionHeaderNib = UINib(nibName: "SmartAroundFirstSectionHeader", bundle: nil)
        smartAroundTableView?.register(firstSectionHeaderNib, forHeaderFooterViewReuseIdentifier: "SmartAroundFirstSectionHeader")
        let secondSectionHeaderNib = UINib(nibName: "SmartAroundSecondSectionHeader", bundle: nil)
        smartAroundTableView?.register(secondSectionHeaderNib, forHeaderFooterViewReuseIdentifier: "SmartAroundSecondSectionHeader")
        let secondSectionCellNib = UINib(nibName: "SearchOptionCell", bundle: nil)
        smartAroundTableView?.register(secondSectionCellNib, forCellReuseIdentifier: "SearchOptionCell")
    }

    func update(_ lat: Double, _ lng: Double, _ code: Setting.Code) {
        cacheManager.clearMemoryCache()

        dataProvider.getPlaces(lat, lng, code) { [weak self] places in
            if places != nil {
                self?.places = places
                self?.smartAroundTableView?.reloadData()
                self?.defaultViewControllerDelegate?.defaultViewControllerAddMarkers(for: places ?? [Place]())
            } else {
                Toast.showToast(message: Setting.networkFailureString)
            }
        }

        dataProvider.getAddress(lat, lng) { [weak self] address in
            if address != nil {
                self?.addressString = address
                self?.smartAroundTableView?.reloadData()
            } else {
                Toast.showToast(message: Setting.networkFailureString)
            }
        }
    }

    func isScrollEnabled(_ isScrollEnabled: Bool) {
        smartAroundTableView?.isScrollEnabled = isScrollEnabled
        isScrolled = false
        let indexPath = NSIndexPath(row: NSNotFound, section: 0)
        smartAroundTableView?.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
    }
}

extension SmartAroundViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SmartAroundSectionType(rawValue: section) {
        case .firstSection:
            return 0
        case .secondSection:
            return isExpanded ? 1 : 0
        case .thirdSection:
            return places?.count ?? 0
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let firstHeaderView =
                tableView.dequeueReusableHeaderFooterView(withIdentifier: "SmartAroundFirstSectionHeader") as? SmartAroundFirstSectionHeader
        else { return UITableViewHeaderFooterView() }
        firstHeaderView.addressLabel?.text = addressString
        guard let secondHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SmartAroundSecondSectionHeader") as?
                SmartAroundSecondSectionHeader else { return UITableViewHeaderFooterView() }
        secondHeaderView.delegate = self

        switch SmartAroundSectionType(rawValue: section) {
        case .firstSection:
            return firstHeaderView
        case .secondSection:
            return secondHeaderView
        default:
            return UITableViewHeaderFooterView()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let placeCell = smartAroundTableView?.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as? PlaceCell else {
            return UITableViewCell() }
        guard let place = places?[safe: indexPath.row] else { return UITableViewCell() }
        placeCell.updateUI(place)
        guard let searchOptionCell = smartAroundTableView?.dequeueReusableCell(withIdentifier: "SearchOptionCell", for: indexPath) as?
                SearchOptionCell else { return UITableViewCell() }

        switch SmartAroundSectionType(rawValue: indexPath.section) {
        case .secondSection:
            return searchOptionCell
        case .thirdSection:
            return placeCell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch SmartAroundSectionType(rawValue: section) {
        case .firstSection, .secondSection:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
}

extension SmartAroundViewController: SmartAroundSecondSectionHeaderDelegate {
    func smartAroundSecondSectionHeaderToggleSection() {
        isExpanded = !isExpanded
        UITableViewCell.setAnimationsEnabled(false)
        smartAroundTableView?.reloadSections([1], with: .automatic)
        UITableViewCell.setAnimationsEnabled(true)
    }
}

extension SmartAroundViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isKind(of: UICollectionView.self) {
            return
        }
        let offset = scrollView.contentOffset.y
        let scrollDirection = scrollView.panGestureRecognizer.translation(in: scrollView).y
        if scrollDirection < 0 {
            isScrolled = true
            timeCheckCounter = 0
        }
        if offset <= 0.0 {
            if oldTime == 0.0 {
                oldTime = Date().timeIntervalSince1970
                newTime = Date().timeIntervalSince1970
            } else {
                newTime = Date().timeIntervalSince1970
                let timeInterval = Int((newTime - oldTime) * 10)
                if timeInterval > 1 {
                    timeCheckCounter += 1
                    if timeCheckCounter == 2 {
                        isScrolled = false
                        timeCheckCounter = 0
                    }
                }
            }
            oldTime = newTime

            if scrollDirection > 0 && !isScrolled {
                defaultViewControllerDelegate?.defaultViewControllerAnimateByScroll()
                isScrollEnabled(false)
            }
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
    }
}
