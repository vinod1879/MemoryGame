//
//  MyntraTestUITests.swift
//  MyntraTestUITests
//
//  Created by Vinod Vishwanath on 27/07/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

import XCTest

class MyntraTestUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let completionExpectation = expectationWithDescription("Random Test Method")
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(20.0 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            XCUIDevice.sharedDevice().orientation = .Portrait
            
            let collectionViewsQuery = XCUIApplication().collectionViews
            let image = collectionViewsQuery.childrenMatchingType(.Cell).elementBoundByIndex(0).otherElements.childrenMatchingType(.Image).element
            image.tap()
            
            let image2 = collectionViewsQuery.childrenMatchingType(.Cell).elementBoundByIndex(1).otherElements.childrenMatchingType(.Image).element
            image2.tap()
            
            let image3 = collectionViewsQuery.childrenMatchingType(.Cell).elementBoundByIndex(2).otherElements.childrenMatchingType(.Image).element
            image3.tap()
            
            let image4 = collectionViewsQuery.childrenMatchingType(.Cell).elementBoundByIndex(5).otherElements.childrenMatchingType(.Image).element
            image4.tap()
            
            let image5 = collectionViewsQuery.childrenMatchingType(.Cell).elementBoundByIndex(4).otherElements.childrenMatchingType(.Image).element
            image5.tap()
            
            let image6 = collectionViewsQuery.childrenMatchingType(.Cell).elementBoundByIndex(3).otherElements.childrenMatchingType(.Image).element
            image6.tap()
            
            let image7 = collectionViewsQuery.childrenMatchingType(.Cell).elementBoundByIndex(6).otherElements.childrenMatchingType(.Image).element
            image7.tap()
            
            let image8 = collectionViewsQuery.childrenMatchingType(.Cell).elementBoundByIndex(8).otherElements.childrenMatchingType(.Image).element
            image8.tap()
            
            let image9 = collectionViewsQuery.childrenMatchingType(.Cell).elementBoundByIndex(9).otherElements.childrenMatchingType(.Image).element
            image9.tap()
            image.tap()
            image2.tap()
            image3.tap()
            image.tap()
            image2.tap()
            image5.tap()
            image4.tap()
            image7.tap()
            image9.tap()
            image8.tap()
            image6.tap()
            image.tap()
            image2.tap()
            image7.tap()
            image9.tap()
            image5.tap()
            image.tap()
            image7.tap()
            image9.tap()
            
            
            completionExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(120, handler: nil)
    }
    
}
