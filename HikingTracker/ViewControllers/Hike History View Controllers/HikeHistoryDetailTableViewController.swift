//
//  HikeHistoryDetailTableViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/26/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit

class HikeHistoryDetailTableViewController: UITableViewController {

    let statsToDisplay: [Stats] = [.duration, .distance, . elevationGain, .calories, .avgPace, .avgHeartRate, .minAltitude, .maxAltitude, .timeUphill, .timeDownhill]
    
    
    var hikeWorkout = HikeWorkout()
    
    
    @IBOutlet weak var statsCollectionView: UICollectionView!
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var elevationGainLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var avgPaceLabel: UILabel!
    @IBOutlet weak var avgHeartRateLabel: UILabel!
    @IBOutlet weak var minAltitudeLabel: UILabel!
    @IBOutlet weak var maxAltitudeLabel: UILabel!
    @IBOutlet weak var timeUphillLabel: UILabel!
    @IBOutlet weak var timeDownhillLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        statsCollectionView.delegate = self
//        statsCollectionView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


//    //MARK: Collection View Data Source
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 8
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatCell", for: indexPath) as? StatHistoryCollectionViewCell else {fatalError("Error creating collection view cell")}
//        cell.hikeWorkout = hikeWorkout
//        cell.setCellForStat(statsToDisplay[indexPath.row])
//        return cell
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }

}
