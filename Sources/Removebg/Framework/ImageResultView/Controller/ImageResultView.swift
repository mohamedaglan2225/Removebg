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
        imageView.image = imageResult
    }
    
    
    public init() {
        super.init(nibName: "ImageResultView", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Configure UI -
    
    
    
    
    
    
    //MARK: - IBActions -
    
    
    
    
    
}
