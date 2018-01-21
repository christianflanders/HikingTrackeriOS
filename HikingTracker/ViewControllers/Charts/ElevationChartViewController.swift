//
//  ElevationChartViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/20/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import UIKit
import Charts


class ElevationChartViewController: UIViewController, IAxisValueFormatter {


    @IBOutlet weak var elevationLineChartView: LineChartView!

    var hikeWorkout: HikeInformation?

    private var axisFormatDelegate: IAxisValueFormatter?


    override func viewDidLoad() {
        super.viewDidLoad()

        axisFormatDelegate = self
        drawGraphForElevation()

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

    func drawGraphForElevation() {
        let defaultUI = DefaultUI()
        var dataEntries = [ChartDataEntry]()
        guard let hikeWorkout = hikeWorkout else { return }
        guard let startDate = hikeWorkout.startDate else { return }
        for i in 0..<hikeWorkout.storedLocations.count {
            let currentLocation = hikeWorkout.storedLocations[i]
            if i % 10 == 0 {
                let altitude = currentLocation.altitude.localizedFeetOrMeters
                let timeStamp = currentLocation.timestamp
                let secondsSinceStartOfHike = timeStamp.timeIntervalSince(startDate)
                let dataEntry = ChartDataEntry(x: secondsSinceStartOfHike, y: altitude.0)
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

        let xAxis = elevationLineChartView.xAxis
        xAxis.valueFormatter = axisFormatDelegate
        xAxis.labelFont = UIFont(name: "Cabin", size: 8)!

        elevationLineChartView.chartDescription?.enabled = false

        let yAxis = elevationLineChartView.leftAxis
        yAxis.valueFormatter = axisFormatDelegate

        elevationLineChartView.animate(xAxisDuration: 0, yAxisDuration: 2.0)

        elevationLineChartView.drawMarkers = true
        let balloonMarker = BalloonMarker(color: UIColor.gray,
                                          font: UIFont(name: "Cabin", size: 12)!,
                                          textColor: UIColor.white,
                                          insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        balloonMarker.minimumSize = CGSize(width: 80, height: 40)
        balloonMarker.chartView = elevationLineChartView
        elevationLineChartView.marker = balloonMarker
        elevationLineChartView.data = lineData

    }

}
