//
//  HikingTrackerTests.swift
//  HikingTrackerTests
//
//  Created by Christian Flanders on 12/4/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import XCTest
import CoreLocation
import CoreData
import HealthKit
@testable import HikingTracker

class HikingTrackerTests: XCTestCase {
    
    
    let fileOne = "RK_gpx _2017-12-20_1333-xc"
    let fileTwo = "RK_gpx _2015-01-16_0544"
    let timerDuration = 1
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testDurationCalculationg() {
//        let testWorkout = HikeWorkout()
//        let secondsToTest = [60, 120, 5400,9213]
//        let expectedOutputs = ["00:01:00", "00:02:00", "01:30:00", "02:33:33"]
//        for i in 0..<secondsToTest.count{
//            testWorkout.seconds = secondsToTest[i]
//            let duration = testWorkout.durationAsString
//            XCTAssertEqual(duration, expectedOutputs[i])
//        }
//    }
    
    func testHikeWithFakeDataForCaloriesBurned() {
        if let fakeData = createFakeData(from: fileOne) {
            let hikeWorkoutToTest = HikeWorkout()
            for i in fakeData {
                hikeWorkoutToTest.lastLocation = i
            }
            let totalTimeUphill = hikeWorkoutToTest.timeTraveldUpHill
            let totalTimeTraveledDownhill = hikeWorkoutToTest.timeTraveledDownHill
            print(hikeWorkoutToTest.totalCaloriesBurned)
            XCTAssertTrue(hikeWorkoutToTest.totalCaloriesBurned < 1000)
            
        }
    }
    
    func testHikeWithFakeDataForDistanceTraveled() {
        if let fakeData = createFakeData(from: fileOne) {
            let hikeWorkoutToTest = HikeWorkout()
            for i in fakeData {
                hikeWorkoutToTest.lastLocation = i
            }
            let lowestElevation = hikeWorkoutToTest.lowestElevation
            let highestElevation = hikeWorkoutToTest.highestElevation
            if let totalDistance = hikeWorkoutToTest.totalDistanceTraveled {
                XCTAssert(totalDistance < 4000 && totalDistance > 3800)

                print(totalDistance)
            }
        }
    }
    
    func testAddingInFakeDataFromGPXToCoreData() {
        let store = PersistanceService.store
        guard let fakeData = createFakeData(from: fileOne) else {
            XCTFail()
            return
        }
        let hikeWorkoutToTest = HikeWorkout()
        for i in fakeData {
            hikeWorkoutToTest.lastLocation = i
        }
        let startDate = fakeData.first?.timestamp
        hikeWorkoutToTest.startDate = startDate
        let endDate = fakeData.last?.timestamp
        let caloriesBurned = hikeWorkoutToTest.totalCaloriesBurned
        let calorieUnit = HKUnit(from: .kilocalorie)
        let hkCalories = HKQuantity(unit: calorieUnit, doubleValue: caloriesBurned)
        let distance = hikeWorkoutToTest.totalDistanceTraveled
        let distanceUnit = HKUnit(from: .meter)
        let hkDistance = HKQuantity(unit: distanceUnit, doubleValue: Double(distance!))
        
        store.storeHikeWorkout(hikeWorkout: hikeWorkoutToTest, name: fileOne)
//        let workout = HKWorkout(activityType: .hiking, start: startDate!, end: endDate!, duration: (endDate?.timeIntervalSince(startDate!))!, totalEnergyBurned: hkCalories, totalDistance: hkDistance, device: HKDevice.local(), metadata: nil)
//        let healthStore = HKHealthStore()
//        healthStore.save(workout) { (success, error) in
//            if error == nil {
//                print("success saving to health kit store!")
//            }
//
//        }
        store.fetchWorkouts()
        print(store.fetchedWorkouts.count)
        let shouldBeTheWorkoutStored = store.fetchedWorkouts.last
        XCTAssert(shouldBeTheWorkoutStored?.startDate == startDate)
        XCTAssert(shouldBeTheWorkoutStored?.storedLocations.count == fakeData.count)
        XCTAssert(shouldBeTheWorkoutStored?.storedLocations.count == fakeData.count)
        XCTAssert(shouldBeTheWorkoutStored?.duration == hikeWorkoutToTest.duration)
//        let testVC = HikeHistoryViewController() as! HikeHistoryViewController
//        let rowsInTable = testVC.hikeHistoryTableView.numberOfRows(inSection: 0)
//        XCTAssert(store.fetchedWorkouts.count == rowsInTable)


    }
    
    func createFakeData(from fileName: String) -> [CLLocation]? {
        if let parser = GpxParser(file: fileName) {
            let (_, coordinates): (String, [CLLocation]) = parser.parse()
            return coordinates
        } else {
            return nil
        }
    }
    
    
//    func testSavingUserInformation() {
//        let userTestNames = ["Christian", "Cali", "Test Name", "iNiNlSeD"]
//        let userTestMetrics : [DisplayUnits] = [.freedomUnits, .metric, .freedomUnits, .metric]
//        let genderTest = ["male", "female", "Male", "Female"]
//        let heightTests = []
//        let testUser = User()
//
//    }
    
    func testUnitConversions() {
        
    }
    
    func testDisplayStringData() {
        
    }
    
    func addingWorkoutToHealthKit() {
        
    }
}
