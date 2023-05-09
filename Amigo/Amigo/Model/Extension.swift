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
    
    func presentAlert(with error: String) {
        let alert: UIAlertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func presentAlert(with error: String, completion: @escaping () -> Void) {
        let alert: UIAlertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel) { action in
            completion()
        }
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
    
    static func isValidEmail(_ email: String) -> Bool {
        // Firebase already warns us about badly formatted email addresses, but this involves a network call.
        // To help with Green Code, I prefer to handle the email format validation myself.
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        // Same logic as the email verification.
        let regex = #"(?=^.{7,}$)(?=^.*[A-Z].*$)(?=^.*\d.*$).*"#
        
        return password.range(
            of: regex,
            options: .regularExpression
        ) != nil
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
