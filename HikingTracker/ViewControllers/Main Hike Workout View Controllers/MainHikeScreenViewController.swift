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

    // MARK: Enums
    
    // MARK: Constants
    let locationManager = LocationManager.shared

    // MARK: Variables
    
    // MARK: Outlets
    @IBOutlet weak var latLongLabel: UILabel!
    
//    @IBOutlet weak var mapBoxMapView: MGLMapView!
    
    // MARK: Weak Vars
    
    // MARK: Public Variables
    
    // MARK: Private Variables
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //If location services are turned off, display a notification to turn them back on in the settings
        //TODO: Fix alert. Mabye don't allow to dismiss alert unless notification services are turned on?
        if CLLocationManager.authorizationStatus() == .notDetermined || CLLocationManager.authorizationStatus() == .denied {
//            presentAlert(title: "Location can't be found!", message: "Turn on location services in settings", view: self)
        }
    }

    
    // MARK: IBActions
    @IBAction func startHikeButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "StartHikeButtonPressed", sender: self)
    }
    
    // MARK: Instance Methods
    
    private func updateLatLongLabel(location:CLLocation?){
        guard let location = location else {return}
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let combinedString = "Lat:\(String(describing: latitude)) Long:\(String(describing: longitude))"
        latLongLabel.text = combinedString
    }
    
    fileprivate func createMapBoxView() {
        //Setup Map View
        let url = URL(string: "mapbox://styles/mapbox/outdoors-v10")
        let mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        let userLocation = mapView.userLocation?.location
        updateLatLongLabel(location: userLocation)
        view.addSubview(mapView)
        view.sendSubview(toBack: mapView)
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

}

