//
//  File.swift
//  
//
//  Created by Mohamed Aglan on 7/8/24.
//

import Foundation
import Combine
import UIKit

class RemoveBackgroundViewModel {
    // Define publishers
    @Published var selectedImage: UIImage?
    @Published var processedImage: UIImage?
    @Published var uploadProgress: Float = 0.0

    private var cancellable: Set<AnyCancellable> = []
    
    func uploadImage(image: UIImage, url: URL) {
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
        let session = URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.uploadTask(with: request, from: body) { data, response, error in
            if let error = error {
                print("Error occurred: \(error)")
                return
            }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.processedImage = image
                }
            }
        }
        task.resume()
        
        // Add observer to the task's progress
        task.progress.addObserver(self as! NSObject, forKeyPath: "fractionCompleted", options: [.new], context: nil)
    }
    
    // MARK: - KVO Handling
    func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "fractionCompleted", let progress = object as? Progress {
            DispatchQueue.main.async {
                self.uploadProgress = Float(progress.fractionCompleted)
            }
        }
    }
}
