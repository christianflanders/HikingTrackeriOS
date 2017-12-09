//
//  HikeInProgressViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/4/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit
import HealthKit
import CoreMotion
import CoreLocation
import Mapbox

class HikeInProgressViewController: UIViewController{
    
    //MARK: Enums
    
    //MARK: Constants
    private let locationManager = LocationManager.shared
    private let altimeter = Altimeter.shared
    private let pedometer = CMPedometer()
    
    
    //MARK: Variables
    
    //MARK: Outlets
    @IBOutlet weak var elevationDisplayLabel: UILabel!
    @IBOutlet weak var distanceDisplayLabel: UILabel!
    @IBOutlet weak var durationDisplayLabel: UILabel!
    @IBOutlet weak var caloriesDisplayLabel: UILabel!
    
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var resumeButtonOutlet: UIButton!
    @IBOutlet weak var holdToEndButtonOutlet: UIButton!
    @IBOutlet weak var pauseHikeButtonOutlet: UIButton!
    
    
    
    //MARK: Weak Vars
    
    //MARK: Public Variables
    var shouldStartHike = false
    
    //MARK: Private Variables
    private var seconds = 0
    private var timer : Timer?
    private var paused = false
    private var pedometerData:  CMPedometerData?
    private var coordinatesForLine = [CLLocationCoordinate2D]()
    private var mapView : MGLMapView!
    private var hikeWorkout = HikeWorkout()

    
    //MARK: View Life Cycle

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if shouldStartHike {
            startHike()
            locationManager.activityType = .fitness
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        //Setup map view here becuase it murders interface builder
        let url = URL(string: "mapbox://styles/mapbox/outdoors-v10")
        mapView = MGLMapView(frame: mapContainerView.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapContainerView.addSubview(mapView)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        locationManager.stopUpdatingLocation()
        
    }
    //MARK: IBActions

    
    @IBAction func pauseHikeButtonPressed(_ sender: UIButton) {
        paused = !paused
        pauseOrStopHikeUISettings()
    }
    
    @IBAction func holdToEndButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func resumeButtonPressed(_ sender: UIButton) {
        paused = !paused
        startHikeUISettings()
    }
    
    
    
    //MARK: Instance Methods
    fileprivate func startHikeUISettings() {
        pauseHikeButtonOutlet.isHidden = false
        resumeButtonOutlet.isHidden = true
        holdToEndButtonOutlet.isHidden = true
    }
    
    private func startHike(){
        startTimer()
        print("The start date for the hike objedt is \(hikeWorkout.startDate)")
        startHikeUISettings()
    }
    
    private func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
    }
    
    private func eachSecond(){
        if !paused {
            seconds += 1
            retrievePedometerData()
            calculateDuration(from: hikeWorkout.startDate)
            updateDisplay()
//            storeTimeBasedOnGoingUpOrDownHill()
            if seconds % 10 == 0 && hikeWorkout.storedLocations.count != 0 {
                drawLine(on: mapView)
            }
        }
    }
    
    private func updateDisplay(){
        if let currentLocation = locationManager.location{
            print("Location found")
            let currentLocationAltitudeShortened = Int(currentLocation.altitude)
            elevationDisplayLabel.text = "\(currentLocationAltitudeShortened) ft"
            
            
            guard let distanceTraveled = hikeWorkout.distanceTraveled?.intValue else {
                print("problem getting distance traveled")
                distanceDisplayLabel.text = " "
                return
            }
            distanceDisplayLabel.text = String(describing: distanceTraveled)
        }
        if let currentPace = hikeWorkout.pace {
            
        }
    }
    
    private func calculateDuration(from startDate: Date){
        let currentDuration = startDate.timeIntervalSinceNow
        print(currentDuration)
    }
    
    
    
    fileprivate func pauseOrStopHikeUISettings() {
        pauseHikeButtonOutlet.isHidden = true
        resumeButtonOutlet.isHidden = false
        holdToEndButtonOutlet.isHidden = false
    }
    
    private func retrievePedometerData(){
        if CMPedometer.isStepCountingAvailable() {
            pedometer.startUpdates(from: hikeWorkout.startDate) { data, error in
                if error == nil {
                    guard let data = data else {return}
                    self.hikeWorkout.distanceTraveled = data.distance
                    self.hikeWorkout.pace = data.averageActivePace
                }
            }
        }
        

    }
//    private func grabAndStoreLocation(){
//        if let currentLocation = locationManager.location {
//            hikeWorkout.storedLocations.append(currentLocation)
//            let simplifiedCoordinate = currentLocation.coordinate
//            coordinatesForLine.append(simplifiedCoordinate)
//        }
//    }
    
    
    

    
    
    //MARK: MapBox show line stuff
    
    private func drawLine(on mapView:MGLMapView){
        let line = MGLPolyline(coordinates: coordinatesForLine, count: UInt(coordinatesForLine.count))
        mapView.addAnnotation(line)
    }
}






//MARK: CLLocationManagerDelegate

extension HikeInProgressViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            if newLocation.horizontalAccuracy > 20 && abs(howRecent) > 10 {
                hikeWorkout.storedLocations.append(newLocation)
                
            }
            
    }
    
    
    
    
    
}
}
