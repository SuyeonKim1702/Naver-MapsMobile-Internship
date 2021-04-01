//
//  SmartAroundCollectionViewDataSource.swift
//  map
//
//  Created by 코드잉 on 2021/03/10.
//

import UIKit

class ThumbnailDataSourceDelegate: NSObject {
    var images: [String]?
    private let cacheManager = CacheManager()
    private let smartAroundDataProvider = SmartAroundDataProvider()

    private func setupImage(data: Data, cell: ThumbnailCollectionViewCell, filePath: URL) {
        let imageViewSize = cell.thumbnailImageView?.bounds.size
        if var image = UIImage(data: data) {
            guard let imageViewSize = imageViewSize else { return }
            image = image.resizeImage(size: imageViewSize)
            cell.thumbnailImageView?.image = image
            cacheManager.pushImage(image: image, forPath: filePath)
        }
    }
}

extension ThumbnailDataSourceDelegate: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.size.width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let thumbnailCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell",
                                                                     for: indexPath) as? ThumbnailCollectionViewCell else { return
                                                                        ThumbnailCollectionViewCell() }
        if let imageString = images?[safe: indexPath.row], let url = URL(string: imageString) {
            var filePath = URL(fileURLWithPath: Setting.diskCachePath ?? String())
            filePath.appendPathComponent(url.lastPathComponent)

            if let cachedImage = cacheManager.fetchImage(forPath: filePath) {
                thumbnailCell.thumbnailImageView?.image = cachedImage
            } else {
                smartAroundDataProvider.getImage(from: url, cell: thumbnailCell) { [weak self] data in
                    if let data = data {
                        self?.setupImage(data: data, cell: thumbnailCell, filePath: filePath)
                    } else {
                        Toast.showToast(message: Setting.networkFailureString)
                    }
                }
            }
        }
        return thumbnailCell
    }
}
