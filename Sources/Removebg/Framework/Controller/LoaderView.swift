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
    @IBOutlet weak var loaderPercentage: UILabel!
    @IBOutlet weak var loaderProgressBar: UIProgressView!
    
    
    
    
    
    //MARK: - Properties -
    var delegate: UploadProgressDelegate?
    
    
    
    
    //MARK: - LifeCycle Events -
    public override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    
    public init() {
        super.init(nibName: "LoaderView", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Configure UI -
    func updateProgress(percentage: Float) {
        loaderProgressBar.progress = percentage
        loaderPercentage.text = "\(Int(percentage * 100))%"
    }
    
    
    func didUpdateProgress(percentage: Float) {
        DispatchQueue.main.async {
            self.updateProgress(percentage: percentage)
        }
    }
    
    
    //MARK: - IBActions -
    

    
}
