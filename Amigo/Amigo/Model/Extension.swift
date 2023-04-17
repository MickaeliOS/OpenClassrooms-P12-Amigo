//
//  Extension.swift
//  Amigo
//
//  Created by Mickaël Horn on 12/04/2023.
//

import Foundation
import UIKit

extension UITextField {
    var isEmpty: Bool {
        if let text = text, !text.isEmpty {
            return false
        }
        return true
    }
}

extension UIViewController {
    func presentVCFullScreen(with identifier: String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: identifier)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated:true)
    }
    
    func presentAlert(with error: String) {
        let alert: UIAlertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension UITextField {
    func addLeftSystemImage(image: UIImage, paddingLeft: CGFloat, paddingRight: CGFloat, size: CGFloat) {
        leftViewMode = .always
        
        let imageView = UIImageView(frame: CGRect(x: paddingLeft, y: 0, width: size, height: size))
        imageView.contentMode = .scaleAspectFit // If the image isn't squared, we keep the aspect ratio.
        imageView.tintColor = UIColor.placeholderText
        imageView.image = image

        let width = size + paddingLeft + paddingRight
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: size))
        view.addSubview(imageView)
        
        leftView = view
    }
    
    func addRightSystemImage(image: UIImage, paddingLeft: CGFloat, paddingRight: CGFloat, size: CGFloat) {
        rightViewMode = .always
        
        let imageView = UIImageView(frame: CGRect(x: -paddingLeft, y: 0, width: size, height: size))
        imageView.contentMode = .scaleAspectFit // If the image isn't squared, we keep the aspect ratio.
        imageView.tintColor = UIColor.placeholderText
        imageView.image = image

        let width = size + paddingLeft + paddingRight
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: size))
        view.addSubview(imageView)
        
        rightView = view
    }
}
