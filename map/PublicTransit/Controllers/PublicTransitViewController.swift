//
//  PTViewController.swift
//  map
//
//  Created by USER on 2021/01/25.
//

import UIKit

class PublicTransitViewController: UIViewController {

    @IBOutlet weak private var buttonsStackView: UIStackView?
    @IBOutlet weak private var countDownLabel: UILabel?
    @IBOutlet weak private var currentTimeLabel: UILabel?
    @IBOutlet weak private var publicTransitTableView: UITableView?
    private let publicTransitTableViewDataSource = PublicTransitTableViewDataSource()
    private let publicTransitDataProvider = PublicTransitDataProvider()
    private var timer: Timer?
    private var countDown = 15
    private var lastCallTime = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        setForGestureRecognizer()
        updateUI()
        addObserver()
        setupTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopTimer()
    }

    private func setupTableView() {
        let busNib = UINib(nibName: "BusStationCell", bundle: nil)
        let subwayNib = UINib(nibName: "SubwayStationCell", bundle: nil)

        publicTransitTableView?.register(busNib, forCellReuseIdentifier: "BusStationCell")
        publicTransitTableView?.register(subwayNib, forCellReuseIdentifier: "SubwayStationCell")
        publicTransitTableView?.dataSource = publicTransitTableViewDataSource
    }

    @objc private func startTimer() {
        stopTimer()
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        if let timer = timer {
            RunLoop.current.add(timer, forMode: .common)
            countDown = 16
        }
    }

    @objc private func stopTimer() {
        timer?.invalidate()
    }

    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(startTimer), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopTimer), name: UIApplication.willResignActiveNotification, object: nil)
    }

    private func setForGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapRefreshButton))
        buttonsStackView?.addGestureRecognizer(tapGesture)
    }

    @objc private func tapRefreshButton() {
        let now = Date()
        if intervalSinceLastCall(until: now) > 0.1 {
            updateUI()
            lastCallTime = now
            countDown = 1
        }
    }

    @objc private func updateTimer() {
        updateCurrentTime()
        updateCountDown()
    }

    private func updateCountDown() {
        countDown -= 1
        countDownLabel?.text = "\(countDown)"
        if countDown == 0 {
            countDown = 16
            updateUI()
        }
    }

    private func updateCurrentTime() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "a h:mm"
        currentTimeLabel?.text = formatter.string(from: Date())
    }

    private func updateUI() {
        publicTransitDataProvider.getArrivalInfo { [weak self] transitInfo in
            if transitInfo != nil {
                self?.publicTransitTableViewDataSource.transitInfo = transitInfo
                self?.publicTransitTableView?.reloadData()
            } else {
                Toast.showToast(message: Setting.networkFailureString)
            }
        }
    }

    private func intervalSinceLastCall(until currentTime: Date) -> Double {
        currentTime.timeIntervalSince(lastCallTime)
    }
}
