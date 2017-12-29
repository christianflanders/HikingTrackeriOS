//
//  HikeHistoryViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/4/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit

class HikeHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    private let hikeSelectedSegue = "HikeFromHistorySelected"
    
    private let persistantContainer = PersistanceService.store
    
    @IBOutlet weak var hikeHistoryTableView: UITableView!
    
    private var pastWorkouts = [HikeWorkout]()
    
    
    var selectedHikeWorkout = HikeWorkout()
    
    private let navigationBarBackgroundImage = DefaultUI().navBarBackgroundImage
    

    override func viewDidLoad() {
        super.viewDidLoad()


//        self.navigationController?.navigationBar.prefersLargeTitles = true
        

        self.navigationController?.navigationBar.setBackgroundImage(navigationBarBackgroundImage,
                                                                    for: .default)
        self.navigationController?.navigationBar.tintColor = DefaultUI().defaultBlack
    }

    
    override func viewDidAppear(_ animated: Bool) {
        getWorkoutsFromMemoryAndUpdateTable()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == hikeSelectedSegue {
            guard let destinationVC = segue.destination  as? HikeHistoryDetailTableViewController else {fatalError("Problem with hike history segue")}
            destinationVC.hikeWorkout = selectedHikeWorkout
        }
    }
    
    //MARK: TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastWorkouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HikeHistoryCell") as? HikeHistoryTableViewCell else {fatalError("Problem with getting hike history table view cell")}
        let index = indexPath.row
        let workout = pastWorkouts[index]
        
        cell.hikeNameLabel.text = workout.hikeName
    
        cell.hikeDateLabel.text = workout.startDate?.displayString
        cell.hikeDistanceLabel.text = "\(Int(workout.totalDistanceTraveled!)) meters"

        return cell
    }
    
    //MARK: TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        selectedHikeWorkout = pastWorkouts[index]
        performSegue(withIdentifier: hikeSelectedSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    fileprivate func getWorkoutsFromMemoryAndUpdateTable() {
        persistantContainer.fetchWorkouts()
        pastWorkouts = persistantContainer.fetchedWorkouts
        hikeHistoryTableView.delegate = self
        hikeHistoryTableView.dataSource = self
        hikeHistoryTableView.reloadData()
    }
}
