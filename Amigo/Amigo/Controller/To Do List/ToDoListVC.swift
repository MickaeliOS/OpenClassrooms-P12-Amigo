//
//  ToDoListVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 10/05/2023.
//

import UIKit

class ToDoListVC: UIViewController {

    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupCell()
        setupVoiceOver()
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var toDoTextField: UITextField!
    @IBOutlet weak var addToDoItemButton: UIButton!
    @IBOutlet weak var toDoCollectionView: UICollectionView!
    @IBOutlet weak var saveToDoListButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var noListLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var trip: Trip?
    weak var delegate: ToDoListVCDelegate?
    private let tripUpdateService = TripUpdateService()
    
    // MARK: - ACTIONS
    @IBAction func addToDoItemButtonTapped(_ sender: Any) {
        addToDoItem()
    }
    
    @IBAction func saveToDoListButtonTapped(_ sender: Any) {
        saveToDoList()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        toDoTextField.resignFirstResponder()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        showNoListLabelIfNil()
        addToDoItemButton.layer.cornerRadius = 10
        saveToDoListButton.layer.cornerRadius = 10
        toDoTextField.becomeFirstResponder()
        
        guard let taskImage = UIImage(systemName: "list.bullet") else { return }
        toDoTextField.addLeftSystemImage(image: taskImage)
    }
    
    private func addToDoItem() {
        // If there are no trips, the option to add a task should be unavailable.
        guard let trip = trip else { return }
        
        guard let task = toDoTextField.text, !task.isEmpty else {
            errorMessageLabel.displayErrorMessage(message: "Please provide a task.")
            return
        }
        
        // In case the user doesn't have a to-do list, the list will be nil and appending elements to it won't be possible.
        // Therefore, it's crucial to handle this scenario properly.
        if trip.toDoList == nil {
            var toDoList = [String]()
            toDoList.append(task)
            self.trip?.toDoList = toDoList
        } else {
            self.trip?.toDoList?.append(task)
        }
        
        toDoTextField.text = ""
        noListLabel.isHidden = true
        toDoCollectionView.reloadData()
    }
    
    private func saveToDoList() {
        guard let tripID = trip?.tripID, let toDoList = trip?.toDoList else {
            return
        }
        
        toggleActivityIndicator(shown: true)
        
        Task {
            do {
                // First step -> We store the list in the Firestore database.
                try await tripUpdateService.updateTrip(with: tripID, fields: [Constant.FirestoreTables.Trip.toDoList: toDoList])
                
                // Then, we save the changes locally.
                trip?.toDoList = toDoList

                // It's also essential to propagate the changes to the TripDetailVC, to maintain synchronization across all data points.
                sendTripToPresentingController()
                
                toggleActivityIndicator(shown: false)
                
                presentInformationAlert(with: "Your list has been saved.") {
                    self.navigationController?.popViewController(animated: true)
                }
                
            } catch let error as Errors.DatabaseError {
                presentErrorAlert(with: error.localizedDescription)
                toggleActivityIndicator(shown: false)
            }
        }
    }
    
    private func sendTripToPresentingController() {
        guard let trip = trip else { return }
        
        // We need to communicate eventuals changes.
        delegate?.getTripFromToDoListVC(trip: trip)
    }
    
    private func showNoListLabelIfNil() {
        if trip?.toDoList == nil || trip?.toDoList?.isEmpty == true {
            noListLabel.isHidden = false
        }
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        // If shown is true, then the refresh button is hidden and we display the Activity Indicator
        // If not, we hide the Activity Indicator and show the refresh button
        saveToDoListButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    
    private func setupCell() {
        self.toDoCollectionView.register(UINib(nibName: Constant.CollectionViewCells.toDoNibName, bundle: nil),
                                         forCellWithReuseIdentifier: Constant.CollectionViewCells.toDoCell)
    }
    
    private func setupVoiceOver() {
        addToDoItemButton.accessibilityHint = "Press to add a task."
        saveToDoListButton.accessibilityHint = "Press to save your tasks."
    }
}

// MARK: - EXTENSIONS & PROTOCOL
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

        cell.deleteThisCell = {
            if let indexPath = collectionView.indexPath(for: cell) {
                self.trip?.toDoList?.remove(at: indexPath.row)
                collectionView.deleteItems(at: [indexPath])
                self.showNoListLabelIfNil()
            }
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
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        errorMessageLabel.isHidden = true
    }
}

protocol ToDoListVCDelegate: AnyObject {
    func getTripFromToDoListVC(trip: Trip)
}
