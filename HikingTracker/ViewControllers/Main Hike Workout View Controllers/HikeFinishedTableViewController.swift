//
//  HikeFinishedTableViewController.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/5/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import UIKit
import Mapbox

class HikeFinishedTableViewController: UITableViewController , UITextFieldDelegate{
    // MARK: Enums
    
    // MARK: Constants
    let statsToDisplay: [Stats] = [.duration, .distance, . elevationGain, .calories, .avgPace, .avgHeartRate, .minAltitude, .maxAltitude, .timeUphill, .timeDownhill]
    
    
    // MARK: Variables
    var mapBoxView: MGLMapView!
    
    // MARK: Outlets
    
    
    @IBOutlet weak var mapContainerView: UIView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var discardButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var hikeHistoryContainer: UIView!
    
    // MARK: Weak Vars
    
    
    // MARK: Public Variables
    var hikeWorkout = HikeWorkoutHappening()
    
    
    
    // MARK: Private Variables
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMapBoxView()
        mapBoxDrawHistoryLine()
        nameTextField.delegate = self
        print("VC Loaded")
        let finishedHikeDisplayConverter = ConvertHikeToFinishedDisplayStrings()
        let finishedDisplay = finishedHikeDisplayConverter.getFinishedDisplayStrings(from: hikeWorkout)
        let childVC = childViewControllers.last as! HikeHistoryStatContainerViewController
        childVC.updateDisplay(hike: finishedDisplay)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)



    }
    // MARK: IBActions
    
    // MARK: Stat Display
    
    func updateDisplay() {
   
        

    }
    
    func setUpMapBoxView() {
        let url = URL(string: "mapbox://styles/mapbox/outdoors-v10")
        mapBoxView = MGLMapView(frame: mapContainerView.bounds, styleURL: url)
        mapBoxView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapContainerView.addSubview(mapBoxView)
    }
    
    func mapBoxDrawHistoryLine() {
        if hikeWorkout.coordinates.count > 2 {
            mapBoxView.drawLineOf(hikeWorkout.coordinates)
            let centerCoordinate = hikeWorkout.storedLocations.calculateCenterCoordinate()
            
            let camera = MGLMapCamera(lookingAtCenter: centerCoordinate, fromDistance: 5000, pitch: 0.0, heading: 0.0)
            mapBoxView.camera = camera
        }
        
    }
    
    // MARK: Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
            return 3
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
//            destinationVC.hikeWorkout = hikeWorkout
        }
    }
    
    func dismissToMainScreen() {
        presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    
    // MARK: Name Text Field
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let textFieldEnteredText = textField.text
        if textFieldEnteredText != "" {
//            hikeWorkout.hikeName = textFieldEnteredText
        }
        return true
    }
    
    // MARK: Hike Saving
    let saveHike = SaveHike()
    
    @IBAction func saveHikeButtonPressed(_ sender: UIButton) {
        let saveToFirebaseHelper = SaveHikeToFirebase()
        let convertedHike = saveToFirebaseHelper.convertAndUploadHikeToFirebase(hikeWorkout, name: "Test Upload")
        print("Uploaded!")
        dismissToMainScreen()
        
    }
    
    @IBAction func discardHikeButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure?", message: "Your workout will not be saved", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .destructive) { (action) in
            self.dismissToMainScreen()
        }
        let dontDeleteAction = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)
        alert.addAction(okayAction)
        alert.addAction(dontDeleteAction)
        present(alert, animated: true, completion: nil)
        
        
    }
    
}
