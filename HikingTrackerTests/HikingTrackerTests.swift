//
//  HikingTrackerTests.swift
//  HikingTrackerTests
//
//  Created by Christian Flanders on 12/4/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import XCTest
import CoreLocation
@testable import HikingTracker

class HikingTrackerTests: XCTestCase {
    
    
    let fileOne = "RK_gpx _2017-12-08_0830"
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
    
    func testDurationCalculationg() {
        let testWorkout = HikeWorkout()
        let secondsToTest = [60, 120, 5400,9213]
        let expectedOutputs = ["00:01:00", "00:02:00", "01:30:00", "02:33:33"]
        for i in 0..<secondsToTest.count{
            testWorkout.seconds = secondsToTest[i]
            let duration = testWorkout.duration
            XCTAssertEqual(duration, expectedOutputs[i])
        }
    }
    
    
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
    
    
    
    
    func createFakeData(from fileName: String) -> [CLLocation]? {
        if let parser = GpxParser(file: fileName) {
            let (_, coordinates): (String, [CLLocation]) = parser.parse()
            return coordinates
        } else {
            return nil
        }
        
    }
}
