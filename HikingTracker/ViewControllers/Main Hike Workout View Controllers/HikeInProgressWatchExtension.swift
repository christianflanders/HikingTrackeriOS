//
//  HikeInProgressWatchExtension.swift
//  HikingTracker
//
//  Created by Christian Flanders on 1/3/18.
//  Copyright © 2018 Christian Flanders. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import HealthKit
//
//extension HikeInProgressViewController {
//    // MARK: Watch Connectivity Delegate
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//
//    }
//
//    func sessionDidBecomeInactive(_ session: WCSession) {
//        print("Watch session became inactive")
//    }
//
//    func sessionDidDeactivate(_ session: WCSession) {
//        print("Watch session deactivated")
//    }
//
//    // MARK: Watch Connection Functions
//
//    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
//        print("Message recieved from watch!")
//
//        if let pauseMessage = message[watchMessages.pauseHike] as? Bool {
//            if pauseMessage {
//                DispatchQueue.main.async {
//                    self.pauseHike()
//                }
//            }
//        }
//        if let resumeMessage = message[watchMessages.resumeHike] as? Bool {
//            if resumeMessage {
//                DispatchQueue.main.async {
//                    self.resumeHike()
//                }
//            }
//        }
//        if let endMessage = message[watchMessages.endHike] as? Bool {
//            if endMessage {
//                DispatchQueue.main.async {
//                    self.endHike()
//                }
//            }
//        }
//
//    }
//
//    private func checkForWatchConnection() {
//        if WCSession.isSupported() {
//            watchConnection.delegate = self
//            watchConnection.activate()
//            if watchConnection.activationState != .activated {
//                watchConnection.activate()
//            }
//            let configuration = HKWorkoutConfiguration()
//            configuration.activityType = .hiking
//            configuration.locationType = .outdoor
//            let healthStore = HKHealthStore()
//            healthStore.startWatchApp(with: configuration) { (success, _) in
//                if success {
//                    print("should be opening watch app with workout configuration")
//                }
//            }
//        }
//    }
//
//    private func convertDateAndSendToWatch(date: Date) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US")
//        dateFormatter.dateStyle = .long
//        dateFormatter.timeStyle = .full
//
//        let stringDateToSendToWatch = dateFormatter.string(from: date)
//        watchConnection.sendMessage([watchMessages.startDate: stringDateToSendToWatch], replyHandler: nil) { error in
//            print(error)
//        }
//    }
//
//    private func sendDistanceToWatch() {
//        guard let distance = hikeWorkout.totalDistanceTraveled else {return}
//        let stringDistance =  String(Int(distance))
//        let stringToSend = "\(stringDistance) meters"
//        watchConnection.sendMessage([watchMessages.distance: stringToSend], replyHandler: nil) { error in
//            print(error)
//        }
//    }
//
//    private func sendCaloriesToWatch() {
//        let caloriesBurned = Int(hikeWorkout.totalCaloriesBurned)
//        let stringCalories = String(caloriesBurned)
//        watchConnection.sendMessage([watchMessages.calories: stringCalories], replyHandler: nil) { error in
//            print(error)
//        }
//    }
//}

