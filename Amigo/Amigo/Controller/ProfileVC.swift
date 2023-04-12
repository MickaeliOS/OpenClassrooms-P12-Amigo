//
//  ProfileVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 12/04/2023.
//

import UIKit

class ProfileVC: UIViewController {
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = user else {
            print("MKA - HomeVC empty user")
            return
        }
        print("MKA - FIRSTNAME : \(user.firstname)")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
