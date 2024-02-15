//
//  UIImage+extension.swift
//  FirebaseSample
//
//  Created by Admin on 15/02/24.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL) {
   
        // Fetch the image asynchronously
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle errors
            guard let data = data, error == nil else {
                print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            // Update UI on the main thread
            DispatchQueue.main.async {
                // Create image from data
                if let image = UIImage(data: data) {
                    // Set the image to the UIImageView
                    self.image = image
                }
            }
        }.resume()
    }
}
