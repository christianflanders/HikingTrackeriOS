//
//  HikeChartsViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/31/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit
import Charts

class HikeChartsViewController: UIViewController, IAxisValueFormatter {

    

    
    
    // MARK: Enums
    
    // MARK: Constants
    
    
    // MARK: Variables
    
    
    // MARK: Outlets
    @IBOutlet weak var elevationGainLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    @IBOutlet weak var elevationChartView: LineChartView!
    
    
    
    @IBOutlet weak var paceChartGraph: LineChartView!
    // MARK: Weak Vars
    
    
    // MARK: Public Variables
    public var hikeWorkout: DecodedHike?
    
    // MARK: Private Variables
    private var axisFormatDelegate: IAxisValueFormatter?
    private var yAxisFormatDelegate: IAxisValueFormatter?
    
    
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        drawGraphForElevation()
        drawGraphForPace()
        axisFormatDelegate = self
        elevationGainLabel.text = hikeWorkout?.totalElevationDifferenceInMeters.getDisplayString
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        drawGraphForElevation()
        drawGraphForPace()
    }
    
    // MARK: IBActions
    
    
    // MARK: Charts
    func drawGraphForElevation() {
        let defaultUI = DefaultUI()
        var dataEntries = [ChartDataEntry]()
        guard let hikeWorkout = hikeWorkout else { return }
        guard let startDate = hikeWorkout.startDate else { return }
        for i in 0..<hikeWorkout.storedLocations.count {
            let currentLocation = hikeWorkout.storedLocations[i]
            if i % 10 == 0 {
                let altitude = currentLocation.altitude
                let timeStamp = currentLocation.timestamp
                let secondsSinceStartOfHike = timeStamp.timeIntervalSince(startDate)
                let dataEntry = ChartDataEntry(x: secondsSinceStartOfHike, y: altitude)
                dataEntries.append(dataEntry)
            }
        }

        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Elevation in Meters")
        
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.mode = .horizontalBezier
        chartDataSet.cubicIntensity = 0.2
        chartDataSet.drawFilledEnabled = true
        chartDataSet.fill = Fill(color: defaultUI.navBarBackgroundColor)
        chartDataSet.fillAlpha = 1
        chartDataSet.colors = [defaultUI.navBarBackgroundColor]
        
        let lineData = LineChartData(dataSet: chartDataSet)
        lineData.setDrawValues(false)
        
        let xAxis = elevationChartView.xAxis
        xAxis.valueFormatter = axisFormatDelegate
        xAxis.labelFont = UIFont(name: "Cabin", size: 8)!
        
        elevationChartView.chartDescription?.enabled = false
        
        let yAxis = elevationChartView.leftAxis
        yAxis.valueFormatter = axisFormatDelegate
        
        elevationChartView.animate(xAxisDuration: 0, yAxisDuration: 2.0)
        
        elevationChartView.drawMarkers = true
        let balloonMarker = BalloonMarker(color: UIColor.gray,
                                          font: UIFont(name: "Cabin", size: 12)!,
                                          textColor: UIColor.white,
                                          insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        balloonMarker.minimumSize = CGSize(width: 80, height: 40)
        balloonMarker.chartView = elevationChartView
        elevationChartView.marker = balloonMarker
        
        elevationChartView.data = lineData
    }

    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if axis is XAxis {
            let dateHelper = DateHelper()
            let convertedToString = dateHelper.convertDurationToStringDate(value)
            return convertedToString
        } else if axis is YAxis {
            let localizedString = value.getMetersOrFeetOnly
            return localizedString
        }
        return "\(value)"
    }
    
    
    

    
    
    
    func drawGraphForPace() {
//        var dataEntries = [ChartDataEntry]()
//        for paceObject in hikeWorkout.storedPaceHistory {
//            let meterPerHour = paceObject.metersPerHourValue
//            let dateStamp = paceObject.timeStamp
//            let secondsFromHikeStart = dateStamp.timeIntervalSince(hikeWorkout.startDate!)
//            let dataEntry = ChartDataEntry(x: secondsFromHikeStart, y: meterPerHour)
//            dataEntries.append(dataEntry)
//        }
//        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Meters Per Hour")
//        
//        chartDataSet.drawCirclesEnabled = false
//        chartDataSet.mode = .linear
//        
//        let lineData = LineChartData(dataSet: chartDataSet)
//        paceChartGraph.data = lineData
    }
    
}


