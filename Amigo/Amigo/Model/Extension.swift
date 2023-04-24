//
//  Extension.swift
//  Amigo
//
//  Created by Mickaël Horn on 12/04/2023.
//

import Foundation
import UIKit

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
    var isEmpty: Bool {
        if let text = text, !text.isEmpty {
            return false
        }
        return true
    }
    
    func addLeftSystemImage(image: UIImage) {
        leftViewMode = .always
        
        let imageView = UIImageView(frame: CGRect(x: 15, y: 0, width: 25, height: 25))
        imageView.contentMode = .scaleAspectFit // If the image isn't squared, we keep the aspect ratio.
        imageView.tintColor = UIColor.placeholderText
        imageView.image = image

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 25))
        view.addSubview(imageView)
        
        leftView = view
    }
    
    func addPasswordToggleImage(target: Any?, action: Selector) {
        // This method adds an eye icon to the given UITextField for toggling password visibility.
        // The button's action needs to be handled in your UIViewController.
        let button = UIButton(type: .custom)
        
        button.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.contentMode = .scaleAspectFit
        button.tintColor = UIColor.placeholderText
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 25))
        view.addSubview(button)
        
        self.rightView = view
        self.rightViewMode = .always
    }
}

extension UILabel {
    func displayErrorMessage(message: String) {
        isHidden = false
        text = message
    }
}

extension UIImageView {
    func makeRounded() {
        layer.borderWidth = 2
        layer.masksToBounds = false
        layer.borderColor = UIColor(named: "Label Color")?.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}

extension UIImage {
    func isEqualToImage(image: UIImage) -> Bool {
        let data1: NSData = self.pngData()! as NSData
        let data2: NSData = image.pngData()! as NSData
        return data1.isEqual(data2)
    }
}
