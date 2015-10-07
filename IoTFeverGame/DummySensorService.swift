//
//  MoveService.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 4/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class DummySensorService : NSObject, SensorServiceProtocol {
    
    var listener : SensorDataListenerProtocol?
    
    var leftArmTimer : NSTimer?
    var rightArmTimer : NSTimer?
    
    func subscribe(listener : SensorDataListenerProtocol) {
        self.listener = listener
        rightArmTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("generateSensorDataFromDeviceRightArm"), userInfo: nil, repeats: true)
        leftArmTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("generateSensorDataFromDeviceLeftArm"), userInfo: nil, repeats: true)
    }
    
    func connect(callback : () -> ()){
        callback()
    }
    
    func isConnected() -> Bool {
        return true
    }
    
    func generateSensorDataFromDeviceRightArm() {
        listener!.onDataRightIncoming(generateData())
    }
    
    func generateSensorDataFromDeviceLeftArm() {
        listener!.onDataLeftIncoming(generateData())
    }
    
    func disconnect() -> Bool {
        rightArmTimer!.invalidate()
        leftArmTimer!.invalidate()
        return true
    }
    
    func sensorLeftStatus() -> Bool {
        return true
    }
    
    func sensorRightStatus() -> Bool {
        return true
    }

    private func generateData() -> [Double] {
        var data = [Double](count: 2,repeatedValue: 0.0)
        data[0] = Double(randomNumber(-100,upper: 100))
        data[1] = Double(randomNumber(-100,upper: 100))
        println("DUMMY - Test Mode")
        println(data)
        return data
    }
    
    func randomNumber (lower : Int , upper : Int) -> Int {
        let result = Int(arc4random_uniform(UInt32(upper - lower + 1))) +   lower
        return result
    }
}
