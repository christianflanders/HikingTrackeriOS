//
//  MainHikeScreenViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/4/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import HealthKit

class MainHikeScreenViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {

    //MARK: Enums
    

    
    //MARK: Constants
    let locationManager = LocationManager.shared
    //MARK: Variables
    
    //MARK: Outlets
    @IBOutlet weak var mainMapView: MKMapView!
    
    //MARK: Weak Vars
    
    //MARK: Public Variables
    
    //MARK: Private Variables
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup Map View
        mainMapView.delegate = self
        mainMapView.showsUserLocation = true
        mainMapView.mapType = .satellite
        mainMapView.setUserTrackingMode(.follow ,animated: true)
        //Setup Location Manager
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        //HealthKitSetup
        HealthKitAuthroizationSetup.authorizeHealthKit { (authorized, error) in
            
            guard authorized else {
                print("Health Kit Authorization failed!")
                return
            }
            
            print("HealthKit successfully authorized")
            
        }
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBActions
    @IBAction func startHikeButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "StartHikeButtonPressed", sender: self)
    }
    
    //MARK: Instance Methods
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    // MARK: Health Kit Authorization


}


