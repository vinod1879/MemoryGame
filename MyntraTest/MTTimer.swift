//
//  MTTimer.swift
//  MyntraTest
//
//  Created by Vinod Vishwanath on 27/07/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

import UIKit

protocol MTTimerDelegate : class {
    
    func timer(timer: MTTimer, updatedTimeLeft timeLeft: Double, withFormattedString formattedString: String)
    
    func timerTimedOut(timer: MTTimer)
}

class MTTimer: NSObject {
    
    //MARK:- Public Vars
    
    weak var delegate : MTTimerDelegate?
    
    //MARK:- Private Vars
    
    private var date  : NSDate!
    private var count : Double!
    private var timer : NSTimer?
    
    //MARK:- Public API
    
    func startWithTimeInterval(time: NSTimeInterval) {
        
        timer?.invalidate()
        date    = NSDate()
        count   = time
        
        start()
    }
    
    //MARK:- Private
    
    private func start () {
        
        if count > 0 {
            
            timer = NSTimer(fireDate: NSDate(), interval: 1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
            
            NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
        }
    }
    
    @objc private func timerFired () {
        
        let timeInterval = NSDate().timeIntervalSinceDate(self.date)
        
        let timeLeft : Double = count - timeInterval
        
        if timeLeft <= 0 {
            
            timer?.invalidate()
            timer = nil
            
            delegate?.timerTimedOut(self)
            
        } else {
            
            print("Time Left: ", Int(timeLeft))
            postNotificationForTimeLeft(timeLeft)
        }
    }
    
    private func postNotificationForTimeLeft (timeLeft : Double) {
        
        let minutes : Int = Int(timeLeft / 60)
        let seconds : Int = Int(timeLeft % 60)
        
        let str = String(format: "%d:%02d", minutes, seconds)
        
        delegate?.timer(self, updatedTimeLeft: timeLeft, withFormattedString: str)
    }
}
