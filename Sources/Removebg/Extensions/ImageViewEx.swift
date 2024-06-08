//
//  File.swift
//  
//
//  Created by Mohamed Aglan on 6/8/24.
//

import UIKit

extension UIImage {
    func fixedOrientation() -> UIImage? {
        guard imageOrientation != .up else {
            return self // The image is already correctly oriented.
        }

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return normalizedImage
    }
}
