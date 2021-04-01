//
//  SubwayStationView.swift
//  map
//
//  Created by 코드잉 on 2021/03/04.
//

import UIKit

class SubwayStationView: UIView {
    private var downwayViews = [SubwayView]()
    private var upwayViews = [SubwayView]()

    @IBOutlet weak private var secondDownwaySubwayView: SubwayView?
    @IBOutlet weak private var firstDownwaySubwayView: SubwayView?
    @IBOutlet weak private var secondUpwaySubwayView: SubwayView?
    @IBOutlet weak private var firstUpwaySubwayView: SubwayView?
    @IBOutlet weak private var subwayStationNameLabel: UILabel?
    @IBOutlet weak private var subwayLaneTypeLabel: UILabel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }

    private func customInit() {
        let nib = UINib(nibName: "SubwayStationView", bundle: nil)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            addSubview(view)
            view.frame = self.bounds
            subwayLaneTypeLabel?.layer.cornerRadius = 8
            subwayLaneTypeLabel?.backgroundColor = .blue
            subwayLaneTypeLabel?.textColor = .blue
        }
        setUpSubwayViews()
    }

    private func setUpSubwayViews() {
        upwayViews = [firstUpwaySubwayView, secondUpwaySubwayView].compactMap { $0 }
        downwayViews = [firstDownwaySubwayView, secondDownwaySubwayView].compactMap { $0 }
    }

    func updateUI(for stationInfo: StationInfo) {
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
