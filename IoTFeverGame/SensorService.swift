//
//  SensorService.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 9/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation
import CoreBluetooth

// The system info of the 2 sensors
let sensorLeftID = "808b70000084bec4"
let sensorRightID = "8088b9000048b4b0"

// The UUID of the 2 sensors
let sensorLeftUUID = "66CB73B3-8E80-BC0F-8D22-69991491A33E"
let sensorRightUUID = "516AB7BD-7B80-285A-B652-20CE104FC6BF"

var sensorDelegate: SensorDelegate = SensorDelegate.init()
var centralManager: CBCentralManager!

protocol IOTFeverDataAware {
    func onDataIncoming(data: [Double])
}

class SensorDelegate: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate {
    /******* CBCentralPeripheralDelegate *******/
    
    // Check if the service discovered is valid i.e. one of the following:
    // Movement Service
    // (Others are not implemented)
    
    var sensorTagPeripheralLeft : CBPeripheral!
    var sensorTagPeripheralRight : CBPeripheral!

    var sensorLeftFound = false
    var sensorRightFound = false
    
    var subscribers = [IOTFeverDataAware]()
    override init() {
        
    }
    
    func subscribe(vc: IOTFeverDataAware) {
        self.subscribers.append(vc)
    }
    
    func publish(data: [Double]) {
        for vc in self.subscribers {
            vc.onDataIncoming(data)
        }
    }

    func sensorsFound() -> Bool {
        return sensorLeftFound && sensorRightFound
    }
    
    // Check status of BLE hardware
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        if central.state == CBCentralManagerState.PoweredOn {
            // Scan for peripherals if BLE is turned on
            central.scanForPeripheralsWithServices(nil, options: nil)
            println("Searching for BLE Devices")
        }
        else {
            // Can have different conditions for all states if needed - show generic alert for now
            println("Bluetooth switched off or not initialized")
        }
    }
    
    // Check out the discovered peripherals to find Sensor Tag
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        
        var deviceUUID  = peripheral.identifier.UUIDString
        
        if SensorReader.sensorTagFound(advertisementData) == true {
            
            println("Scanning...Detected \(deviceUUID)")
            
            if sensorLeftUUID == deviceUUID {
                self.sensorTagPeripheralLeft = peripheral
                self.sensorTagPeripheralLeft.delegate = self
                println("Left Sensor Found")
                sensorLeftFound = true
            }
                
            else if sensorRightUUID == deviceUUID {
                self.sensorTagPeripheralRight = peripheral
                self.sensorTagPeripheralRight.delegate = self
                println("Right Sensor Found")
                sensorRightFound = true
            }
            
            central.connectPeripheral(peripheral, options: nil)
        }
        
        if sensorsFound() {
            println("Left and Right sensors found.")
            central.stopScan()
        }
    }
    
    // Discover services of the peripheral
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        println("Discovering peripheral services")
        peripheral.discoverServices(nil)
    }
    
    
    // If disconnected, start searching again
    func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        println("Disconnected")
        central.scanForPeripheralsWithServices(nil, options: nil)
    }
    
    // Check if the service discovered is valid i.e. one of the following:
    // Accelerometer Service
    // (Others are not implemented)
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        for service in peripheral.services {
            let thisService = service as! CBService
            
            if SensorReader.validService(thisService) {
                // Discover characteristics of all valid services
                peripheral.discoverCharacteristics(nil, forService: thisService)
            }
        }
    }
    
    // Enable notification and sensor for each characteristic of valid service
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        
        var enableValue = 1
        let enablyBytes = NSData(bytes: &enableValue, length: sizeof(UInt8))
        
        var enableValueMovement = 127
        let enablyBytesMovement = NSData(bytes: &enableValueMovement, length: sizeof(UInt16))
        
        for charateristic in service.characteristics {
            let thisCharacteristic = charateristic as! CBCharacteristic
            if SensorReader.validDataCharacteristic(thisCharacteristic) {
                peripheral.setNotifyValue(true, forCharacteristic: thisCharacteristic)
            }
            
            if SensorReader.validConfigCharacteristic(thisCharacteristic) {
                
                if thisCharacteristic.UUID == MovementConfigUUID {
                    peripheral.writeValue(enablyBytesMovement, forCharacteristic: thisCharacteristic,
                        type: CBCharacteristicWriteType.WithResponse)
                    
                }
                else if thisCharacteristic.UUID == DeviceInfoSystemIDUUID {
                    peripheral.readValueForCharacteristic(thisCharacteristic)
                }
                    
                else {
                    peripheral.writeValue(enablyBytes, forCharacteristic: thisCharacteristic, type: CBCharacteristicWriteType.WithResponse)
                }
            }
        }
    }
    
    // Get data values when they are updated
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        
        if characteristic.UUID == MovementDataUUID {
            let movementData = SensorReader.getMovementData(characteristic.value)
            let accelData = SensorReader.getAccelerometerData(movementData)
            var accelerometerX = accelData[0]
            
            if sensorLeftUUID == peripheral.identifier.UUIDString {
                println("Left sensor: \(accelerometerX)");
            }
                
            else if sensorRightUUID == peripheral.identifier.UUIDString {
                println("Right sensor: \(accelerometerX)");
            }
            
            //self.publish(accelData)
        }
    }

}
