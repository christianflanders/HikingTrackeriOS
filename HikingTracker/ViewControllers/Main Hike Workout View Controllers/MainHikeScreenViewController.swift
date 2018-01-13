//
//  MainHikeScreenViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/4/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit
import CoreLocation
import HealthKit
import Mapbox
import Firebase
import FirebaseAuthUI

class MainHikeScreenViewController: UIViewController, FUIAuthDelegate {


    // MARK: Enums
    
    // MARK: Constants
    let locationManager = LocationManager.shared

    // MARK: Variables
    
    // MARK: Outlets
    @IBOutlet weak var latLongLabel: UILabel!
    
    @IBOutlet weak var startHikeButton: UIButton!
    //    @IBOutlet weak var mapBoxMapView: MGLMapView!
    
    // MARK: Weak Vars
    
    // MARK: Public Variables

    // MARK: Private Variables
    private var mapView: MGLMapView!
    private var timer: Timer?
    private var authUIView: UINavigationController?
    
    // MARK: View Life Cycle

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
//        testPostToFireBase()
        startHikeButton.layer.cornerRadius = startHikeButton.frame.height / 2
        //Setup Location Manager
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()

        //HealthKitSetup
        HealthKitAuthroizationSetup.authorizeHealthKit { (authorized, error) in
            guard authorized else {
                print("Health Kit Authorization failed!")
                return
            }
            print("HealthKit successfully authorized")
        }
        createMapBoxView()
        animateUIElements()

        startHikeButton.titleLabel?.textAlignment = NSTextAlignment.center

        startHikeButton.titleLabel?.addCharacterSpacing(value:4)
    }
  
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        startTimer()
        if let currentUser = Auth.auth().currentUser {
            currentUser.getIDTokenForcingRefresh(true, completion: { (_, error) in
                if error != nil {
                    print("User deleted")
                    let authUI = FUIAuth.defaultAuthUI()
                    let authUIView = authUI?.authViewController()
                    authUI?.delegate = self
                    self.present(authUIView!, animated: true, completion: nil)
                } else {
                    print("User found go ahead")
                    let fireBaseUserEmail = Auth.auth().currentUser?.email
                    print(fireBaseUserEmail!)
                }
            })
        } else {
            print("log in")
            let authUI = FUIAuth.defaultAuthUI()
            let authUIView = authUI?.authViewController()
            authUI?.delegate = self
            present(authUIView!, animated: true, completion: nil)
        }
        if Auth.auth().currentUser == nil {

        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer?.invalidate()
    }

    
    // MARK: IBActions
    @IBAction func startHikeButtonPressed(_ sender: UIButton) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            performSegue(withIdentifier: "StartHikeButtonPressed", sender: self)
        } else {
            showLocationServicesDeniedAlert()
        }
        
    }
    
    // MARK: Instance Methods
    
    private func animateUIElements() {
        startHikeButton.alpha = 0
        latLongLabel.alpha = 0
        UIView.animate(withDuration: 1.0) {
            self.startHikeButton.alpha = 1
            self.latLongLabel.alpha = 1
        }
    }
    
    private func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location services not enabled!", message: "Enable location services in settings", preferredStyle: .alert)
        let action = UIAlertAction(title: "Open Settings", style: .default, handler: { (_) in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        })
        let laterAction = UIAlertAction(title: "Later", style: .default, handler: nil)
        
        alert.addAction(action)
        alert.addAction(laterAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func updateLatLongLabel(lat: Double, long: Double) {
        let latString = String(format: "%.5f", lat)
        let longString = String(format: "%.5f", long)

        let combinedString = "Lat:\(latString) Long:\(longString)"
        latLongLabel.text = combinedString
        timer?.invalidate()
    }
    
    fileprivate func createMapBoxView() {
        //Setup Map View
        let url = URL(string: "mapbox://styles/mapbox/outdoors-v10")
        mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow

        view.addSubview(mapView)
        view.sendSubview(toBack: mapView)
        eachSecond()

    }
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StartHikeButtonPressed" {
            let destination = segue.destination as! HikeInProgressViewController
            if !destination.shouldStartHike {
                destination.shouldStartHike = !destination.shouldStartHike
            }
        }
     }
    
    
    // MARK: Timer
    // Creating a timer so we can update the latitude and longitude display on a regular interval.
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            self.eachSecond()
        }
    }
    
    private func eachSecond() {
        let userLocation = mapView.userLocation?.location
        guard let lat = userLocation?.coordinate.latitude else {return}
        guard let long = userLocation?.coordinate.longitude else {return}
        updateLatLongLabel(lat: lat, long: long)
    }
    
    // MARK: Firebase Auth Delegate
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        authUIView?.dismiss(animated: true, completion: nil)
    }
    
    func testPostToFireBase() {

    }
    
    
    
    @IBAction func unwindToMe(segue: UIStoryboardSegue) {
        
    }

}

