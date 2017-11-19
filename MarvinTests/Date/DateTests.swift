//
//  DateTests.swift
//  MarvinTests
//
//  Created by Alessio Arsuffi on 17/11/2017.
//  Copyright © 2017 Monksoftware. All rights reserved.
//

import XCTest

class DateTests: XCTestCase {
    
    var date: Date?
    let milliseconds: Double = 1510919702673
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        date = Date(milliseconds: 1510919702673)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDateInitMilliseconds() {
        guard let date = date else {
            XCTFail("date is nil")
            return
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let day = components.day
        let month = components.month
        let year = components.year
        
        XCTAssertNotNil(day)
        XCTAssertNotNil(month)
        XCTAssertNotNil(year)
        
        XCTAssertEqual(day, 17)
        XCTAssertEqual(month, 11)
        XCTAssertEqual(year, 2017)
    }
    
    func testMillisecondsFromDate() {
        guard let date = date else {
            XCTFail("date is nil")
            return
        }
        
        let millisecondsFromDate = date.millisecondsSince1970
        XCTAssertNotNil(millisecondsFromDate)
        
        let newDate = Date(milliseconds: millisecondsFromDate)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: newDate)
        
        let day = components.day
        let month = components.month
        let year = components.year
        let hour = components.hour
        let minute = components.minute
        let seconds = components.second
        
        XCTAssertEqual(seconds, 2)
        XCTAssertEqual(hour, 12)
        XCTAssertEqual(minute, 55)
        XCTAssertEqual(day, 17)
        XCTAssertEqual(month, 11)
        XCTAssertEqual(year, 2017)
    }
    
    func testDateFormatterDefault() {
        guard let date = date else {
            XCTFail("date is nil")
            return
        }
        
        let dateString = date.string()
        XCTAssertEqual(dateString, "2017 11 17")
    }
    
    func testDateFormatterCustom() {
        guard let date = date else {
            XCTFail("date is nil")
            return
        }
        
        let dateString = date.string(dateFormat: "yyyy MM dd HH:mm:ss")
        XCTAssertEqual(dateString, "2017 11 17 12:55:02")
    }
}
