//
//  MyntraTestTests.swift
//  MyntraTestTests
//
//  Created by Vinod Vishwanath on 27/07/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

import XCTest
@testable import MyntraTest

class MyntraTestTests: XCTestCase {
    
    var game : MTMemoryGame!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGameInitialization () {
        
        game = MTMemoryGame(numberOfTiles: 9)
        game.initialize()
        
        let completionExpectation = expectationWithDescription("Init Method")
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(8.0 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            XCTAssert(self.game.initComplete, "Failed to initialize game!")
            
            completionExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10.0, handler: nil)
    }
    
    func testGameWinByCheating () {
        
        game = MTMemoryGame(numberOfTiles: 9)
        game.initialize()
        
        let completionExpectation = expectationWithDescription("Init Method with Tricks")
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(8.0 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            XCTAssert(self.game.initComplete, "Failed to initialize game!")
            
            for i in 0 ..< 9 {
                
                self.game.handleCorrectAnswerAtIndex(i)
            }
            
            XCTAssertEqual(self.game.score(), "Score: 9/9")
            
            completionExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10.0, handler: nil)
    }
    
    func testJSONSanitizing () {
        
        let completionExpectation = expectationWithDescription("Init Method with Tricks")
        
        MTNetworkHelper.fetchAPIResponseWithCompletion { (responseStr) in
            
            XCTAssertNotNil(responseStr, "Nil response received!")
            
            self.measureBlock({ 
                
                MTNetworkHelper.sanitizedString(responseStr!)
            })
            
            completionExpectation.fulfill()
        }
        
        
        waitForExpectationsWithTimeout(10.0, handler: nil)
    }
    
    func testJSONParseTime () {
        
        let completionExpectation = expectationWithDescription("Init Method with Tricks")
        
        MTNetworkHelper.fetchAPIResponseWithCompletion { (responseStr) in
            
            XCTAssertNotNil(responseStr, "Nil response received!")
            
            self.measureBlock({
                
                MTNetworkHelper.parseLinksFromJSONString(responseStr!)
            })
            
            completionExpectation.fulfill()
        }
        
        
        waitForExpectationsWithTimeout(10.0, handler: nil)
    }
}
