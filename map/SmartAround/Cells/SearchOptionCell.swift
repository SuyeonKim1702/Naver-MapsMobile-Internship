//
//  SearchOptionCell.swift
//  map
//
//  Created by USER on 2021/02/02.
//

import UIKit

class SearchOptionCell: UITableViewCell {

    var timeButtons: [UIButton] = [UIButton]()
    @IBOutlet weak var morningButton: UIButton?
    @IBOutlet weak var lunchButton: UIButton?
    @IBOutlet weak var afternoonButton: UIButton?
    @IBOutlet weak var eveningButton: UIButton?
    @IBOutlet weak var nightButton: UIButton?

    override func awakeFromNib() {
        super.awakeFromNib()
        let optionalTimeButtonArray = [morningButton, lunchButton, afternoonButton, eveningButton, nightButton]
        timeButtons = optionalTimeButtonArray.compactMap { $0 }

        for button in timeButtons {
            button.layer.cornerRadius = 17
            button.layer.shadowRadius = 2
            button.layer.shadowOpacity = 0.3
            button.layer.shadowOffset = CGSize.zero
            button.layer.shadowColor = UIColor.lightGray.cgColor
        }
    }

}
