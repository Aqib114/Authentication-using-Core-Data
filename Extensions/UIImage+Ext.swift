//
//  UIImage+Ext.swift
//  Authentication in Swift
//
//  Created by RAI on 20/09/2024.
//

import UIKit
extension UIImage {
    func toBase64() -> String? {
        // Convert UIImage to Data (using JPEG representation with quality 1.0)
        guard let imageData = self.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        // Convert Data to Base64 string
        return imageData.base64EncodedString()
    }
}

extension UIImage {
    static func fromBase64(_ base64String: String) -> UIImage? {
        // Convert Base64 string to Data
        guard let imageData = Data(base64Encoded: base64String) else {
            return nil
        }
        // Create UIImage from Data
        return UIImage(data: imageData)
    }
}
