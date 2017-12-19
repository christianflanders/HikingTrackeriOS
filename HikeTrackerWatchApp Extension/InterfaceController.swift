//
//  InterfaceController.swift
//  HikeTrackerWatchApp Extension
//
//  Created by Christian Flanders on 12/4/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import HealthKit

class InterfaceController: WKInterfaceController, WCSessionDelegate, HKWorkoutSessionDelegate, WKExtensionDelegate {

    
    private var timer: Timer?
    private var duration = ""
    private var startDateFromPhone: Date?
    private var paused = true
    private var dateRecieved = false
    
    @IBOutlet var durationLabel: WKInterfaceLabel!
    @IBOutlet var caloriesBurnedLabel: WKInterfaceLabel!
    
    @IBOutlet var distanceLabel: WKInterfaceLabel!
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("WCSession activated on watch")
    }
    
    private let dateHelper = DateHelper()
    
    let watchConnection = WCSession.default
    
    let configuration = HKWorkoutConfiguration()
    let healthStore = HKHealthStore()
    let wkExtension = WKExtension.shared()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        authorizeHealthKit()
        startTimer()
        if WCSession.isSupported() {
            watchConnection.delegate = self
            watchConnection.activate()
            configuration.activityType = .hiking
            configuration.locationType = .outdoor
            wkExtension.delegate = self
            do {
                let session = try HKWorkoutSession(configuration: configuration)
                session.delegate = self
                healthStore.start(session)
            } catch {
                fatalError("Problem starting workout session")
            }
        } else {
            print("Phone not avaliable! Starting workout on watch")
        }

        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func updateDisplay(){
        guard let startDate = startDateFromPhone else {return}
        let currentDate = Date()
        let duration = currentDate.timeIntervalSince(startDate)
        let stringDuration = dateHelper.convertDurationToStringDate(duration)
        durationLabel.setText(stringDuration)

    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("message from phone recieved")
        if dateRecieved == false {
            let dateStringFromPhone = message["startDate"] as! String
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .full
            let returnDate = dateFormatter.date(from: dateStringFromPhone)
            paused = false
            guard let startDateFromPhoneRecieved = returnDate else {fatalError("problem converting date from phone")}
            startDateFromPhone = startDateFromPhoneRecieved
            dateRecieved = true
        }

    }
    
    
    
    func authorizeHealthKit() {
        HealthKitAuthroizationSetup.authorizeHealthKit { (authorized, error) in
            
            guard authorized else {
                print("Health Kit Authorization failed!")
                return
            }
            
            print("HealthKit successfully authorized")
            
        }
    }
    

    //MARK: Workout Session Delegate
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("Workout State Changed")
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("Workout session did fail with error \(error)")
    }
    
    
    
    //MARK: WKSession Delegate
    func handle(_ workoutConfiguration: HKWorkoutConfiguration) {
        print("Reicieved start message from iPhone!")
    }

    
    //MARK: Timer Functions
    private func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
    }
    
    private func eachSecond(){
        if !paused {
            updateDisplay()
        }
    }
    
    
    
    
    
}
