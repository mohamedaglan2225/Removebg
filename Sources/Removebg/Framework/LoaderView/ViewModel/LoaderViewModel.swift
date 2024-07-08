//
//  File.swift
//  
//
//  Created by Mohamed Aglan on 7/8/24.
//

import Combine
import UIKit

class LoaderViewModel {
    
    @Published var progress: Float = 0.0
    @Published var percentageText: String = "0%"
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        
    }
    
    // Method to update progress
    func updateProgress(percentage: Float) {
        progress = percentage
        percentageText = "\(Int(percentage * 100))%"
    }
}
