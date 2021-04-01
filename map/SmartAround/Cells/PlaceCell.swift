//
//  StoreCell.swift
//  map
//
//  Created by USER on 2021/01/29.
//

import UIKit

class PlaceCell: UITableViewCell {
    @IBOutlet weak private var storeNameLabel: UILabel?
    @IBOutlet weak private var storeTypeLabel: UILabel?
    @IBOutlet weak private var bookmarkButton: UIButton?
    @IBOutlet weak private var averagePriceLabel: UILabel?
    @IBOutlet weak private var thumbnailCollectionView: UICollectionView?
    @IBOutlet weak private var numOfReviewLabel: UILabel?
    @IBOutlet weak private var distanceLabel: UILabel?
    @IBOutlet weak private var storeDescriptionLabel: UILabel?
    private var thumbnailDataSourceDelegate = ThumbnailDataSourceDelegate()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }

    func updateUI(_ place: Place) {
        reloadCollectionView(for: place.images)
        storeNameLabel?.text = place.name
        storeTypeLabel?.text = place.categoryName
        storeDescriptionLabel?.text = place.description
        averagePriceLabel?.text = "\(place.averagePrice)"
        numOfReviewLabel?.text = "\(place.reviewCount)"

        if place.distance >= 1.0 {
            distanceLabel?.text = "\(place.distance)km"
        } else {
            distanceLabel?.text = "\(place.distance * 1000)m"
        }
    }

    private func setupCollectionView() {
        thumbnailCollectionView?.dataSource = thumbnailDataSourceDelegate
        thumbnailCollectionView?.delegate = thumbnailDataSourceDelegate
    }

    private func reloadCollectionView(for images: [String]) {
        thumbnailDataSourceDelegate.images = images
        thumbnailCollectionView?.reloadData()
    }
}
