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
    }
    
    
    //MARK: - IBActions -
    @IBAction func cancelImage(_ sender: Any) {
        imageView.image = nil
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

}


extension RemoveBackgroundView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            // Extract the image from the picker info dictionary
            if let image = info[.originalImage] as? UIImage {
                // Assuming 'uploadImage' is a method within the same class or accessible scope
                self.imageView.image = image
                self.imageView.contentMode = .scaleAspectFill
            }
        }
    }
}
