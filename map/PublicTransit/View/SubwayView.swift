//
//  SubwayView.swift
//  map
//
//  Created by 코드잉 on 2021/03/05.
//

import UIKit

class SubwayView: UIView {
    @IBOutlet weak private var subwayTypeLabel: UILabel?
    @IBOutlet weak private var arrivingTimeLabel: UILabel?
    @IBOutlet weak private var headSignLabel: UILabel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }

    private func customInit() {
        let nib = UINib(nibName: "SubwayView", bundle: nil)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            addSubview(view)
            view.frame = self.bounds
        }
    }

    func updateUI(for subwayInfo: SubwayInfo) {
        let arrivalTime = subwayInfo.remainigTime
        if arrivalTime == 0 {
            arrivingTimeLabel?.text = "곧 도착"
        } else {
            arrivingTimeLabel?.text = "\(arrivalTime)분"
        }
        if subwayInfo.operationType == Setting.SubwayType.express.rawValue {
            subwayTypeLabel?.isHidden = false
        } else {
            subwayTypeLabel?.isHidden = true
        }
        headSignLabel?.text = subwayInfo.headsign
    }
}
