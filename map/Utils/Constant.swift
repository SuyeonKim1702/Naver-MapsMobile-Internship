//
//  Constant.swift
//  map
//
//  Created by USER on 2021/02/08.
//

import UIKit

struct Setting {
    static let scheme = "https"
    static let locationPermissionString = "위치 서비스를 사용할 수 없습니다. 기기의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요."
    static let networkFailureString = "네트워크 작업에 실패했습니다."
    static let busanLat = 35.114897791356434
    static let busanLng = 129.04144049030438
    static let cityHallLat = 37.5670135
    static let cityHallLng = 126.9783740
    static let diskCachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[safe: 0]

    enum TabType: String {
        case smartAround = "주변"
        case publicTransit = "대중교통"
    }

    enum SubwayType: String {
        case general = "일반"
        case express = "급행"
    }
}

struct Toast {
    static func showToast(message: String, view: UIView = UIApplication.shared.keyWindow ?? UIView()) {
        let toastLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.75, height: view.frame.width * 0.1))
        var position: CGPoint = view.center
        position.y *= 1.4
        toastLabel.center = position
        toastLabel.text = message
        toastLabel.textAlignment = .center
        toastLabel.backgroundColor = .white
        toastLabel.layer.cornerRadius = 20
        toastLabel.alpha = 1.0
        view.addSubview(toastLabel)

        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: { toastLabel.alpha = 0.0 }, completion: { _ in
                        toastLabel.removeFromSuperview()})
    }
}
