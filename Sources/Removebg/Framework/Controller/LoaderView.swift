//
//  LoaderView.swift
//  
//
//  Created by Mohamed Aglan on 6/8/24.
//

import UIKit
import ImageIO

protocol UploadProgressDelegate: AnyObject {
    func didUpdateProgress(percentage: Float)
}

public class LoaderView: UIViewController, UploadProgressDelegate {
    
    
    //MARK: - IBOutLets -
    @IBOutlet weak var loaderImage: UIImageView!
    @IBOutlet weak var loaderPercentage: UILabel!
    @IBOutlet weak var loaderProgressBar: UIProgressView!
    
    
    
    
    
    //MARK: - Properties -
    var delegate: UploadProgressDelegate?
    let loader = LoaderGif()
    
    
    
    //MARK: - LifeCycle Events -
    public override func viewDidLoad() {
        super.viewDidLoad()
        loadGIF(imageView: loaderImage, gifName: "Loader")
        loaderProgressBar.progress = 0.0
        loaderPercentage.text = "0%"
    }
    
    
    
    public init() {
        super.init(nibName: "LoaderView", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Configure UI -
    func didUpdateProgress(percentage: Float) {
           DispatchQueue.main.async {
               self.loaderProgressBar.progress = percentage
               self.loaderPercentage.text = "\(Int(percentage * 100))%"
           }
       }
    
    
    //MARK: - IBActions -
    func loadGIF(imageView: UIImageView, gifName: String) {
        // Ensure the GIF file is available in the main bundle
        guard let path = Bundle.main.path(forResource: gifName, ofType: "gif"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("Could not find GIF")
            return
        }

        var images = [UIImage]()
        var totalDuration: TimeInterval = 0

        let frameCount = CGImageSourceGetCount(source)
        
        // Extract each frame and its duration
        for i in 0..<frameCount {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let image = UIImage(cgImage: cgImage)
                images.append(image)
                
                let frameProperties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any]
                let gifProperties = frameProperties?[kCGImagePropertyGIFDictionary as String] as? [String: Any]
                let delayTime = gifProperties?[kCGImagePropertyGIFDelayTime as String] as? Double ?? 0.1 // Default frame duration
                totalDuration += delayTime
            }
        }

        // Set the images and duration for the animation
        imageView.animationImages = images
        imageView.animationDuration = totalDuration
        imageView.startAnimating()
    }


    
}
