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
        setupCell()
        startLoginFlow()
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
    var trips: [LocalTrip]? {
        didSet {
            tripTableView.reloadData()
        }
    }
    
    // MARK: - ACTIONS
    @IBAction func unwindToRootVC(segue: UIStoryboardSegue) {
        if segue.source is CreateAccountVC || segue.source is WelcomeVC {
            startLoginFlow()
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func startLoginFlow() {
        guard userAuth.currentlyLoggedIn else {
            presentVCFullScreen(with: "WelcomeVC")
            return
        }
        
        activityIndicator.isHidden = false

        Task {
            do {
                // First, we fetch the user from Firestore
                try await userFetchingService.fetchUser()
                
                // Then, we need to retrieve his pictures from Storage
                await fetchImages()
                
                // Once we have the complete user, we need to fetch his trips to display them in the tripTableView
                await fetchTrips()
                activityIndicator.isHidden = true

            } catch {
                presentVCFullScreen(with: "WelcomeVC") // TODO: Ne fonctionne pas, seule l'alerte marche. Si pas d'alerte, ça marche.
            }
        }
    }
    
    private func fetchTrips() async {
        do {
            trips = try await tripFetchingService.fetchUserTrips()
        } catch {
            presentAlert(with: error.localizedDescription)
        }
    }
    
    private func fetchImages() async {
        do {
            if let bannerPicture = userAuth.user?.banner?.image {
                userAuth.user?.banner?.data = try await pictureService.getImage(path: bannerPicture)
            }
            
            if let profilePicture = userAuth.user?.profilePicture?.image {
                userAuth.user?.profilePicture?.data = try await pictureService.getImage(path: profilePicture)
            }
        } catch {
            presentAlert(with: error.localizedDescription)
        }
    }
    
    private func setupCell() {
        self.tripTableView.register(UINib(nibName: Constant.TableViewCell.nibName, bundle: nil),
                                    forCellReuseIdentifier: Constant.TableViewCell.tripCell)
    }
}

extension FindTripVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableViewCell.tripCell,
                                                       for: indexPath) as? TripTableViewCell else {
            return UITableViewCell()
        }
        
        guard let trip = trips?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configureCell(profilePicture: userAuth.user?.profilePicture?.data,
                           destination: trip.firstPartAddress,
                           fromDate: trip.startDate,
                           toDate: trip.endDate)
        return cell
    }
}

extension FindTripVC: CreateTripVCDelegate {
    func passCreatedTripToFindTripVC(trip: LocalTrip) {
        trips?.append(trip)
    }
}

extension FindTripVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let createTripVC = segue.destination as? CreateTripVC {
            createTripVC.delegate = self
        }
    }
}
