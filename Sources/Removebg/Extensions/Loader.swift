//
//  File.swift
//  
//
//  Created by Mohamed Aglan on 6/8/24.
//

import UIKit

public class LoaderGif {
    
    public func loadGIF(imageView: UIImageView, gifName: String) {
        guard let path = Bundle.main.path(forResource: gifName, ofType: "gif"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return
        }

        var images = [UIImage]()
        let count = CGImageSourceGetCount(source)
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let image = UIImage(cgImage: cgImage)
                images.append(image)
            }
        }

        imageView.animationImages = images
        imageView.animationDuration = 1.0 // Tune this for your gif
        imageView.startAnimating()
    }
}
