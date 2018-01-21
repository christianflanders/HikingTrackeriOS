//
//  PaceChartViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/20/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import UIKit
import Charts

class PaceChartViewController: UIViewController {


    @IBOutlet weak var paceLineChartView: LineChartView!

    var hikeWorkout: HikeInformation?

    override func viewDidLoad() {
        super.viewDidLoad()

        drawGraphForPace()
    }


    


    func drawGraphForPace() {
        var dataEntries = [ChartDataEntry]()
        guard let hike = hikeWorkout else { return }
        guard let paces = hikeWorkout?.storedPaces else { return }

        for paceObject in paces {
            let meterPerHour = paceObject.metersTraveledPerHour
            let localizedUnitPerHour = meterPerHour.localizedKilometersOrMiles
            let dateStamp = paceObject.timeStamp
            let secondsFromHikeStart = dateStamp.timeIntervalSince(hike.startDate!)
            let dataEntry = ChartDataEntry(x: secondsFromHikeStart, y: localizedUnitPerHour.0)
            dataEntries.append(dataEntry)
        }
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Meters Per Hour")

        chartDataSet.drawCirclesEnabled = false
        chartDataSet.mode = .linear

        let lineData = LineChartData(dataSet: chartDataSet)
        paceLineChartView.data = lineData
    }

}
