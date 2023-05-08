//
//  TripJourneyVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 08/05/2023.
//

import UIKit

class TripJourneyVC: UIViewController {
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCell()
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var journeyTableView: UITableView!
    
    var trip: Trip?
    
    // MARK: - ACTIONS
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        saveButton.layer.cornerRadius = 10
    }
    
    private func setupCell() {
        self.journeyTableView.register(UINib(nibName: Constant.TableViewCells.journeyNibName, bundle: nil),
                                    forCellReuseIdentifier: Constant.TableViewCells.journeyCell)
    }
}
