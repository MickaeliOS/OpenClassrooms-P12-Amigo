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
        setupInterface()
    }
    
    @IBOutlet weak var toDoLabel: UILabel!
    var deleteThisCell: (() -> Void)?

    @IBAction func deleteItemButtonTapped(_ sender: Any) {
        deleteThisCell?()
    }
    
    func configureCell(toDo: String) {
        toDoLabel.text = toDo
    }
    
    private func setupInterface() {
        contentView.layer.cornerRadius = 15
    }
}
