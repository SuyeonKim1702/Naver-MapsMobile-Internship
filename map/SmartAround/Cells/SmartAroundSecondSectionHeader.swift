//
//  SmartAroundSectionHeaderView.swift
//  map
//
//  Created by USER on 2021/02/02.
//

import UIKit

protocol SmartAroundSecondSectionHeaderDelegate: AnyObject {
    func smartAroundSecondSectionHeaderToggleSection()
}

class SmartAroundSecondSectionHeader: UITableViewHeaderFooterView {

    weak var delegate: SmartAroundSecondSectionHeaderDelegate?
    @IBOutlet weak var orderByLabel: UILabel?

    @IBAction func collapseSection(_ sender: Any) {
        delegate?.smartAroundSecondSectionHeaderToggleSection()
    }

}
