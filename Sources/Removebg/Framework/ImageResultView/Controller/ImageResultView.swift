//
//  ImageResultView.swift
//
//
//  Created by Mohamed Aglan on 6/8/24.
//

import UIKit
import Photos


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
    func saveImageToPhotos(image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            } else {
                // Handle unauthorized status
                print("Photo library access is not authorized")
            }
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        DispatchQueue.main.async {
            if let error = error {
                // Handle error
                print("Error saving image: \(error.localizedDescription)")
            } else {
                // Success message
                print("Image saved successfully")
                if self.presentedViewController == nil {
                    let alert = UIAlertController(title: "Success", message: "Image saved to Photos", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    
    
    //MARK: - IBActions -
    @IBAction func saveButton(_ sender: UIButton) {
        guard let image = imageResult else { return }
        saveImageToPhotos(image: image)
    }
    
    
    @IBAction func retryProcessButton(_ sender: UIButton) {
        
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
}
