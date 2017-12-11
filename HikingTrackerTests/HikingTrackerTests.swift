//
//  HikingTrackerTests.swift
//  HikingTrackerTests
//
//  Created by Christian Flanders on 12/4/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import XCTest
@testable import HikingTracker

class HikingTrackerTests: XCTestCase {
    
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
    
    
}
