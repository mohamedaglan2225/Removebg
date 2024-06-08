//
//  File.swift
//  
//
//  Created by Mohamed Aglan on 6/8/24.
//

import UIKit
import ImageIO

public class LoaderGif {
    
    public func loadGIF(imageView: UIImageView, resourceName: String) {
        guard let url = Bundle.module.url(forResource: resourceName, withExtension: "gif"),
              let data = try? Data(contentsOf: url),
              let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("Failed to load GIF from module resources.")
            return
        }

        var images = [UIImage]()
        var totalDuration: TimeInterval = 0

        let frameCount = CGImageSourceGetCount(source)
        
        for i in 0..<frameCount {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let frameProperties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as Dictionary?
                let gifProperties = (frameProperties as NSDictionary?)?[kCGImagePropertyGIFDictionary] as? NSDictionary
                let delayTime = gifProperties?[kCGImagePropertyGIFDelayTime as NSString] as? Double ?? 0.1 // Default duration if not specified

                totalDuration += delayTime
                images.append(UIImage(cgImage: cgImage))
            }
        }

        imageView.animationImages = images
        imageView.animationDuration = totalDuration
        imageView.startAnimating()
    }
}
