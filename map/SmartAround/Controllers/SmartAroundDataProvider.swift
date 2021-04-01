//
//  PlaceDataProvider.swift
//  map
//
//  Created by 코드잉 on 2021/03/15.
//

import UIKit

class SmartAroundDataProvider {

    private let placeService = SmartAroundPlaceService()
    private let addressService = SmartAroundAddressService()
    private let networkManager = NetworkManager()
    private var places: [Place]?
    private var address: String?
    private var image: Data?

    func getPlaces(_ lat: Double, _ lng: Double, _ code: Setting.Code, _ completion: @escaping ([Place]?) -> Void) {
        placeService.getPlaces(lat: lat, lng: lng, code: code) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let places):
                self.places = places.compactMap { $0 }
            case .failure(let error):
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                completion(self.places)
            }
        }
    }

    func getAddress(_ lat: Double, _ lng: Double, _ completion: @escaping (String?) -> Void) {
        addressService.getAddress(lat: lat, lng: lng) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let address):
                self.address = address
            case .failure(let error):
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                completion(self.address)
            }
        }
    }

    func getImage(from url: URL, cell: ThumbnailCollectionViewCell, _ completion: @escaping (Data?) -> Void) {
        cell.dataTask = networkManager.request(url, { [weak self] (data: Result<Data, NetworkError>) in
            guard let `self` = self else { return }
            switch data {
            case .success(let data):
                self.image = data
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    if (error as NetworkError) != .cancelError {
                        Toast.showToast(message: Setting.networkFailureString)
                    }
                }
            }
            DispatchQueue.main.async {
                completion(self.image)
            }

        }, nil)
        cell.dataTask?.resume()
    }
}
