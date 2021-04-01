//
//  CacheManager.swift
//  map
//
//  Created by 코드잉 on 2021/02/25.
//

import UIKit

class CacheManager {
    let cache = NSCache<NSString, UIImage>()
    let fileManager = FileManager.default

    private func fetchFromMemoryCache(forKey key: String) -> UIImage? { cache.object(forKey: key as NSString) }

    private func fetchFromDiskCache(forPath path: URL) -> UIImage? {
        if fileManager.fileExists(atPath: path.path), let imageData = try? Data(contentsOf: path), let cachedImage = UIImage(data: imageData) {
            return cachedImage
        }
        return nil
    }

    private func pushToMemoryCache(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    private func pushToDiskCache(image: UIImage, forPath path: URL) {
        fileManager.createFile(atPath: path.path,
                               contents: image.jpegData(compressionQuality: 0.4),
                               attributes: nil)
    }

    func fetchImage(forPath path: URL) -> UIImage? {
        fetchFromMemoryCache(forKey: path.lastPathComponent) ?? fetchFromDiskCache(forPath: path)
    }

    func pushImage(image: UIImage, forPath path: URL) {
        pushToMemoryCache(image: image, forKey: path.lastPathComponent)
        pushToDiskCache(image: image, forPath: path)
    }

    func clearMemoryCache() {
        cache.removeAllObjects()
    }
}
