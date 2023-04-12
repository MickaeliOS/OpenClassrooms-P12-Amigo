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
