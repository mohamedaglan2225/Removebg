//
//  File.swift
//
//
//  Created by Mohamed Aglan on 5/31/24.
//

import Foundation

public class NetworkManager {
    
    func performRequest<T: Decodable>(_ request: NetworkRequest, decodingType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let finalURL = request.urlWithQueryParameters()
        var urlRequest = URLRequest(url: finalURL)
        urlRequest.httpMethod = request.method
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpBody = request.method == "POST" ? request.body : nil
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            
            // For debugging: print the response string
            let responseString = String(data: data, encoding: .utf8)
            print("Server response: \(responseString ?? "No data received")")
            
            do {
                let decodedResponse = try JSONDecoder().decode(decodingType, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
        
    }
    
    
    func createMultipartFormDataBody(parameters: [String: String], boundary: String) -> Data {
        var body = Data()
        
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        
        body.append("--\(boundary)--\r\n")
        return body
    }
    
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}


extension NetworkManager {
 
    func uploadImage(_ request: NetworkRequest, imageData: Data, additionalParameters: [String: String] = [:], completion: @escaping (Result<Void, Error>) -> Void) {
        let boundary = "Boundary-\(UUID().uuidString)"
        var urlRequest = URLRequest(url: request.urlWithQueryParameters())
        urlRequest.httpMethod = request.method
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.allHTTPHeaderFields = request.headers

        var body = Data()

        // Append the image data
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"image_file\"; filename=\"image.jpg\"\r\n")
        body.append("Content-Type: image/jpeg\r\n\r\n")
        body.append(imageData)
        body.append("\r\n")

        // Append additional multipart parameters
        for (key, value) in additionalParameters {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }

        body.append("--\(boundary)--\r\n")
        urlRequest.httpBody = body

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let _ = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }

            // Successfully uploaded
            completion(.success(()))
        }
        task.resume()
    }
    
}
