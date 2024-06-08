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
        // Assuming 'uploadImage' is a method within the same class or accessible scope
        if let image = imageView.image {
            if let url = URL(string: "https://removebg.gyoom.sa") {
                self.uploadImage(image: image, url: url) { image in
                    if let image = image {
                        DispatchQueue.main.async {
                            self.imageView.image = image
//                            if let parentVC = self.parentViewController {
//                                let destinationViewController = ImageResultView()
//                                destinationViewController.imageResult = image
//                                destinationViewController.modalPresentationStyle = .fullScreen
//                                parentVC.present(destinationViewController, animated: true, completion: nil)
//                            }else {
//                                fatalError("Parent view controller not found")
//                            }
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
    
    func uploadImage(image: UIImage, url: URL, completion: @escaping (UIImage?) -> Void) {
        // 1. Create the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // 2. Create Multipart FormData
        let imageData = image.jpegData(compressionQuality: 0.5)!
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image_file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\rn".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        // 3. Configure URLSession with delegate
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)

        // 4. Create upload task
        let task = session.uploadTask(with: request, from: body) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            let receivedImage = UIImage(data: data)
            DispatchQueue.main.async {
                completion(receivedImage)
            }
        }

        // 5. Track progress
        task.resume()
        task.progress.addObserver(self, forKeyPath: #keyPath(Progress.fractionCompleted), options: .new, context: nil)
    }

    // Implement the observer method
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(Progress.fractionCompleted), let progress = object as? Progress {
            print("Upload Progress: \(progress.fractionCompleted * 100)%")
        }
    }

    
}
