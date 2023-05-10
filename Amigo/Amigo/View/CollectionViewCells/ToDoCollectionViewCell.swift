//
//  ToDoCollectionViewCell.swift
//  Amigo
//
//  Created by Mickaël Horn on 10/05/2023.
//

import UIKit

class ToDoCollectionViewCell: UICollectionViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 20
        contentView.layer.shadowRadius = 20
        contentView.layer.shadowOpacity = 10
        contentView.layer.shadowColor = UIColor.label.cgColor
    }
    @IBOutlet weak var toDoLabel: UILabel!
    
    func configureCell(toDo: String) {
        toDoLabel.text = toDo
    }
}
