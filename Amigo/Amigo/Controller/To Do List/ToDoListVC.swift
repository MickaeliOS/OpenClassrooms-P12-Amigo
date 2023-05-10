//
//  ToDoListVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 10/05/2023.
//

import UIKit

class ToDoListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    
    @IBOutlet weak var toDoLabel: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var toDoCollectionView: UICollectionView!
    @IBOutlet weak var saveToDoListButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    var trip: Trip?
    
    @IBAction func addButtonTapped(_ sender: Any) {
        addToDoItem()
    }
    
    @IBAction func saveToDoListButtonTapped(_ sender: Any) {
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        toDoLabel.resignFirstResponder()
    }
    
    private func setupInterface() {
        addButton.layer.cornerRadius = 10
        saveToDoListButton.layer.cornerRadius = 10
    }
    
    private func addToDoItem() {
        // If there are no trips, the option to add a task should be unavailable.
        guard let trip = trip else { return }
        
        guard let task = toDoLabel.text, !task.isEmpty else {
            errorMessageLabel.displayErrorMessage(message: "Please provide a task.")
            return
        }
        
        if trip.toDoList == nil {
            var toDoList = [String]()
            toDoList.append(task)
            self.trip?.toDoList = toDoList
            return
        }
        
        self.trip?.toDoList?.append(task)
        toDoCollectionView.reloadData()
    }
}

extension ToDoListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trip?.toDoList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.CollectionViewCells.toDoCell, for: indexPath) as? ToDoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let toDoList = trip?.toDoList else {
            return UICollectionViewCell()
        }
        
        let toDoItem = toDoList[indexPath.row]
        cell.configureCell(toDo: toDoItem)
        
        return cell
    }
}

extension ToDoListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension ToDoListVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        toDoLabel.resignFirstResponder()
        return true
    }
}
