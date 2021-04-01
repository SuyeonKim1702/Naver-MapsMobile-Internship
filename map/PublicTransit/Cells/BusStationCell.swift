//
//  BusStationCell.swift
//  map
//
//  Created by 코드잉 on 2021/03/08.
//

import UIKit

class BusStationCell: UITableViewCell {

    private var remainingTimeLabels = [UILabel]()
    private var remainingStopLabels = [UILabel]()
    @IBOutlet weak private var busStationNameLabel: UILabel?
    @IBOutlet weak private var busStationCodeLabel: UILabel?
    @IBOutlet weak private var busTypeLabel: UILabel?
    @IBOutlet weak private var directionLabel: UILabel?
    @IBOutlet weak private var busNameLabel: UILabel?
    @IBOutlet weak private var secondRemainingTimeLabel: UILabel?
    @IBOutlet weak private var firstRemainingTimeLabel: UILabel?
    @IBOutlet weak private var firstRemainingStopLabel: UILabel?
    @IBOutlet weak private var secondRemainingStopLabel: UILabel?
    @IBOutlet weak private var outerView: UIView?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupBusInfoLabels()
        stylingViews()
    }

    private func stylingViews() {
        outerView?.layer.borderWidth = 1
        outerView?.layer.borderColor = UIColor.publicTransitTableViewCellBorderColor.cgColor
        outerView?.layer.cornerRadius = 10
    }

    private func setupBusInfoLabels() {
        remainingStopLabels = [firstRemainingStopLabel, secondRemainingStopLabel].compactMap { $0 }
        remainingTimeLabels = [firstRemainingTimeLabel, secondRemainingTimeLabel].compactMap { $0 }
    }

    func updateUI(for stationInfo: StationInfo) {
        busStationNameLabel?.text = stationInfo.displayName
        busStationCodeLabel?.text = stationInfo.displayCode
        if let direction = stationInfo.direction {
            directionLabel?.text = "\(direction) 방면"
        }
        let busInfo = stationInfo.busRoutes[safe: 0]
        busTypeLabel?.text = busInfo?.typeName
        busNameLabel?.text = busInfo?.name
        guard let busesArrivalInfo = busInfo?.arrivalInfo else { return }

        for i in 0..<2 {
            if let remainingTime = busesArrivalInfo[safe: i]?.remainingTime {
                let remainingMinute = remainingTime / 60
                if remainingMinute == 0 {
                    remainingTimeLabels[safe: i]?.text = "곧 도착"
                } else {
                    remainingTimeLabels[safe: i]?.text = "\(remainingMinute)분"
                }
            }
            if let remainingStop = busesArrivalInfo[safe: i]?.remainingStop {
                remainingStopLabels[safe: i]?.text = "\(remainingStop)정류장"
            }
        }
    }
}
