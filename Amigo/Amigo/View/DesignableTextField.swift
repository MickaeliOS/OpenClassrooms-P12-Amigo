//
//  DesignableTextField.swift
//  Amigo
//
//  Created by Mickaël Horn on 17/04/2023.
//

import UIKit

@IBDesignable
class DesignableTextField: UITextField, UIGestureRecognizerDelegate {
    
    //MARK: IB INSPECTABLES
    
    // Left Image
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateLeftImage()
        }
    }
    
    @IBInspectable var leftImageSize: CGFloat = 20 {
        didSet {
            updateLeftImage()
        }
    }
    
    @IBInspectable var leftImagePaddingLeft: CGFloat = 0 {
        didSet {
            updateLeftImage()
        }
    }
    
    @IBInspectable var leftImagePaddingRight: CGFloat = 0 {
        didSet {
            updateLeftImage()
        }
    }
    
    // Right Image
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateRightImage()
        }
    }
    
    @IBInspectable var rightImageSize: CGFloat = 20 {
        didSet {
            updateRightImage()
        }
    }
    
    @IBInspectable var rightImagePaddingLeft: CGFloat = 0 {
        didSet {
            updateRightImage()
        }
    }
    
    @IBInspectable var rightImagePaddingRight: CGFloat = 0 {
        didSet {
            updateRightImage()
        }
    }
    
    @IBInspectable var rightImageClickable: Bool = false {
        didSet {
            updateRightImage()
        }
    }
    
    //MARK: PRIVATE FUNCTIONS
    private func updateLeftImage() {
        guard let image = leftImage else {
            leftViewMode = .never
            return
        }
        
        leftViewMode = .always
        
        let imageView = UIImageView(frame: CGRect(x: leftImagePaddingLeft, y: 0, width: leftImageSize, height: leftImageSize))
        imageView.contentMode = .scaleAspectFit // If the image isn't squared, we keep the aspect ratio.
        imageView.tintColor = UIColor.placeholderText
        imageView.image = image

        let width = leftImageSize + leftImagePaddingLeft + leftImagePaddingRight
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: leftImageSize))
        view.addSubview(imageView)
        
        leftView = view
    }
    
    private func updateRightImage() {
        guard let image = rightImage else {
            leftViewMode = .never
            return
        }
        
        rightViewMode = .always
        
        let imageView = UIImageView(frame: CGRect(x: leftImagePaddingRight, y: 0, width: leftImageSize, height: leftImageSize))
        imageView.contentMode = .scaleAspectFit // If the image isn't squared, we keep the aspect ratio.
        imageView.tintColor = UIColor.placeholderText
        imageView.image = image

        let width = rightImageSize + rightImagePaddingLeft + rightImagePaddingRight
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: rightImageSize))
        view.addSubview(imageView)
        
        rightView = view
    }
    
    private func setupClickableImage() {
        if rightImageClickable {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleImage))
            tapGestureRecognizer.delegate = self
            self.isUserInteractionEnabled = true
        }
    }
    
    @objc private func toggleImage() {
        self.isSecureTextEntry.toggle()
    }
}
