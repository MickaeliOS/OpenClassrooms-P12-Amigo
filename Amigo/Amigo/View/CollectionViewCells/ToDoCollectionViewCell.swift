//
//  ToDoCollectionViewCell.swift
//  Amigo
//
//  Created by Mickaël Horn on 10/05/2023.
//

import UIKit

class ToDoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - VIEW LIFE CYCLE
    override func layoutSubviews() {
        super.layoutSubviews()
        setupInterface()
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var toDoLabel: UILabel!
    @IBOutlet weak var deleteItemButton: UIButton!
    var deleteThisCell: (() -> Void)?
    
    // MARK: - ACTIONS
    @IBAction func deleteItemButtonTapped(_ sender: Any) {
        deleteThisCell?()
    }
    
    // MARK: - FUNCTIONS AND PRIVATE FUNCTIONS
    func configureCell(toDo: String) {
        toDoLabel.text = toDo
        setupVoiceOver()
    }
    
    private func setupInterface() {
        contentView.layer.cornerRadius = 15
    }
    
    private func setupVoiceOver() {
        // Labels
        deleteItemButton.accessibilityLabel = "Deletion button."
        
        // Hints
        deleteItemButton.accessibilityHint = "Press to delete your task."
    }
}
