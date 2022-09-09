//
//  UIImageView+Animation.swift
//  Essential_FeediOS
//
//  Created by Amin on 6/18/1401 AP.
//

import UIKit


extension UIImageView {
    func setImageAnimated(_ newImage: UIImage?) {
        image = newImage
        
        guard newImage != nil else { return }
        alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
}
