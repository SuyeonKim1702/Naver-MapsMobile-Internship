//
//  SubwayStationCell.swift
//  map
//
//  Created by 코드잉 on 2021/03/08.
//

import UIKit

class SubwayStationCell: UITableViewCell {
    private var downwayViews = [SubwayView]()
    private var upwayViews = [SubwayView]()
    @IBOutlet weak private var secondDownwaySubwayView: SubwayView?
    @IBOutlet weak private var firstDownwaySubwayView: SubwayView?
    @IBOutlet weak private var secondUpwaySubwayView: SubwayView?
    @IBOutlet weak private var firstUpwaySubwayView: SubwayView?
    @IBOutlet weak private var subwayStationNameLabel: UILabel?
    @IBOutlet weak private var subwayLaneTypeLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupSubwayViews()
        stylingViews()
    }

    private func stylingViews() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.publicTransitTableViewCellBorderColor.cgColor
        layer.cornerRadius = 10

        subwayLaneTypeLabel?.layer.cornerRadius = 8
        subwayLaneTypeLabel?.textAlignment = .center
        subwayLaneTypeLabel?.textColor = .white
    }

    private func setupSubwayViews() {
        upwayViews = [firstUpwaySubwayView, secondUpwaySubwayView].compactMap { $0 }
        downwayViews = [firstDownwaySubwayView, secondDownwaySubwayView].compactMap { $0 }
    }

    func updateUI(for stationInfo: StationInfo) {
        subwayLaneTypeLabel?.layer.backgroundColor = UIColor(stationInfo.subwayLaneType?.color ?? "#ffffff").cgColor
        subwayStationNameLabel?.text = stationInfo.displayName
        subwayLaneTypeLabel?.text = stationInfo.subwayLaneType?.iconName
        guard let upwayArrivalInfo = stationInfo.subwayArrival?.upWays,
              let downwayArrivalInfo = stationInfo.subwayArrival?.downWays else { return }

        for (subwayView, upwayArrivalInfo) in zip(upwayViews, upwayArrivalInfo) {
            subwayView.updateUI(for: upwayArrivalInfo)
        }
        for (subwayView, downwayArrivalInfo) in zip(downwayViews, downwayArrivalInfo) {
            subwayView.updateUI(for: downwayArrivalInfo)
        }
    }
}
