//
//  HikeChartsViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/31/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit
import Charts

class HikeChartsViewController: UIViewController {
    
    
    // MARK: Enums
    
    // MARK: Constants
    
    
    // MARK: Variables
    
    
    // MARK: Outlets
    @IBOutlet weak var elevationGainLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    @IBOutlet weak var elevationChartView: LineChartView!
    
    
    @IBOutlet weak var paceChartView: UIView!
    
    // MARK: Weak Vars
    
    
    // MARK: Public Variables
    public var hikeWorkout = HikeWorkout()
    
    // MARK: Private Variables
    
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        drawGraph()
    }
    
    
    // MARK: IBActions
    
    
    // MARK: Charts
    func drawGraph(){
        var dataEntries = [ChartDataEntry]()
        for i in 0..<hikeWorkout.storedLocations.count {
            let altitude = hikeWorkout.storedLocations[i].altitude
            
            let dataEntry = ChartDataEntry(x: Double(i), y: altitude)
            dataEntries.append(dataEntry)
        }
        let sortedAltitudes = hikeWorkout.storedLocations.sorted {
            $0.altitude < $1.altitude
        }
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Elevation in Meters")
        
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.mode = .linear
        
        let lineData = LineChartData(dataSet: chartDataSet)
        elevationChartView.data = lineData
        
    }
    
}
