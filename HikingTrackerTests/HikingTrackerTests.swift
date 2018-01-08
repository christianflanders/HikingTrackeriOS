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
    
    
    let fileOne = "GPX 1 For Unit Testing"
    let fileTwo = "RK_gpx _2015-01-16_0544"
    let fileThree = "HikeTest"
    let timerDuration = 1
    
    
    let fileOneDistanceInMeters = 7143
    let fileOneDurationString = "01:54:30"
    let fileOneDurationDouble: Double = 3600 + 3240 + 30
    let fileOneUphillDurationAsString = "00:37:52"
    let fileOneDownhillDurationAsString = "00:35:12"
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    func testHikeDistanceCalculation() {
//        let testWorkout = createFakeHikeWorkout()
////        let totalDistanceTraveled = testWorkout.totalDistanceTraveled
////        print(totalDistanceTraveled)
//        let totalDistanceTraveledInt = Int(totalDistanceTraveled!)
//        XCTAssertEqual(totalDistanceTraveledInt, fileOneDistanceInMeters)
    }
    
    
    func testHikeDurationCalculation() {
//        let testWorkout = createFakeHikeWorkout()
////        let calculatedDurationDouble = testWorkout.calculatedDuration
////        let calculatedDurationString = testWorkout.durationAsString
//        XCTAssertEqual(calculatedDurationDouble, fileOneDurationDouble)
//        XCTAssertEqual(calculatedDurationString, fileOneDurationString)
    }
    
    func testMetersAsMiles() {
        
    }
    
    func metersDisplayStringTest() {
        
    }
    
    func testHikeTimeUpAndDownhill() {
        
    }
    
//    func testHikeWithFakeDataForCaloriesBurned() {
//        if let fakeData = createFakeData(from: fileOne) {
//            let hikeWorkoutToTest = HikeWorkout()
//            for i in fakeData {
//                hikeWorkoutToTest.lastLocation = i
//            }
//            let totalTimeUphill = hikeWorkoutToTest.timeTraveldUpHill
//            let totalTimeTraveledDownhill = hikeWorkoutToTest.timeTraveledDownHill
//            print(hikeWorkoutToTest.totalCaloriesBurned)
//            XCTAssertTrue(hikeWorkoutToTest.totalCaloriesBurned < 1000)
//
//        }
//    }
//
//    func testHikeWithFakeDataForDistanceTraveled() {
//        if let fakeData = createFakeData(from: fileOne) {
//            let hikeWorkoutToTest = HikeWorkout()
//            for i in fakeData {
//                hikeWorkoutToTest.lastLocation = i
//            }
//            let lowestElevation = hikeWorkoutToTest.lowestElevation
//            let highestElevation = hikeWorkoutToTest.highestElevation
//            let totalDistance = hikeWorkoutToTest.totalDistanceTraveled
//            XCTAssert(totalDistance < 4000 && totalDistance > 3800)
//            print(totalDistance)
//        }
//    }
    
    func testAddingInFakeDataFromGPXToCoreData() {
//        let store = PersistanceService.store
//        guard let fakeData = createFakeData(from: fileOne) else {
//            XCTFail()
//            return
//        }
//        let hikeWorkoutToTest = HikeWorkoutInProgress()
//        for i in fakeData {
//            hikeWorkoutToTest.lastLocation = i
//        }
//        let startDate = fakeData.first?.timestamp
//        hikeWorkoutToTest.startDate = startDate
//        //        let endDate = fakeData.last?.timestamp
//        //        let caloriesBurned = hikeWorkoutToTest.totalCaloriesBurned
//        //        let calorieUnit = HKUnit(from: .kilocalorie)
//        //        let hkCalories = HKQuantity(unit: calorieUnit, doubleValue: caloriesBurned)
//        //        let distance = hikeWorkoutToTest.totalDistanceTraveled
//        //        let distanceUnit = HKUnit(from: .meter)
//        //        let hkDistance = HKQuantity(unit: distanceUnit, doubleValue: Double(distance!))
//
//        store.storeHikeWorkout(hikeWorkout: hikeWorkoutToTest, name: "Unit test input")
//
//        store.fetchWorkouts()
//        print(store.fetchedWorkouts.count)
//        //        let shouldBeTheWorkoutStored = store.fetchedWorkouts.first
//        //        XCTAssert(shouldBeTheWorkoutStored?.startDate == startDate)
//        //        XCTAssert(shouldBeTheWorkoutStored?.storedLocations.count == fakeData.count)
//        //        XCTAssert(shouldBeTheWorkoutStored?.storedLocations.count == fakeData.count)
//        //        XCTAssert(shouldBeTheWorkoutStored?.duration == hikeWorkoutToTest.duration)
//        //        let testVC = HikeHistoryViewController() as! HikeHistoryViewController
//        //        let rowsInTable = testVC.hikeHistoryTableView.numberOfRows(inSection: 0)
//        //        XCTAssert(store.fetchedWorkouts.count == rowsInTable)
        
        
    }
    
    func createFakeData(from fileName: String) -> [CLLocation]? {
        if let parser = GpxParser(file: fileName) {
            let (_, coordinates): (String, [CLLocation]) = parser.parse()
            print(coordinates.count)
            return coordinates
        } else {
            return nil
        }
    }
    
    func createFakeHikeWorkout() -> HikeInProgress {
        let hikeWorkoutToTest = HikeInProgress()
        if let fakeData = createFakeData(from: fileOne) {
            for i in fakeData {
                hikeWorkoutToTest.addNewLocation(i)
            }
        }
        print(hikeWorkoutToTest.storedLocations.count)
        let startDate = hikeWorkoutToTest.storedLocations.first?.timestamp
        let lastLocation = hikeWorkoutToTest.storedLocations.count - 1
        let endDate = hikeWorkoutToTest.storedLocations[lastLocation].timestamp
        hikeWorkoutToTest.endDate = endDate
        hikeWorkoutToTest.startDate = startDate
        hikeWorkoutToTest.totalPausedTime = 0
        return hikeWorkoutToTest
    }
    
    func testHighestElevationCalculation() {
        let hikeToTest = createFakeHikeWorkout()
        let goalHighestElevation = 767.2
        let testWorkoutHighestElevation = hikeToTest.highestAltitudeInMeters
        XCTAssertEqual(goalHighestElevation, testWorkoutHighestElevation)
    }
    
    func testLowestElevationCalculation() {
        let hikeToTest = createFakeHikeWorkout()
        let goalLowestElevation = 462.0
        let testWorkoutLowestElevation = hikeToTest.lowestAltitudeInMeters
        XCTAssertEqual(goalLowestElevation, testWorkoutLowestElevation)
        
    }
    
    func testTimeTraveledEquality() {
        // Since the time travled up or down hill durations are only added too when the workout isnt paused,
        // Adding them together should equal the total time, which figures out the total time of the workout subtracting paused seconds
        let hikeToTest = createFakeHikeWorkout()
        let addedTogetherTime = hikeToTest.timeTraveldUpHill + hikeToTest.timeTraveledDownHill
        let totalTime = hikeToTest.totalTime
        XCTAssertEqual(addedTogetherTime, totalTime)
        
    }
    
    func testHikeUploadToFirebase() {
        let hikeToTest = createFakeHikeWorkout()
        let saveHelper = SaveHikeToFirebase()
        saveHelper.convertAndUploadHikeToFirebase(hikeToTest, name: "Unit Test Upload")
    }
    
    func testUnitConversions() {
        let unitConverter = UnitConversions()
        let kilograms: [Double] = [1, 2, 5, 20, 600, 661, 100, 10000, 12345, 848384859]
        let pounds = [2.20462,4.40925,11.0231, 44.0925,1322.77,1457.26, 220.462,22046.23, 27216.066,1870368452.19  ]
        for i in 0..<kilograms.count {
            let kiloToPounds = unitConverter.convertKilogramsToPounds(grams: kilograms[i])
            XCTAssert(Int(pounds[i]) == Int(kiloToPounds))
        }
        let centimeters: [Double] = [ 5, 20, 600, 661, 100, 10000, 12345]
        let inches = [ 1.9685, 7.87402, 236.22, 260.236,39.3701,3937.008, 4860.2362 ]
        for i in 0..<centimeters.count {
            let cmToInches = unitConverter.convertCMToInches(cm: centimeters[i])
            print(cmToInches)
            XCTAssert(Int(inches[i]) == Int(cmToInches))
        }
    }
    
    func testDisplayStringData() {
        
    }
    
    func addingWorkoutToHealthKit() {
        
    }
}
