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

class MainHikeInterfaceController: WKInterfaceController, WCSessionDelegate, HKWorkoutSessionDelegate, WKExtensionDelegate {


    private let watchMessages = WatchConnectionMessages()

    let healthStore = HKHealthStore()
    let heartRateUnit = HKUnit(from: "count/min")
     var currenQuery : HKQuery?
    //Asked to start a workout, but WKExtensionDelegate <HikeTrackerWatchApp_Extension.ExtensionDelegate: 0x7b751280> doesn't implement handleWorkoutConfiguration:

    private var timer: Timer?
    private var duration = ""
    private var startDateFromPhone: Date?
    private var paused = true
    private var dateRecieved = false
    private var distanceRecieved = ""
    private var caloriesRecieved = ""
    private var session: HKWorkoutSession?
    private var stringDurationFromPhone = "-"
    
    @IBOutlet var durationLabel: WKInterfaceLabel!
    @IBOutlet var caloriesBurnedLabel: WKInterfaceLabel!
    @IBOutlet var heartRateLabel: WKInterfaceLabel!
    
    @IBOutlet var pauseButtonOutlet: WKInterfaceButton!
    @IBOutlet var distanceLabel: WKInterfaceLabel!
    @IBOutlet var endButtonOutlet: WKInterfaceButton!
    @IBOutlet var resumeButtonOutlet: WKInterfaceButton!


    @IBOutlet var hikeInProgressUIGroup: WKInterfaceGroup!
    
    @IBOutlet var needToStartHikeWorkoutGroup: WKInterfaceGroup!
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("WCSession activated on watch")
    }
    
    private let dateHelper = DateHelper()
    
    let watchConnection = WCSession.default
    
    let configuration = HKWorkoutConfiguration()
    let wkExtension = WKExtension.shared()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        authorizeHealthKit()
        startWCConnection()

        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

        guard let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else {
            print("not allowed")
            return
        }
        let dataTypes = Set(arrayLiteral: quantityType)
        healthStore.requestAuthorization(toShare: nil, read: dataTypes) { (success, error) -> Void in
            if success == false {
                print("not allowed")
            }
        }

        endWorkoutUI()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func updateDisplay(){
        durationLabel.setText(stringDurationFromPhone)
        distanceLabel.setText(distanceRecieved)
        caloriesBurnedLabel.setText(caloriesRecieved)

    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let durationFromPhone = message[watchMessages.startDate] as? String {
            stringDurationFromPhone = durationFromPhone
        }
        if let calories = message[watchMessages.calories] as? String {
            caloriesRecieved = calories
        }
        
        if let distanceFromPhone = message[watchMessages.distance] as? String {
            distanceRecieved = distanceFromPhone
        }
        if let startHikeMessage = message[watchMessages.startHike] as? Bool {
            if startHikeMessage {

            }
            
        }
        if let pauseHikeMessage = message[watchMessages.pauseHike] as? Bool {
            if pauseHikeMessage {
                pauseHike()
            }
        }
        
        if let resumeHikeMessage = message[watchMessages.resumeHike] as? Bool {
            if resumeHikeMessage {
                resumeHike()
            }
        }
        if let endHikeMessage = message[watchMessages.endHike] as? Bool {
            if endHikeMessage {
                endHike()
                endWorkoutUI()
            }
        }
    }
    
    func startWCConnection(){
        if WCSession.isSupported() {
            watchConnection.delegate = self
            watchConnection.activate()
            configuration.activityType = .hiking
            configuration.locationType = .outdoor
            wkExtension.delegate = self
        } else {
            print("WatchConnection Problem")
        }
    }

        func startHKWorkout() {
            do {
                session = try HKWorkoutSession(configuration: configuration)
                if let workoutSession = session {
                    workoutSession.delegate = self
                    healthStore.start(workoutSession)
                }

            } catch {
                fatalError("Problem starting workout session")
            }
            healthStore.start(self.session!)
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
        startWorkoutUI()
        startHKWorkout()
        startTimer()
        workoutDidStart(Date())
        print("Reicieved start message from iPhone!")
    }

    func workoutDidStart(_ date : Date) {
        if let query = createHeartRateStreamingQuery(date) {
            self.currenQuery = query
            healthStore.execute(query)
        } else {
            heartRateLabel.setText("cannot start")
        }
    }
    
    //MARK: Timer Functions
    private func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
    }
    
    private func eachSecond(){
        updateDisplay()
    }
    
    
    //MARK: Pause button
    
    fileprivate func pauseHike() {
        watchConnection.sendMessage([watchMessages.pauseHike: true], replyHandler: nil, errorHandler: nil)
        pauseButtonOutlet.setTitle("Pause")
        pauseButtonOutlet.setHidden(true)
        endButtonOutlet.setHidden(false)
        resumeButtonOutlet.setHidden(false)
        paused = true
    }
    
    fileprivate func resumeHike() {
        watchConnection.sendMessage([watchMessages.resumeHike: true], replyHandler: nil, errorHandler: nil)
        paused = false
        pauseButtonOutlet.setHidden(false)
        endButtonOutlet.setHidden(true)
        resumeButtonOutlet.setHidden(true)
    }
    
    @IBAction func pauseButtonPressed() {
        pauseHike()
    }
    @IBAction func endButtonPressed() {
        endHike()
    }
    
    @IBAction func resumeButtonPressed() {
        resumeHike()
    }
    
    private func endHike(){
        watchConnection.sendMessage([watchMessages.endHike: true], replyHandler: nil, errorHandler: nil)
        pauseButtonOutlet.setHidden(false)
        endButtonOutlet.setHidden(true)
        resumeButtonOutlet.setHidden(true)
        if let workOutSession = session {
            healthStore.end(workOutSession)
        }
         healthStore.stop(self.currenQuery!)

    }


    func startWorkoutUI() {
        needToStartHikeWorkoutGroup.setHidden(true)
        hikeInProgressUIGroup.setHidden(false)
        pauseButtonOutlet.setHidden(false)
        endButtonOutlet.setHidden(true)
        resumeButtonOutlet.setHidden(true)
    }

    func endWorkoutUI() {
        needToStartHikeWorkoutGroup.setHidden(false)
        hikeInProgressUIGroup.setHidden(true)
    }




    func createHeartRateStreamingQuery(_ workoutStartDate: Date) -> HKQuery? {


        guard let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else { return nil }
        let datePredicate = HKQuery.predicateForSamples(withStart: workoutStartDate, end: nil, options: .strictEndDate )
        //let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[datePredicate])


        let heartRateQuery = HKAnchoredObjectQuery(type: quantityType, predicate: predicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) { (query, sampleObjects, deletedObjects, newAnchor, error) -> Void in
            //guard let newAnchor = newAnchor else {return}
            //self.anchor = newAnchor
            self.updateHeartRate(sampleObjects)
        }

        heartRateQuery.updateHandler = {(query, samples, deleteObjects, newAnchor, error) -> Void in
            //self.anchor = newAnchor!
            self.updateHeartRate(samples)
        }
        return heartRateQuery
    }

    func updateHeartRate(_ samples: [HKSample]?) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else {return}

        DispatchQueue.main.async {
            guard let sample = heartRateSamples.first else{return}
            let value = sample.quantity.doubleValue(for: self.heartRateUnit)
            self.heartRateLabel.setText(String(UInt16(value)))

            // retrieve source from sample
            let name = sample.sourceRevision.source.name
//            self.updateDeviceName(name)
//            self.animateHeart()
        }
    }
    
}
