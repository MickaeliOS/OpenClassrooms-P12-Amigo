//
//  FindTripVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 14/04/2023.
//

import UIKit
import FirebaseAuth

class FindTripVC: UIViewController {
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoginFlow()
        setupCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var tripTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var userAuth = UserAuth.shared
    private let userFetchingService = UserFetchingService()
    private let pictureService = PictureService()
    private let tripFetchingService = TripFetchingService()
    private var trips: [Trip]?
    
    // MARK: - ACTIONS
    @IBAction func unwindToRootVC(segue: UIStoryboardSegue) {}
    
    // MARK: - PRIVATE FUNCTIONS
    private func startLoginFlow() {
        guard userAuth.currentlyLoggedIn else {
            presentVCFullScreen(with: "WelcomeVC")
            return
        }
        
        activityIndicator.isHidden = false

        Task {
            do {
                try await userFetchingService.fetchUser()
                
                if let profilePicture = userAuth.user?.profilePicture?.image {
                    userAuth.user?.profilePicture?.data = try await pictureService.getImage(path: profilePicture)
                }
                
                if let bannerPicture = userAuth.user?.banner?.image {
                    userAuth.user?.banner?.data = try await pictureService.getImage(path: bannerPicture)
                }
                
                await fetchTrips()
                setupInterface()
            } catch {
                presentAlert(with: error.localizedDescription)
                presentVCFullScreen(with: "WelcomeVC") // TODO: Ne fonctionne pas, seul l'alerte marche. Si pas d'alerte, ça marche.
            }
        }
    }
    
    private func setupInterface() {
        self.activityIndicator.isHidden = true
    }
    
    private func fetchTrips() async {
        do {
            trips = try await tripFetchingService.fetchUserTrips()
            tripTableView.reloadData()
        } catch {
            presentAlert(with: error.localizedDescription)
        }
    }
    
    private func setupCell() {
        self.tripTableView.register(UINib(nibName: "TripTableViewCell", bundle: nil), forCellReuseIdentifier: "tripCell")
    }
}

extension FindTripVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? TripTableViewCell else {
            return UITableViewCell()
        }
        
        guard let trip = trips?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configureCell(profilePicture: userAuth.user?.profilePicture?.data,
                           destination: trip.destination,
                           fromDate: trip.startDate,
                           toDate: trip.endDate)
        return cell
    }
}
