//
//  LoaderView.swift
//
//
//  Created by Mohamed Aglan on 6/8/24.
//

import UIKit
import Combine

protocol UploadProgressDelegate: AnyObject {
    func didUpdateProgress(percentage: Float)
}

public class LoaderView: UIViewController, UploadProgressDelegate {
    
    
    //MARK: - IBOutLets -
    @IBOutlet weak var loaderImage: UIImageView!
    @IBOutlet weak var loaderPercentage: UILabel!
    @IBOutlet weak var loaderProgressBar: UIProgressView!
    
    
    // MARK: - Properties -
    var viewModel: LoaderViewModel!
    private var cancellables: Set<AnyCancellable> = []
    let loader = LoaderGif()
    
    
    
    
    // MARK: - LifeCycle Events -
    public override func viewDidLoad() {
        super.viewDidLoad()
        loader.loadGIF(imageView: loaderImage, resourceName: "Loader")
        loaderProgressBar.progress = 0.0
        loaderPercentage.text = "0%"
        bindViewModel()
    }
    
    init(viewModel: LoaderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "LoaderView", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Configure UI -
    private func bindViewModel() {
        viewModel.$progress
            .receive(on: RunLoop.main)
            .sink { [weak self] progress in
                self?.loaderProgressBar.progress = progress
            }
            .store(in: &cancellables)
        
        viewModel.$percentageText
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.loaderPercentage.text = text
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UploadProgressDelegate -
    func didUpdateProgress(percentage: Float) {
        viewModel.updateProgress(percentage: percentage)
    }
    
}
