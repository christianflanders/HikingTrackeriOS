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

class HikeInProgressViewController: UIViewController {
    
    //MARK: Enums
    
    //MARK: Constants
    private let locationManager = LocationManager.shared
    private let altimeter = Altimeter.shared
    //MARK: Variables
    
    //MARK: Outlets
    @IBOutlet weak var elevationDisplayLabel: UILabel!
    @IBOutlet weak var distanceDisplayLabel: UILabel!
    @IBOutlet weak var durationDisplayLabel: UILabel!
    @IBOutlet weak var caloriesDisplayLabel: UILabel!
    
    
    //MARK: Weak Vars
    
    //MARK: Public Variables
    var shouldStartHike = false
    
    //MARK: Private Variables
    private var seconds = 0
    private var timer : Timer?
    private var paused = false
    private var currentAltitude: NSNumber?
    
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if shouldStartHike {
            startHike()
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
    }
    
    //MARK: Instance Methods
    private func startHike(){
        startTimer()
        startAltimeter()
    }
    
    private func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
            
        }
    }
    
    private func eachSecond(){
        if !paused {
            seconds += 1
            updateDisplay()
        }
    }
    
    private func updateDisplay(){
        durationDisplayLabel.text = String(seconds)
        if currentAltitude != nil {
            let stringAltitude = String(describing: currentAltitude!.doubleValue)
            elevationDisplayLabel.text = stringAltitude
        }
    }
    
    private func startAltimeter(){
        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main) { data, error in
                if error == nil {
                    self.currentAltitude = data?.relativeAltitude
                } else {
                    print("Error with altimeter!")
                    return
                }
                
            }
        } else {
            print("Altimeter not avalible")
        }
    }
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    
}
