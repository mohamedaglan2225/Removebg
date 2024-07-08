//
//  RemoveBackgroundView.swift
//
//
//  Created by Mohamed Aglan on 6/8/24.
//

import UIKit
import Combine

class RemoveBackgroundView: UIView {
    
    
    //MARK: - IBOutLets -
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var removeBackGroundView: UIView!
    @IBOutlet weak var deleteImage: UIButton!
    
    
    
    // MARK: - Properties -
    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: RemoveBackgroundViewModel
    weak var uploadDelegate: UploadProgressDelegate?
    
    
    
    
    // MARK: - Initializers -
    init(frame: CGRect, viewModel: RemoveBackgroundViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        commonInit()
        configureUI()
        bindViewModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = RemoveBackgroundViewModel()
        super.init(coder: aDecoder)
        commonInit()
        configureUI()
        bindViewModel()
    }
    
    init(viewModel: RemoveBackgroundViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        commonInit()
        configureUI()
        bindViewModel()
    }
    
    private func commonInit() {
        let nib = UINib(nibName: "RemoveBackgroundView", bundle: Bundle.module)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            addSubview(view)
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    
    // MARK: - Configure UI -
    private func configureUI() {
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openGalleryOrCamera))
        imageView.addGestureRecognizer(imageTap)
        
        let removeBackGroundTap = UITapGestureRecognizer(target: self, action: #selector(removeBackgroundAction))
        removeBackGroundView.addGestureRecognizer(removeBackGroundTap)
        
        deleteImage.isHidden = true
    }
    
    private func bindViewModel() {
        viewModel.$selectedImage
            .receive(on: RunLoop.main)
            .sink { [weak self] image in
                self?.imageView.image = image
                self?.deleteImage.isHidden = image == nil
                self?.removeBackGroundView.isUserInteractionEnabled = image != nil
            }
            .store(in: &cancellables)
        
        viewModel.$processedImage
            .receive(on: RunLoop.main)
            .sink { [weak self] image in
                guard let self = self, let image = image else { return }
                self.presentImageResultView(with: image)
            }
            .store(in: &cancellables)
        
        viewModel.$uploadProgress
            .receive(on: RunLoop.main)
            .sink { [weak self] progress in
                self?.uploadDelegate?.didUpdateProgress(percentage: progress)
            }
            .store(in: &cancellables)
    }
    
    
    
    //MARK: - IBActions -
    @IBAction func cancelImage(_ sender: Any) {
        viewModel.selectedImage = nil
    }
    
    @objc private func openGalleryOrCamera() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        if let parentVC = parentViewController {
            let destinationViewController = picker
            destinationViewController.modalPresentationStyle = .fullScreen
            parentVC.present(destinationViewController, animated: true, completion: nil)
        } else {
            fatalError("Parent view controller not found")
        }
    }
    
    @objc private func removeBackgroundAction() {
        guard let image = imageView.image?.fixedOrientation(), let url = URL(string: "https://removebg.gyoom.sa") else { return }
        viewModel.uploadImage(image: image, url: url)
    }
    
    private func presentImageResultView(with image: UIImage) {
        guard let parentVC = parentViewController else { return }
        let vc = ImageResultView()
        vc.imageResult = image
        parentVC.present(vc, animated: true)
    }
    
}


extension RemoveBackgroundView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true) {
            if let image = info[.originalImage] as? UIImage {
                self.viewModel.selectedImage = image
            }
        }
    }
}
