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


class HikeInProgressViewController: UIViewController, CLLocationManagerDelegate, WCSessionDelegate, MGLMapViewDelegate{
    
    
    //MARK: Enums
    

    //MARK: Constants
    
    private let locationManager = LocationManager.shared
    private let altimeter = Altimeter.shared
    private let pedometer = CMPedometer()
    
    private let watchConnection = WCSession.default
    
    private let watchMessages = WatchConnectionMessages()
    
    
    
    //MARK: Variables
    
    
    //MARK: Outlets
    @IBOutlet weak var altitudeDisplayLabel: UILabel!
    @IBOutlet weak var durationDisplayLabel: UILabel!
    @IBOutlet weak var paceDisplayLabel: UILabel!
    @IBOutlet weak var distanceDisplayLabel: UILabel!
    @IBOutlet weak var caloriesBurnedDisplayLabel: UILabel!
    @IBOutlet weak var sunsetDisplayLabel: UILabel!
    
    @IBOutlet weak var mapContainerView: UIView!
    
    @IBOutlet weak var resumeButtonOutlet: UIButton!
    @IBOutlet weak var holdToEndButtonOutlet: UIButton!
    @IBOutlet weak var pauseHikeButtonOutlet: UIButton!
    
    @IBOutlet weak var duringHikeStatsContainerView: UIView!
    @IBOutlet weak var gradImageView: UIImageView!
    
    
    //MARK: Weak Vars
    
    //MARK: Public Variables
    var shouldStartHike = false
    
    //MARK: Private Variables
    private var seconds = 0
    private var timer : Timer?
    private var pedometerData:  CMPedometerData?
    private var coordinatesForLine = [CLLocationCoordinate2D]()
    private var mapView : MGLMapView!
    private  var hikeWorkout = HikeWorkout()
    
    private var statsHidden = false
    
    private var paused = false
    
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAndStartLocationManager()
        if shouldStartHike {
            startHike()
        }
        createAndAddMapBoxView()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    
    //MARK: IBActions

    @IBAction func pauseHikeButtonPressed(_ sender: UIButton) {
        watchConnection.sendMessage([watchMessages.pauseHike : true], replyHandler: nil, errorHandler: nil)
        pauseHike()
    }
    
    @IBAction func holdToEndButtonPressed(_ sender: UIButton) {
        watchConnection.sendMessage([watchMessages.endHike : true], replyHandler: nil, errorHandler: nil)
        endHike()
        
    }
    

    
    @IBAction func resumeButtonPressed(_ sender: UIButton) {
        watchConnection.sendMessage([watchMessages.resumeHike : true], replyHandler: nil, errorHandler: nil)
        resumeHike()
    }
    
    
    @IBAction func tappedOnMapView(_ sender: UITapGestureRecognizer) {
        let animationDuration = 0.5
        if !statsHidden {
            UIView.animate(withDuration: animationDuration) {
                self.duringHikeStatsContainerView.alpha = 0
                self.gradImageView.alpha = 0
                self.statsHidden = true
            }
            } else {
                UIView.animate(withDuration: animationDuration) {
                    self.duringHikeStatsContainerView.alpha = 1
                    self.gradImageView.alpha = 1
                    self.statsHidden = false
                }
            }
        }
    

    
    //MARK: Hike Lifecycle
    
    private func startHike(){
        hikeWorkout.startDate = Date()
        startTimer()
        checkForWatchConnection()
        startHikeUISettings()
        convertDateAndSendToWatch(date: hikeWorkout.startDate!)
    }
    
    fileprivate func resumeHike() {
        startHikeUISettings()
        paused = false
        hikeWorkout.paused = false

    }
    
    fileprivate func pauseHike() {
        pauseOrStopHikeUISettings()
        paused = true
        hikeWorkout.paused = true
    }
    
    private func endHike(){
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
        hikeWorkout.endDate = Date()
        performSegue(withIdentifier: "HikeFinishedSegue", sender: self)
    }
    //MARK: Timer Functions
    
    private func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
    }
    
    
    private func eachSecond(){
        convertDateAndSendToWatch(date: hikeWorkout.startDate!)
        hikeWorkout.duration += 1
        updateDisplay()
        sendCaloriesToWatch()
        let coordinatesForLine = hikeWorkout.coordinates
        if coordinatesForLine.count != 0 {
            mapView.drawLineOf(coordinatesForLine)
        }
        if paused {
            hikeWorkout.pausedTime += 1
        }
    }
    
    
    
    
    //MARK: UI Functions
    
    private func updateDisplay(){
        //This is kind of hiding the problem where if paused it jumps back and forth between 2 different seconds...🙃
        if !paused {
            let duration = hikeWorkout.durationAsString
            durationDisplayLabel.text = duration
        }

        
        if let altitude = hikeWorkout.lastLocation?.altitude {
            let stringToDisplay = altitude.getDisplayString
            altitudeDisplayLabel.text = stringToDisplay
        }
        
        if let distance = hikeWorkout.totalDistanceTraveled {
            
            let stringToDisplay = distance.getDisplayString
            distanceDisplayLabel.text = stringToDisplay
        }
        
        let caloriesBurned = hikeWorkout.totalCaloriesBurned.getCalorieDisplayString
        caloriesBurnedDisplayLabel.text = caloriesBurned
        
        //TODO: Pace Label
        
        
        if let sunsetTime = hikeWorkout.sunsetTime {
            sunsetDisplayLabel.text = sunsetTime
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
    
    
    
    //MARK: Segue Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HikeFinishedSegue" {
            let destinationVC = segue.destination as! HikeFinishedViewController
            destinationVC.hikeWorkout = hikeWorkout
        }
    }
    

    //MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            print("New Location horiziontal Accuracy is (newLocation.horizontalAccuracy) and the vertical accuracy is \(newLocation.verticalAccuracy)")
            if newLocation.horizontalAccuracy > 2 {
                hikeWorkout.lastLocation = newLocation
                sendDistanceToWatch()
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
    

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Message recieved from watch!")

        
        if let pauseMessage = message[watchMessages.pauseHike] as? Bool {
            if pauseMessage {
                DispatchQueue.main.async {
                    self.pauseHike()
                }
            }
        }
            if let resumeMessage = message[watchMessages.resumeHike] as? Bool {
                if resumeMessage {
                    DispatchQueue.main.async {
                        self.resumeHike()
                    }
                }
            }
        if let endMessage = message[watchMessages.endHike] as? Bool {
            if endMessage {
                DispatchQueue.main.async {
                    self.endHike()
                }
            }
        }

    }
    
    private func checkForWatchConnection() {
        if WCSession.isSupported() {
            watchConnection.delegate = self
            watchConnection.activate()
            if watchConnection.activationState != .activated {
                watchConnection.activate()
            }
            let configuration = HKWorkoutConfiguration()
            configuration.activityType = .hiking
            configuration.locationType = .outdoor
            let healthStore = HKHealthStore()
            healthStore.startWatchApp(with: configuration) { (success, error) in
                if success {
                    print("should be opening watch app with workout configuration")
                }
            }
        }
    }
    
    private func convertDateAndSendToWatch(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .full
        
        let stringDateToSendToWatch = dateFormatter.string(from: date)
        watchConnection.sendMessage([watchMessages.startDate : stringDateToSendToWatch], replyHandler: nil) { error in
            print(error)
        }
    }
    
    private func sendDistanceToWatch() {
        guard let distance = hikeWorkout.totalDistanceTraveled else {return}
        let stringDistance =  String(Int(distance))
        let stringToSend = "\(stringDistance) meters"
        watchConnection.sendMessage([watchMessages.distance : stringToSend], replyHandler: nil) { error in
        print(error)
        }
    }
    
    private func sendCaloriesToWatch() {
        let caloriesBurned = Int(hikeWorkout.totalCaloriesBurned)
        let stringCalories = String(caloriesBurned)
        watchConnection.sendMessage([watchMessages.calories : stringCalories], replyHandler: nil) { error in
            print(error)
        }
    }
    
    
    
    
    //MARK: MapboxView
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
    
    
    //MARK: Solar

    
}
