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

class MainHikeScreenViewController: UIViewController{

    //MARK: Enums
    

    
    //MARK: Constants
    let locationManager = LocationManager.shared
    //MARK: Variables
    
    //MARK: Outlets
    
//    @IBOutlet weak var mapBoxMapView: MGLMapView!
    
    //MARK: Weak Vars
    
    //MARK: Public Variables
    
    //MARK: Private Variables
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup Location Manager
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.startUpdatingLocation()
        }
        //HealthKitSetup
        HealthKitAuthroizationSetup.authorizeHealthKit { (authorized, error) in
            
            guard authorized else {
                print("Health Kit Authorization failed!")
                return
            }
            
            print("HealthKit successfully authorized")
            
        }
        //Setup Map View
        let url = URL(string: "mapbox://styles/mapbox/outdoors-v10")
        let mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        view.addSubview(mapView)
        view.sendSubview(toBack: mapView)


    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //TODO: Add in notification that if location services are turned off how to turn them back on.
        if !CLLocationManager.locationServicesEnabled() {
            presentAlert(title: "Location can't be found!", message: "Turn on location services in settings", view: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
//        locationManager.stopUpdatingLocation()
    }
    
    //MARK: IBActions
    @IBAction func startHikeButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "StartHikeButtonPressed", sender: self)
    }
    
    //MARK: Instance Methods
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StartHikeButtonPressed" {
            let destination = segue.destination as! HikeInProgressViewController
            if !destination.shouldStartHike {
                destination.shouldStartHike = !destination.shouldStartHike
            }
        }
     }
    
    
    // MARK: Health Kit Authorization


}


