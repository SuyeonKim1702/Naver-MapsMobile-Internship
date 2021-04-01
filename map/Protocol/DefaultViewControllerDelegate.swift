//
//  DefaultViewControllerDelegate.swift
//  map
//
//  Created by 코드잉 on 2021/03/08.
//

import Foundation

protocol DefaultViewControllerDelegate: AnyObject {
    func defaultViewControllerAnimateByScroll()
    func defaultViewControllerAddMarkers(for markers: [Place])
}
