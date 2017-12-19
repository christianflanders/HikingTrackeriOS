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
import WatchConnectivity


class HikeInProgressViewController: UIViewController, CLLocationManagerDelegate, WCSessionDelegate{

    
    //MARK: Enums
    enum ElevationDirection {
        case uphill
        case downhill
    }
    //MARK: Constants
    private let locationManager = LocationManager.shared
    private let altimeter = Altimeter.shared
    private let pedometer = CMPedometer()
    
    private let watchConnection = WCSession.default
    
    
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
    private  var hikeWorkout = HikeWorkout()
    private var elevationDirection: ElevationDirection?
    
    
    
    //MARK: View Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
        if shouldStartHike {
            startHike()
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
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
        hikeWorkout.endDate = Date()
        performSegue(withIdentifier: "HikeFinishedSegue", sender: self)
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
        hikeWorkout.startDate = Date()
        startTimer()

        checkForWatchConnection()
        startHikeUISettings()
        convertDateAndSendToWatch(date: hikeWorkout.startDate!)

    }
    
    private func checkForWatchConnection() {
        if WCSession.isSupported() {
            watchConnection.delegate = self
            watchConnection.activate()
            if watchConnection.activationState != .activated {
                watchConnection.activate()
            }
//            let configuration = HKWorkoutConfiguration()
//            configuration.activityType = .hiking
//            configuration.locationType = .outdoor
//            let healthStore = HKHealthStore()
//            healthStore.startWatchApp(with: configuration) { (success, error) in
//                if success {
//                    print("should be opening watch app with workout configuration")
//                }
//            }
        }
    }
    
    private func convertDateAndSendToWatch(date: Date){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .full
        
        let stringDateToSendToWatch = dateFormatter.string(from: date)
        watchConnection.sendMessage(["startDate" : stringDateToSendToWatch], replyHandler: nil) { error in
                print(error)
        }
    }
    
    private func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
    }
    
    private func eachSecond(){
        convertDateAndSendToWatch(date: hikeWorkout.startDate!)
        if !paused {
            seconds += 1

            if let coordinate = locationManager.location?.coordinate {
                coordinatesForLine.append(coordinate)
            }
//            retrievePedometerData()
            updateDisplay()
            if let elevationDirection = elevationDirection {
                switch elevationDirection {
                case .uphill :
                    hikeWorkout.timeTraveldUpHill += 1
                case .downhill :
                    hikeWorkout.timeTraveledDownHill += 1
                }
            }
            if  coordinatesForLine.count != 0 {
                mapView.drawLineOf(coordinatesForLine)
            }
            }
    }
    
    private func updateDisplay(){
        durationDisplayLabel.text = hikeWorkout.durationAsString
        if let totalDistanceTraveled = hikeWorkout.totalDistanceTraveled {
            distanceDisplayLabel.text = String(Int(totalDistanceTraveled))
        }
        
        
        if let currentLocation = hikeWorkout.storedLocations.last?.altitude{
            let currentLocationAltitudeShortened = Int(currentLocation)
            elevationDisplayLabel.text = "\(currentLocationAltitudeShortened) ft"
            

        }

        
    }
    

    
    
    
    fileprivate func pauseOrStopHikeUISettings() {
        pauseHikeButtonOutlet.isHidden = true
        resumeButtonOutlet.isHidden = false
        holdToEndButtonOutlet.isHidden = false
    }
    

    
    //MARK: Segue Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HikeFinishedSegue" {
            let destinationVC = segue.destination as! HikeFinishedViewController
            destinationVC.hikeWorkout = hikeWorkout
        }
    }
    
    
    
    
    
    //MARK: MapBox show line stuff
    

    
    
    //MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("This is getting called")
        for newLocation in locations {
            print(newLocation.horizontalAccuracy)
            if newLocation.horizontalAccuracy > 2 {
                print("New Location found to store")
                hikeWorkout.lastLocation = newLocation
            }
        }
    }
    
    
    
    
    
    //MARK: Watch Connectivity Delegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Watch session became inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("Watch session deactivated")
    }
    
    //MARK: Watch Connection Functions
    
    
    
    
}
