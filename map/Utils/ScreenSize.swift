//
//  ScreenType.swift
//  map
//
//  Created by 코드잉 on 2021/03/18.
//

import UIKit

enum ScreenSize {
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    private var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    case low
    case mid
    case full

    func getPortraitFrame() -> TabViewFrame {
        switch self {
        case .full:
            return TabViewFrame(originX: 0, originY: screenHeight * 0.15, width: screenWidth, height: screenHeight * 0.85)
        case .mid:
            return TabViewFrame(originX: 0, originY: screenHeight * 0.6, width: screenWidth, height: screenHeight * 0.4)
        case .low:
            return TabViewFrame(originX: 0, originY: 0, width: screenWidth, height: 0)
        }
    }

    func getLandscapeFrame() -> TabViewFrame {
        switch self {
        case .full, .mid:
            return TabViewFrame(originX: 30, originY: screenHeight * 0.3, width: screenWidth * 0.4, height: screenHeight * 0.7)
        case .low:
            return TabViewFrame(originX: 30, originY: 0, width: screenWidth * 0.4, height: 0)
        }
    }
}
