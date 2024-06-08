//
//  RemoveBackgroundView.swift
//
//
//  Created by Mohamed Aglan on 6/8/24.
//

import UIKit

class RemoveBackgroundView: UIView {
    
    
    //MARK: - IBOutLets -
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var removeBackGroundView: UIView!
    @IBOutlet weak var deleteImage: UIButton!
    
    
    
    
    
    
    
    //MARK: - Properties -
    weak var uploadDelegate: UploadProgressDelegate?
    
    
    
    
    //MARK: - LifeCycle Events -
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        configureUI()
    }
    
    private func commonInit() {
        let nib = UINib(nibName: "RemoveBackgroundView", bundle: Bundle.module)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            addSubview(view)
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    
    
    
    //MARK: - Configure UI -
    private func configureUI() {
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openGallaryOrCamera))
        imageView.addGestureRecognizer(imageTap)
        
        let removeBackGroundTap = UITapGestureRecognizer(target: self, action: #selector(removeBackGroundAction))
        removeBackGroundView.addGestureRecognizer(removeBackGroundTap)
        
        deleteImage.isHidden = true
    }
    
    
    //MARK: - IBActions -
    @IBAction func cancelImage(_ sender: Any) {
        imageView.image = nil
        deleteImage.isHidden = true
    }
    
    @objc private func openGallaryOrCamera() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        if let parentVC = parentViewController {
            let destinationViewController = picker
            destinationViewController.modalPresentationStyle = .fullScreen
            parentVC.present(destinationViewController, animated: true, completion: nil)
        }else {
            fatalError("Parent view controller not found")
        }
    }
    
    
    @objc private func removeBackGroundAction() {
        guard let image = imageView.image?.fixedOrientation(), let url = URL(string: "https://removebg.gyoom.sa") else { return }
        if let parentVC = self.parentViewController {
            let loaderView = LoaderView()
            loaderView.modalPresentationStyle = .overFullScreen
            parentVC.present(loaderView, animated: true) {
                self.uploadDelegate = loaderView
                self.uploadImage(image: image, url: url, delegate: loaderView) { image in
                    DispatchQueue.main.async {
                        if let image = image {
//                            self.imageView.image = image
                            parentVC.dismiss(animated: true) {
                                let vc = ImageResultView()
                                vc.imageResult = image
                                parentVC.present(vc, animated: true)
                            }
                        }else {
                            parentVC.dismiss(animated: true)
                        }
                    }
                }
            }
        }
        
    }
    
}


extension RemoveBackgroundView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let image = info[.originalImage] as? UIImage {
                self.imageView.image = image
                self.imageView.contentMode = .scaleAspectFill
                self.deleteImage.isHidden = false
                self.removeBackGroundView.isUserInteractionEnabled = true
            }
        }
    }
}



//MARK: - Networking -
extension RemoveBackgroundView: URLSessionTaskDelegate {
    
    // MARK: - Upload Image Function
    func uploadImage(image: UIImage, url: URL, delegate: UploadProgressDelegate, completion: @escaping (UIImage?) -> Void) {
           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           let boundary = "Boundary-\(UUID().uuidString)"
           request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
           
           let imageData = image.jpegData(compressionQuality: 0.5)!
           var body = Data()
           body.append("--\(boundary)\r\n".data(using: .utf8)!)
           body.append("Content-Disposition: form-data; name=\"image_file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
           body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
           body.append(imageData)
           body.append("\r\n".data(using: .utf8)!)
           body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        
        let task = session.uploadTask(with: request, from: body) { data, response, error in
            if let error = error {
                print("Error occurred: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
        
        // Add observer to the task's progress
        task.progress.addObserver(self, forKeyPath: "fractionCompleted", options: [.new], context: nil)
    }
    
    // MARK: - KVO Handling
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "fractionCompleted", let progress = object as? Progress {
            let percentage = Float(progress.fractionCompleted)
            DispatchQueue.main.async {
                self.uploadDelegate?.didUpdateProgress(percentage: percentage)
            }
        }
    }

    
}
