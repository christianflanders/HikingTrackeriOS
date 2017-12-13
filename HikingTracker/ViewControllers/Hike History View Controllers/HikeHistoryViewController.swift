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
    
    let dateFormatter = DateFormatter()
    
    var selectedHikeWorkout = HikeWorkout()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        persistantContainer.fetchWorkouts()
        pastWorkouts = persistantContainer.fetchedWorkouts
        hikeHistoryTableView.delegate = self
        hikeHistoryTableView.dataSource = self
        hikeHistoryTableView.reloadData()
        
        
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == hikeSelectedSegue {
            let destinationVC = segue.destination as! HikeHistoryDetailViewController
            destinationVC.hikeWorkout = selectedHikeWorkout
        }
    }
    
    //MARK: TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastWorkouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HikeHistoryCell") as! HikeHistoryTableViewCell
        let index = indexPath.row
        let workout = pastWorkouts[index]
        
        cell.hikeNameLabel.text = workout.hikeName
        let startDate = workout.startDate
        let convertedStartDate = dateFormatter.string(from: startDate!)
    
        cell.hikeDateLabel.text = convertedStartDate
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
}
