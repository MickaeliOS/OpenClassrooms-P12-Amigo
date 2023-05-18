//
//  Extension.swift
//  Amigo
//
//  Created by Mickaël Horn on 12/04/2023.
//

import Foundation
import UIKit
import MapKit

// MARK: - CONTROLLER EXTENSIONS
extension UIViewController {
    func presentVCFullScreen(with identifier: String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: identifier)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated:true)
    }
    
    func presentErrorAlert(with error: String) {
        let alert: UIAlertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func presentErrorAlert(with error: String, completion: @escaping () -> Void) {
        let alert: UIAlertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel) { action in
            completion()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func presentInformationAlert(with message: String) {
        let alert: UIAlertController = UIAlertController(title: "Information", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func presentInformationAlert(with message: String, completion: @escaping () -> Void) {
        let alert: UIAlertController = UIAlertController(title: "Information", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel) { action in
            completion()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func presentDestructiveAlert(with message: String, completion: @escaping () -> Void) {
        let alert: UIAlertController = UIAlertController(title: "Attention", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .destructive) { action in
            completion()
        }
        
        alert.addAction(action)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelButton)
        
        present(alert, animated: true, completion: nil)
    }
    
    static func toggleActivityIndicator(shown: Bool, button: UIButton, activityIndicator: UIActivityIndicatorView) {
        // If shown is true, then the refresh button is hidden and we display the Activity Indicator
        // If not, we hide the Activity Indicator and show the refresh button
        button.isHidden = shown
        activityIndicator.isHidden = !shown
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
        // The button's action needs to be handled in the UIViewController.
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

extension UITextView {
    var isEmpty: Bool {
        if let text = text, !text.isEmpty {
            return false
        }
        return true
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

// MARK: - MODEL EXTENSIONS
extension Date {
    func dateToString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let dateString = formatter.string(from: self)
        
        return dateString
    }
}

extension MKLocalSearch {
    static func getPartsFromAddress(address: String, completion: @escaping (MKMapItem?, Error?) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = address
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if error != nil {
                completion(nil, Errors.CommonError.defaultError)
            }
            
            guard let mapItems = response?.mapItems, !mapItems.isEmpty else {
                completion(nil, nil)
                return
            }
            
            // I return the first element of the collection, because an address is unique.
            completion(mapItems.first, nil)
        }
    }
}

extension String {
    static func countryFlag(countryCode: String) -> String {
        return String(String.UnicodeScalarView(
            countryCode.unicodeScalars.compactMap(
                { UnicodeScalar(127397 + $0.value) })))
    }
    
    static func emptyControl(fields: [String?]) -> Bool {
        for field in fields {
            guard let field = field, !field.isEmpty else {
                return false
            }
        }
        return true
    }
}

extension Locale {
    static var countryList: [String] {
        Locale.isoRegionCodes.compactMap { Locale.current.localizedString(forRegionCode: $0) }
    }
    
    static func countryCode(forCountryName name: String) -> String? {
        for code in Locale.isoRegionCodes {
            guard let countryName = Locale.current.localizedString(forRegionCode: code) else {
                continue
            }
            if countryName.lowercased() == name.lowercased() {
                return code
            }
        }
        return nil
    }
}
