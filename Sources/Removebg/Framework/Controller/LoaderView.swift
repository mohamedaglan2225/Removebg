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
        loadGIF(imageView: loaderImage, resourceName: "Loader")
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
    func loadGIF(imageView: UIImageView, resourceName: String) {
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
