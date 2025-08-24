//
//  ImageLoader.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/24/25.
//

import UIKit

protocol ImageLoadable: AnyObject {
    func loadImage(path: String, targetSize: CGSize) async throws -> UIImage?
}

final class ImageLoader: ImageLoadable {
    private let session: URLSession
    private let memoryCache: NSCache = NSCache<NSString, UIImage>()
    
    init() {
        let bytes = 1024 * 1024
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.urlCache = .init(memoryCapacity: 50 * bytes,
                                        diskCapacity: 100 * bytes)
        self.session = .init(configuration: configuration)
        memoryCache.totalCostLimit = 80 * bytes
    }
    
    func loadImage(path: String, targetSize: CGSize) async throws -> UIImage? {
        if let cached = memoryCache.object(forKey: path as NSString) {
            print("NAM LOG loadImage cached")
            return cached
        }
        
        do {
            if let url = URL(string: path) {
                let (data, _) = try await session.data(from: url)
                let scale = await MainActor.run { UIScreen.main.scale }
                
                let image: UIImage = try await Task { [data, targetSize, scale] in
                    print("NAM LOG loadImage downSampling")
                    return try self.downSampling(data: data, size: targetSize, scale: scale)
                }.value
                
                memoryCache.setObject(image, forKey: path as NSString)
                return image
            }
        } catch {
            
        }

        return nil
    }

    private func downSampling(data: Data,
                                size: CGSize,
                                scale: CGFloat) throws -> UIImage {
        let shouldCache: [CFString: Any] = [kCGImageSourceShouldCache: false]
        guard let sourceCreate = CGImageSourceCreateWithData(data as CFData, shouldCache as CFDictionary) else {
            throw URLError(.cannotDecodeRawData)
        }
        
        let maxDim = Int(ceil(max(size.width, size.height) * scale))
        
        let option: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways:  true,
            kCGImageSourceCreateThumbnailWithTransform:    true,
            kCGImageSourceShouldCacheImmediately:          true,
            kCGImageSourceThumbnailMaxPixelSize:           maxDim
        ]
        
        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(sourceCreate, 0, option as CFDictionary) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        return UIImage(cgImage: cgImage)
    }
}
