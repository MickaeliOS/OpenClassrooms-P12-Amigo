//
//  TripTableViewCell.swift
//  Amigo
//
//  Created by Mickaël Horn on 01/05/2023.
//

import UIKit

class TripTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var fromDate: UILabel!
    @IBOutlet weak var toDate: UILabel!
    @IBOutlet weak var findTripImage: UIImageView!
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(profilePicture: Data?, destination: String, fromDate: Date, toDate: Date) {
        if let profilePicture = profilePicture {
            profilePictureImage.image = UIImage(data: profilePicture)
        } else {
            profilePictureImage.image = UIImage(systemName: "person.fill")
        }
        
        destinationLabel.text = destination
        self.fromDate.text = fromDate.dateToString()
        self.toDate.text = toDate.dateToString()
    }
}
