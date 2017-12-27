//
//  HikeHistoryDetailTableViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/26/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit

class HikeHistoryDetailTableViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let statsToDisplay: [Stats] = [.duration, .distance, . elevationGain, .calories, .avgPace, .avgHeartRate, .minAltitude, .maxAltitude, .timeUphill, .timeDownhill]
    
    
    var hikeWorkout = HikeWorkout()
    
    
    @IBOutlet weak var statsCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        statsCollectionView.delegate = self
        statsCollectionView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK: Collection View Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatCell", for: indexPath) as! StatHistoryCollectionViewCell
        cell.hikeWorkout = hikeWorkout
        cell.setCellForStat(statsToDisplay[indexPath.row])
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

}
