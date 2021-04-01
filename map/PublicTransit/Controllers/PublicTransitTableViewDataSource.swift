//
//  PublicTransitTableViewDataSource.swift
//  map
//
//  Created by 코드잉 on 2021/03/08.
//

import UIKit

class PublicTransitTableViewDataSource: NSObject, UITableViewDataSource {
    var transitInfo: [StationInfo]?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        transitInfo?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let busStationCell = tableView.dequeueReusableCell(withIdentifier: "BusStationCell", for: indexPath) as? BusStationCell,
              let subwayStationCell = tableView.dequeueReusableCell(withIdentifier: "SubwayStationCell", for: indexPath) as? SubwayStationCell,
              let transitInfo = transitInfo?[safe: indexPath.row]
        else { return UITableViewCell() }

        switch transitInfo.type {
        case .subway:
            subwayStationCell.updateUI(for: transitInfo)
            return subwayStationCell
        case .bus:
            busStationCell.updateUI(for: transitInfo)
            return busStationCell
        }
    }
}
