//
//  PublicTransitDataProvider.swift
//  map
//
//  Created by 코드잉 on 2021/03/16.
//

import UIKit

class PublicTransitDataProvider {

    private let publicTransitArrivalService = PublicTransitArrivalService()
    var transitInfo: [StationInfo]?

    func getArrivalInfo(_ completion: @escaping ([StationInfo]?) -> Void) {
        publicTransitArrivalService.getArrivalInfo { [weak self] data in
            guard let `self` = self else { return }
            switch data {
            case .success(let resultData):
                self.transitInfo = resultData
            case .failure(let error):
                print(error)
            }
            DispatchQueue.main.async {
                completion(self.transitInfo)
            }
        }
    }
}
