//
//  LoaderView.swift
//  
//
//  Created by Mohamed Aglan on 6/8/24.
//

import UIKit

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
        loader.loadGIF(imageView: loaderImage, resourceName: "Loader")
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
    
}
