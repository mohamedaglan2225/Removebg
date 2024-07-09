//
//  ImageResultView.swift
//
//
//  Created by Mohamed Aglan on 6/8/24.
//

import UIKit

class ImageResultView: UIViewController {
    
    //MARK: - IBOutLets -
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    
    
    //MARK: - Properties -
    var imageResult: UIImage?
    
    
    
    
    
    //MARK: - LifeCycle Events -
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad called")
        imageView.image = imageResult
        print("imageView set")
    }
    
    
    //MARK: - Configure UI -
    func updateImageResult(_ image: UIImage) {
        imageResult = image
        if isViewLoaded {
            imageView.image = image
        }
    }
    
    
    
    
    
    //MARK: - IBActions -
    
    
    
    
    
}
