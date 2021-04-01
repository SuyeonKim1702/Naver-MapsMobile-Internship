//
//  CollectionViewCell.swift
//  map
//
//  Created by 코드잉 on 2021/02/11.
//

import UIKit

class ThumbnailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView?
    var dataTask: URLSessionDataTask?

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView?.image = nil
        dataTask?.cancel()
        dataTask = nil
    }
}
