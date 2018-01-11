//
//  HikeHistoryDetailTableViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 12/26/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit
import Mapbox
import Firebase

class HikeHistoryDetailTableViewController: UITableViewController, UITextFieldDelegate {
    // MARK: Enums
    
    // MARK: Constants
//    let statsToDisplay: [Stats] = [.duration, .distance, . elevationGain, .calories, .avgPace, .avgHeartRate, .minAltitude, .maxAltitude, .timeUphill, .timeDownhill]
    
    
    // MARK: Variables
    var mapBoxView: MGLMapView!
    
    // MARK: Outlets
    

    @IBOutlet weak var mapContainerView: UIView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var discardButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var statContainerView: UIView!
    
    // MARK: Weak Vars
    
    
    // MARK: Public Variables
    var hikeWorkout: DecodedHike?
    
    var unsavedHikeIncoming = false
    
    // MARK: Private Variables
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMapBoxView()
        mapBoxDrawHistoryLine()
        nameTextField.delegate = self
        updateDisplay()
        nameTextField.text = hikeWorkout?.hikeName

 

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setUpMapBoxView()
        mapBoxDrawHistoryLine()
        updateDisplay()
        


    }
    // MARK: IBActions

    // MARK: Stat Display
    
    func updateDisplay() {
        let finishedHikeDisplayConverter = HikeDisplayStrings()
        let finishedDisplay = finishedHikeDisplayConverter.getFinishedDisplayStrings(from: hikeWorkout!)
        let childVC = childViewControllers.last as! HikeHistoryStatContainerViewController
        childVC.updateDisplay(hike: finishedDisplay)
        
    }
    
    func setUpMapBoxView() {
        let url = URL(string: "mapbox://styles/mapbox/outdoors-v10")
        mapBoxView = MGLMapView(frame: mapContainerView.bounds, styleURL: url)
        mapBoxView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapContainerView.addSubview(mapBoxView)
    }

    func mapBoxDrawHistoryLine() {
        guard let hikeWorkout = hikeWorkout else { return }
        if hikeWorkout.coordinates.count > 2 {
            mapBoxView.drawLineOf(hikeWorkout.coordinates)
            let centerCoordinate = hikeWorkout.storedLocations.calculateCenterCoordinate()
            
            let camera = MGLMapCamera(lookingAtCenter: centerCoordinate, fromDistance: 5000, pitch: 0.0, heading: 0.0)
            mapBoxView.camera = camera
//            let bounds = MGLCoordinateBounds(sw: hikeWorkout.coordinates.first!, ne: hikeWorkout.coordinates.last!)
//            mapBoxView.setVisibleCoordinateBounds(bounds, animated: true)
        }
        
    }
    
    // MARK: Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if unsavedHikeIncoming {
            return 3
        } else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.row == 1 {
            performSegue(withIdentifier: "Chart View", sender: self)
        }
    }

    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Chart View" {
            let destinationVC = segue.destination as! HikeChartsViewController
            destinationVC.hikeWorkout = hikeWorkout
        }
    }
    
    func dismissToMainScreen() {
        presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }

    
    // MARK: Name Text Field
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let hike = hikeWorkout else { return true }
        textField.resignFirstResponder()
        let textFieldEnteredText = textField.text
        if textFieldEnteredText != ""  && textFieldEnteredText != nil {
            hike.hikeName = textFieldEnteredText!
            let startDateKey = hike.startDate?.displayString
            let databaseRef = Database.database().reference()
            if let userUID = Auth.auth().currentUser?.uid {
                let newNameDict = [FirebaseDict().hikeNameKey: hike.hikeName]
                databaseRef.child(userUID).child(FirebaseDatabase().childKey).child(startDateKey!).updateChildValues(newNameDict)
            } else {
                print("problem getting userUID")
            }
        }
        return true
    }
    

    

    
    
    
}
