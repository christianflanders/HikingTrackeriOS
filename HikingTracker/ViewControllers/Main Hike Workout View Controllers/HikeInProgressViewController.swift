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

class HikeInProgressViewController: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate{
    
    // MARK: Enums
    
    // MARK: Constants
    
    private let locationManager = LocationManager.shared
    
    private let pedometer = CMPedometer()
    
    private let watchConnection = WCSession.default
    
    private let watchMessages = WatchConnectionMessages()
    
    // MARK: Variables
    
    // MARK: Outlets

    
    @IBOutlet weak var mapContainerView: UIView!
    
    @IBOutlet weak var resumeButtonOutlet: UIButton!
    @IBOutlet weak var holdToEndButtonOutlet: UIButton!
    @IBOutlet weak var pauseHikeButtonOutlet: UIButton!
    
    @IBOutlet weak var hikeStatsDisplay: HikeInProgressStatDisplay!
    @IBOutlet weak var gradImageView: UIImageView!
    
    // MARK: Weak Vars
    
    // MARK: Public Variables
    var shouldStartHike = false
    
    // MARK: Private Variables
    private var seconds = 0
    private var timer: Timer?
    private var pedometerData:  CMPedometerData?
    private var coordinatesForLine = [CLLocationCoordinate2D]()
    private var mapView: MGLMapView!
    private  var hikeWorkout = HikeInProgress()
    private var currentSpeedInMetersPerSecond = 0.0
    
    private var statsHidden = false
    
    private var paused = false
    
    private var currentLocation = CLLocation()
    
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAndStartLocationManager()
        if shouldStartHike {
            startHike()
        }
        createAndAddMapBoxView()
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
    }
    // MARK: Location Manager Delegaet
    // This is where we do most of the work, giving the hike workout object each location we get from the location manager
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            print("New Location horiziontal Accuracy is (newLocation.horizontalAccuracy) and the vertical accuracy is \(newLocation.verticalAccuracy)")
            if newLocation.horizontalAccuracy > 2 {
                hikeWorkout.addNewLocation(newLocation)
                currentLocation = newLocation
//                sendDistanceToWatch()
            }
        }
    }
    
    fileprivate func setupAndStartLocationManager() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
    }
    
    // MARK: IBActions
    
    @IBAction func pauseHikeButtonPressed(_ sender: UIButton) {
        watchConnection.sendMessage([watchMessages.pauseHike: true], replyHandler: nil, errorHandler: nil)
        pauseHike()
    }
    
    @IBAction func holdToEndButtonPressed(_ sender: UIButton) {
        watchConnection.sendMessage([watchMessages.endHike: true], replyHandler: nil, errorHandler: nil)
        endHike()
    }
    
    @IBAction func resumeButtonPressed(_ sender: UIButton) {
        watchConnection.sendMessage([watchMessages.resumeHike: true], replyHandler: nil, errorHandler: nil)
        resumeHike()
    }
    
    @IBAction func tappedOnMapView(_ sender: UITapGestureRecognizer) {
        let animationDuration = 0.5
        if !statsHidden {
            mapView.userLocationVerticalAlignment = MGLAnnotationVerticalAlignment.center
            UIView.animate(withDuration: animationDuration) {
                
                self.hikeStatsDisplay.alpha = 0
                self.gradImageView.alpha = 0
                self.statsHidden = true
            }
        } else {
            mapView.userLocationVerticalAlignment = MGLAnnotationVerticalAlignment.top
            UIView.animate(withDuration: animationDuration) {
                self.hikeStatsDisplay.alpha = 1
                self.gradImageView.alpha = 1
                self.statsHidden = false
            }
        }
    }
    
    // MARK: Hike Lifecycle
    
    private func startHike() {
        hikeWorkout.startDate = Date()
        startTimer()
//        checkForWatchConnection()
        startHikeUISettings()
//        convertDateAndSendToWatch(date: hikeWorkout.startDate!)
//        startPedometerAndUpdatePace()

    }
    
    fileprivate func resumeHike() {
        startHikeUISettings()
        paused = false
        hikeWorkout.paused = false
        hikeWorkout.addNewLocation(currentLocation)
        let resumeTime = Date()
        hikeWorkout.resumeHike(time: resumeTime)
    }
    
    fileprivate func pauseHike() {
        pauseOrStopHikeUISettings()
        paused = true
        hikeWorkout.paused = true
        hikeWorkout.addNewLocation(currentLocation)
        let pauseTime = Date()
        hikeWorkout.pauseHike(time: pauseTime)

    }
    
    private func sendPauseHikeNotification() {
        
    }
    
    private func endHike() {
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
        hikeWorkout.endDate = Date()
        openHikeFinishedVC()
//        performSegue(withIdentifier: "HikeFinishedSegue", sender: self)
    }
    // MARK: Timer Functions
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
    }
    
    private func eachSecond() {
//        convertDateAndSendToWatch(date: hikeWorkout.startDate!)https://academy.realm.io/
        updateDisplay()
        print(Date())
//        sendCaloriesToWatch()
        let coordinatesForLine = hikeWorkout.coordinates
        if coordinatesForLine.count != 0 {
            mapView.drawLineOf(coordinatesForLine)
        }
//        if paused {
//            hikeWorkout.pausedTime += 1
//        }
    }
    
    // MARK: UI Functions
    
    private func updateDisplay() {
        let converter = HikeDisplayStrings()
        let newDisplay = converter.getInProgressDisplayStrings(hike: hikeWorkout)
        
        if !paused {
            hikeStatsDisplay.setDisplay(with: newDisplay)
        }

    }
    
    fileprivate func startHikeUISettings() {
        pauseHikeButtonOutlet.isHidden = false
        resumeButtonOutlet.isHidden = true
        holdToEndButtonOutlet.isHidden = true
    }
    
    fileprivate func pauseOrStopHikeUISettings() {
        pauseHikeButtonOutlet.isHidden = true
        resumeButtonOutlet.isHidden = false
        holdToEndButtonOutlet.isHidden = false
    }

    // MARK: Segue Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HikeFinishedSegue" {
            guard let destinationVC = segue.destination as? HikeFinishedTableViewController else {fatalError("Problem with HikeFinishedSegue")}
            destinationVC.hikeWorkout = hikeWorkout
        }
    }
    
    func openHikeFinishedVC() {
        performSegue(withIdentifier: "HikeFinishedSegue", sender: self)
    }

    // MARK: MapboxView
    
    fileprivate func createAndAddMapBoxView() {
        //Setup map view here becuase it murders interface builder
        let url = URL(string: "mapbox://styles/mapbox/outdoors-v10")
        mapView = MGLMapView(frame: mapContainerView.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = true
        mapView.userLocationVerticalAlignment = .top
        mapView.userTrackingMode = .follow
        mapContainerView.addSubview(mapView)
    }
    
    // MARK: Solar
    
}
