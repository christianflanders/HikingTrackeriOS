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
import WatchKit
import WatchConnectivity
import AVFoundation

class HikeInProgressViewController: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate{
    
    // MARK: Enums
    
    // MARK: Constants



    
    private let locationManager = LocationManager.shared
    
    fileprivate let watchConnection = WCSession.default
    
    fileprivate let watchMessages = WatchConnectionMessages()
    
    // MARK: Variables

    private var player: AVAudioPlayer?
    
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
        print("View dissapearing")
        super.viewWillDisappear(true)
        timer?.invalidate()
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
    }
    
    
    // MARK: Location Manager Delegate
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
        sendPauseMessageToWatch()
        pauseHike()
        let shouldSound = UserSavedSettings().pauseButtonSound
        print(shouldSound)
        if shouldSound {
            playSound()
        }
    }
    
    @IBAction func holdToEndButtonPressed(_ sender: UIButton) {
        sendEndMessageToWatch()
        endHike()
    }
    
    @IBAction func resumeButtonPressed(_ sender: UIButton) {
        sendResumeMessageToWatch()
        resumeHike()
    }
    
    @IBAction func tappedOnMapView(_ sender: UITapGestureRecognizer) {
        let animationDuration = 0.5
        if !statsHidden {
            mapView.userLocationVerticalAlignment = MGLAnnotationVerticalAlignment.center
            UIView.animate(withDuration: animationDuration) { [unowned self] in
                
                self.hikeStatsDisplay.alpha = 0
                self.gradImageView.alpha = 0
                self.statsHidden = true
            }
        } else {
            mapView.userLocationVerticalAlignment = MGLAnnotationVerticalAlignment.top
            UIView.animate(withDuration: animationDuration) { [unowned self] in
                self.hikeStatsDisplay.alpha = 1
                self.gradImageView.alpha = 1
                self.statsHidden = false
            }
        }
    }
    
    // MARK: Hike Lifecycle
    
    fileprivate func startHike() {
        hikeWorkout.startDate = Date()
        startTimer()
        checkForWatchConnection()
        startHikeUISettings()
        sendStartMessageToWatch()


//        startPedometerAndUpdatePace()

    }
    
     fileprivate func resumeHike() {
        startHikeUISettings()
        paused = false
        hikeWorkout.paused = false
        let resumeTime = Date()
        hikeWorkout.resumeHike(time: resumeTime)
    }
    
    fileprivate func pauseHike() {
        pauseOrStopHikeUISettings()
        paused = true
        hikeWorkout.paused = true
        let pauseTime = Date()
        hikeWorkout.pauseHike(time: pauseTime)

    }
    

    
    fileprivate func endHike() {
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
        hikeWorkout.endDate = Date()
        openHikeFinishedVC()
    }
    
    
    
    // MARK: Timer Functions
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [unowned self] _ in
            self.eachSecond()
        }
    }
    
    private func eachSecond() {
        updateDisplay()
        sendCaloriesToWatch()
        convertDateAndSendToWatch()
        sendDistanceToWatch()
        
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
        if let sunsetTime = hikeWorkout.sunsetTime {
            newDisplay.sunsetTime = sunsetTime
        }
        if !paused {
            hikeStatsDisplay.setDisplay(with: newDisplay)
        }

    }
    private func calculateSunsetTime() {
        
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
            let destinationNav = segue.destination as! UINavigationController
            let destinationVC = destinationNav.topViewController as! HikeFinishedTableViewController
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


    // MARK: Sound
    func playSound() {
        guard let url = Bundle.main.url(forResource: "PauseNoise", withExtension: "wav") else { return }

        do {

            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)



            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)


            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}




extension HikeInProgressViewController: WCSessionDelegate {
    // MARK: Watch Connectivity Delegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Watch session became inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("Watch session deactivated")
    }
    
    // MARK: Watch Connection Functions
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
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
            healthStore.startWatchApp(with: configuration) { (success, _) in
                if success {
                    print("should be opening watch app with workout configuration")
                }
            }
        }
    }
    
    private func convertDateAndSendToWatch() {
        let dateHelper = DateHelper()
        let currentDuration = hikeWorkout.durationInSeconds
        let adjustDurationToDealWithWatchStartupTime = currentDuration
        let stringDuration = dateHelper.convertDurationToStringDate(adjustDurationToDealWithWatchStartupTime)
        watchConnection.sendMessage([watchMessages.startDate: stringDuration], replyHandler: nil) { error in
//            print(error)
        }
    }
    
    private func sendDistanceToWatch() {
        let distance = hikeWorkout.totalDistanceInMeters
        let stringDistance = distance.getDisplayString
        watchConnection.sendMessage([watchMessages.distance: stringDistance], replyHandler: nil) { error in
//            print(error)
        }
    }
    
    private func sendCaloriesToWatch() {
        let caloriesBurned = Int(hikeWorkout.caloriesBurned)
        let stringCalories = String("\(caloriesBurned) kcl")
        watchConnection.sendMessage([watchMessages.calories: stringCalories], replyHandler: nil) { error in
//            print(error)
        }
    }
    
    // MARK: Send Lifecycle messages to watch

    fileprivate func sendStartMessageToWatch() {
        let startMessage = watchMessages.startHike
        watchConnection.sendMessage([startMessage: true], replyHandler: nil) { (error) in
//            print(error)
        }
    }
    fileprivate func sendPauseMessageToWatch(){
        let pauseMessage = watchMessages.pauseHike
        watchConnection.sendMessage([pauseMessage: true], replyHandler: nil) { (error) in
//            print(error)
        }
    }
    
    fileprivate func sendResumeMessageToWatch(){
        let resumeMessage = watchMessages.resumeHike
        watchConnection.sendMessage([resumeMessage: true], replyHandler: nil) { (error) in
//            print(error)
        }
    }
    
    fileprivate func sendEndMessageToWatch() {
        let endMessage = watchMessages.endHike
        watchConnection.sendMessage([endMessage: true], replyHandler: nil) { (error) in
//            print(error)
        }
    }
}
