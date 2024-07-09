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
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad called")
        if let imageView = imageView {
            imageView.image = imageResult
            print("imageView set")
        } else {
            print("imageView is nil")
        }
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
