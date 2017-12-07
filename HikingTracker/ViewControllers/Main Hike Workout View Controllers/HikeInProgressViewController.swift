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

class HikeInProgressViewController: UIViewController, CLLocationManagerDelegate{
    
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
    private var startDate: Date?
    private var distanceTraveled: NSNumber?
//    private var currentAltitude: NSNumber?
//    private var storedAltitudes: [NSNumber]?
    private var storedLocations = [CLLocation]()
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if shouldStartHike {
            startHike()
            pauseHikeButtonOutlet.isHidden = false
            resumeButtonOutlet.isHidden = true
            holdToEndButtonOutlet.isHidden = true
            locationManager.activityType = .fitness
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        locationManager.stopUpdatingLocation()
        
    }
    //MARK: IBActions
    @IBAction func pauseHikeButtonPressed(_ sender: UIButton) {
        paused = !paused
        pauseHikeButtonOutlet.isHidden = true
        resumeButtonOutlet.isHidden = false
        holdToEndButtonOutlet.isHidden = false
    }
    
    @IBAction func holdToEndButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func resumeButtonPressed(_ sender: UIButton) {
        paused = !paused
        pauseHikeButtonOutlet.isHidden = false
        resumeButtonOutlet.isHidden = true
        holdToEndButtonOutlet.isHidden = true
    }
    
    
    
    //MARK: Instance Methods
    private func startHike(){
        startTimer()
//        startAltimeter()
        startDate = Date()
//        let currentHike = HikeWorkout(start: startDate)
    }
    
    private func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
            
        }
    }
    
    private func eachSecond(){
        if !paused {
            seconds += 1

            grabAndStoreLocation()
            retrievePedometerData()
            
            
            
            updateDisplay()
        }
    }
    
    private func updateDisplay(){
        durationDisplayLabel.text = String(seconds)
        if let currentLocation = locationManager.location{
            print("Location found")
            let currentLocationAltitudeShortened = Int(currentLocation.altitude)
            elevationDisplayLabel.text = "\(currentLocationAltitudeShortened) ft"
            guard let distanceTraveled = distanceTraveled?.intValue else {
                print("problem getting distance traveled")
                return
                
            }
            distanceDisplayLabel.text = String(describing: distanceTraveled)
        }

    }
    
    private func retrievePedometerData(){
        guard let startDate = startDate else {return}
        pedometer.startUpdates(from: startDate) { data, error in
            if error == nil {
                guard let data = data else {return}
                print(data.distance)
                self.distanceTraveled = data.distance
            }
            
            
        }
    }
    
    
    
    private func grabAndStoreLocation(){
        if let currentLocation = locationManager.location {
            storedLocations.append(currentLocation)
        }
    }
    
    
    
    
    //MARK: Location Manager Delegate
    
    
    
    
    
    
}
