//
//  HikeHistoryViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/4/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit
import Firebase

class HikeHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    // MARK: Enums
    
    // MARK: Constants
    private let hikeSelectedSegue = "HikeFromHistorySelected"
    
    private let navigationBarBackgroundImage = DefaultUI().navBarBackgroundImage
    
    
    // MARK: Variables
    
    
    // MARK: Outlets
    @IBOutlet weak var hikeHistoryTableView: UITableView!
    
    // MARK: Weak Vars
    
    
    // MARK: Public Variables
    var selectedHikeWorkout: DecodedHike?
    var ref: DatabaseReference!
    var handle: DatabaseHandle!
    
    // MARK: Private Variables
    private var pastWorkouts = [DecodedHike]()
    private var workouts = [[String: Any]]()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hikeHistoryTableView.delegate = self
        hikeHistoryTableView.dataSource = self
        
        downloadWorkoutsFromFirebase()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        downloadWorkoutsFromFirebase()
    }
    
    // MARK: IBActions
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == hikeSelectedSegue {
            guard let destinationVC = segue.destination  as? HikeHistoryDetailTableViewController else {fatalError("Problem with hike history segue")}
            destinationVC.hikeWorkout = selectedHikeWorkout
        }
    }
    
    
    
    // MARK: Download Workouts From Firebase
    
    func downloadWorkoutsFromFirebase() {
        // TODO: Add in user ID checking
        ref = Database.database().reference()
        handle = ref.child("HikeWorkouts").observe(.childAdded, with: { (snapshot) in
            let hikeDict = snapshot.value as? [String: Any] ?? [:]
            //            print(hikeDict)
            let decodedHike = DecodedHike(fromFirebaseDict: hikeDict)
            self.pastWorkouts.append(decodedHike)
            self.pastWorkouts.sort { $0.startDate! > $1.startDate! }
            self.hikeHistoryTableView.reloadData()
            print("There are \(self.pastWorkouts.count) Workouts")
        })
        
        
    }
    // MARK: TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastWorkouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HikeHistoryCell") as? HikeHistoryTableViewCell else {fatalError("Problem with getting hike history table view cell")}
        let index = indexPath.row
        let workout = pastWorkouts[index]
        
        //        cell.hikeNameLabel.text = workout.hikeName
        //
        cell.hikeDateLabel.text = workout.startDate?.displayString
        let duration = workout.durationInSeconds
            let durationString = DateHelper().convertDurationToStringDate(duration)
            cell.hikeDurationLabel.text = durationString
        
        //        cell.hikeDistanceLabel.text = workout.totalDistanceTraveled?.getDisplayString
        
        return cell
    }
    
    // MARK: TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        selectedHikeWorkout = pastWorkouts[index]
        performSegue(withIdentifier: hikeSelectedSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}

