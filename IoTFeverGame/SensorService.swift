//
//  SensorService.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 9/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation
import CoreBluetooth

var sensorDelegate: SensorDelegate = SensorDelegate.init()
var centralManager: CBCentralManager!

protocol IOTFeverDataAware {
    func onDataIncoming(data: [Double])
}

class SensorDelegate: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate {
    /******* CBCentralPeripheralDelegate *******/
    
    // Check if the service discovered is valid i.e. one of the following:
    // IR Temperature Service
    // Accelerometer Service
    // Humidity Service
    // Magnetometer Service
    // Barometer Service
    // Gyroscope Service
    // (Others are not implemented)
    var sensorTagPeripheral     : CBPeripheral!
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
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        println("1")
        println("Looking at peripheral services")
        
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
        
        println("2")
        println("Enabling sensors")
        
        var enableValue = 1
        let enablyBytes = NSData(bytes: &enableValue, length: sizeof(UInt8))
        
        var enableValueMovement = 127
        let enablyBytesMovement = NSData(bytes: &enableValueMovement, length: sizeof(UInt16))
        
        for charateristic in service.characteristics {
            let thisCharacteristic = charateristic as! CBCharacteristic
            if SensorReader.validDataCharacteristic(thisCharacteristic) {
                self.sensorTagPeripheral.setNotifyValue(true, forCharacteristic: thisCharacteristic)
            }
            
            if SensorReader.validConfigCharacteristic(thisCharacteristic) {
                if thisCharacteristic.UUID == MovementConfigUUID {
                    self.sensorTagPeripheral.writeValue(enablyBytesMovement, forCharacteristic: thisCharacteristic,
                        type: CBCharacteristicWriteType.WithResponse)
                    
                } else {
                    self.sensorTagPeripheral.writeValue(enablyBytes, forCharacteristic: thisCharacteristic, type: CBCharacteristicWriteType.WithResponse)
                }
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!){
        println("3")
        println("Connected")
        
        if characteristic.UUID == MovementDataUUID {
            let movementData = SensorReader.getMovementData(characteristic.value)
            let accelData = SensorReader.getAccelerometerData(movementData)
            
            self.publish(accelData)
            
            println(String(format:"%f", accelData[0]))
        }
    }
    
    // Check status of BLE hardware
    func centralManagerDidUpdateState(central: CBCentralManager!){
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
        
        if SensorReader.sensorTagFound(advertisementData) == true {
            // Update Status Label
            println("Sensor Tag Found")
            // Stop scanning, set as the peripheral to use and establish connection
            central.stopScan()
            self.sensorTagPeripheral = peripheral
            self.sensorTagPeripheral.delegate = self
            central.connectPeripheral(self.sensorTagPeripheral, options: nil)
        }
        else {
            println("Sensor Tag NOT Found")
            //showAlertWithText(header: "Warning", message: "SensorTag Not Found")
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
}
