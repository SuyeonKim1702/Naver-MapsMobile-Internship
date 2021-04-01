//
//  UIImage+Extension.swift
//  map
//
//  Created by 코드잉 on 2021/03/16.
//

import UIKit

extension UIImage {

    func resizeImage(size: CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero
        let aspectWidth = size.width / self.size.width
        let aspectHeight = size.height / self.size.height
        let aspectRatio = max(aspectWidth, aspectHeight)

        scaledImageRect.size.width = self.size.width * aspectRatio
        scaledImageRect.size.height = self.size.height * aspectRatio
        scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0
        scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0

        let renderer = UIGraphicsImageRenderer(size: size)
        let outputImage = renderer.image { _ in
            self.draw(in: scaledImageRect)
        }
        return outputImage
    }
}
