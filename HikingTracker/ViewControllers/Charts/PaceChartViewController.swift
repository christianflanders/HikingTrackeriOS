//
//  PaceChartViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/20/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import UIKit
import Charts

class PaceChartViewController: UIViewController, IAxisValueFormatter {


    @IBOutlet weak var paceLineChartView: LineChartView!

    private var axisFormatDelegate: IAxisValueFormatter?
    var hikeWorkout: HikeInformation?

    override func viewDidLoad() {
        super.viewDidLoad()
        axisFormatDelegate = self
        drawGraphForPace()
    }


    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if axis is XAxis {
            let dateHelper = DateHelper()
            let convertedToString = dateHelper.convertDurationToStringDate(value)
            return convertedToString
        } else if axis is YAxis {
            print(value)
            let localized = Int(value.localizedKilometersOrMiles.value)

            let localizedString = "\(value) / hr"
            return localizedString
        }
        return "\(value)"
    }
    var paces = [Double]()

    func drawGraphForPace() {
        var dataEntries = [ChartDataEntry]()
        guard let hike = hikeWorkout else { return }
        guard let paces = hikeWorkout?.storedPaces else { return }

        for paceObject in paces {
            let meterPerHour = paceObject.metersTraveledPerHour
            let localizedUnitPerHour = meterPerHour.localizedKilometersOrMiles
            let dateStamp = paceObject.timeStamp
            let secondsFromHikeStart = dateStamp.timeIntervalSince(hike.startDate!)
            let dataEntry = ChartDataEntry(x: secondsFromHikeStart, y: localizedUnitPerHour.value)
            dataEntries.append(dataEntry)
        }
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Meters Per Hour")

        let xAxis = paceLineChartView.xAxis
        xAxis.valueFormatter = axisFormatDelegate
        xAxis.labelFont = UIFont(name: "Cabin", size: 8)!

        paceLineChartView.chartDescription?.enabled = false

        let yAxis = paceLineChartView.leftAxis
        yAxis.valueFormatter = axisFormatDelegate

        paceLineChartView.animate(xAxisDuration: 0, yAxisDuration: 2.04)
        
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.mode = .cubicBezier
        chartDataSet.drawFilledEnabled = true
        chartDataSet.fill = Fill(color: UIColor.blue)
        chartDataSet.fillAlpha = 1
        chartDataSet.colors = [UIColor.blue
        ]
        let lineData = LineChartData(dataSet: chartDataSet)
        paceLineChartView.data = lineData
    }

}
