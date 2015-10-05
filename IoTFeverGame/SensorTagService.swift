////
////  SensorService.swift
////  IoTFeverGame
////
////  Created by Foitzik Andreas on 9/9/15.
////  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
////
//
//import Foundation
//import CoreBluetooth
//
//// The system info of the 2 sensors
////let sensorLeftID = "808b70000084bec4"
////let sensorRightID = "8088b9000048b4b0"
//
//// The UUID of the 2 sensors
////let sensorLeftUUID = NSUserDefaults.standardUserDefaults().stringForKey("left_sensor_uuid")
////let sensorRightUUID = NSUserDefaults.standardUserDefaults().stringForKey("right_sensor_uuid")
//
//class NooPSensorDataListener : SensorDataListener {
//    
//    func onDataRightIncoming(data: [Double]) {
//        // swallowing the incoming data
//    }
//    
//    func onDataLeftIncoming(data: [Double]) {
//        // swallowing the incoming data
//    }
//}
//
//class SensorDelegate {
//    
//    var sensorTagPeripheralLeft     : CBPeripheral!
//    var sensorTagPeripheralRight    : CBPeripheral!
//
//    var sensorLeftFound     = false
//    var sensorRightFound    = false
//    
//    var listener : SensorDataListener = NooPSensorDataListener()
//
//    var whenSensorsConnected:(()->Void)?
//    
//    internal init() {
//        
//    }
//    
//    func addConnectedCallback(callback : () -> ()) {
//        self.whenSensorsConnected = callback
//    }
//    
//    func subscribe(listener: SensorDataListener) {
//        self.listener = listener
//    }
//    
//    func unsubscribe() {
//        self.listener = NooPSensorDataListener()
//    }
//    
//    func sensorsFound() -> Bool {
//        return sensorLeftFound && sensorRightFound
//    }
//    
//    func sensorRightStatus() -> Bool {
//        return sensorRightFound
//    }
//    
//    func sensorLeftStatus() -> Bool {
//        return sensorLeftFound
//    }
//    
//    func detect() {
//        
//        
//            
//            println("Scanning...Detected \(deviceUUID)")
//            
//            if sensorLeftUUID == deviceUUID {
//                self.sensorTagPeripheralLeft = peripheral
//                self.sensorTagPeripheralLeft.delegate = self
//                println("Left Sensor Found")
//                sensorLeftFound = true
//            }
//                
//            else if sensorRightUUID == deviceUUID {
//                self.sensorTagPeripheralRight = peripheral
//                self.sensorTagPeripheralRight.delegate = self
//                println("Right Sensor Found")
//                sensorRightFound = true
//            }
//            
//            central.connectPeripheral(peripheral, options: nil)
//            
//            if (self.sensorsFound()) {
//                self.whenSensorsConnected!()
//            }
//        }
//
//    }
//    
//    // Discover services of the peripheral
//    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
//        println("Discovering peripheral services")
//        peripheral.discoverServices(nil)
//    }
//    
//    
//    // If disconnected, start searching again
//    func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
//        println("Disconnected")
//        self.sensorLeftFound = false
//        self.sensorRightFound = false
//        central.scanForPeripheralsWithServices(nil, options: nil)
//    }
//    
//    // Check if the service discovered is valid i.e. one of the following:
//    // Accelerometer Service
//    // (Others are not implemented)
//    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
//        for service in peripheral.services {
//            let thisService = service as! CBService
//            
//            if SensorReader.validService(thisService) {
//                // Discover characteristics of all valid services
//                peripheral.discoverCharacteristics(nil, forService: thisService)
//            }
//        }
//    }
//    
//    // Enable notification and sensor for each characteristic of valid service
//    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
//        
//        var enableValue = 1
//        let enablyBytes = NSData(bytes: &enableValue, length: sizeof(UInt8))
//        
//        var enableValueMovement = 127
//        let enablyBytesMovement = NSData(bytes: &enableValueMovement, length: sizeof(UInt16))
//        
//        var periodValueMovement = 10
//        let periodBytesMovement = NSData(bytes: &periodValueMovement, length: sizeof(UInt8))
//        
//        for charateristic in service.characteristics {
//            let thisCharacteristic = charateristic as! CBCharacteristic
//            if SensorReader.validDataCharacteristic(thisCharacteristic) {
//                peripheral.setNotifyValue(true, forCharacteristic: thisCharacteristic)
//            }
//            
//            if SensorReader.validConfigCharacteristic(thisCharacteristic) {
//                
//                if thisCharacteristic.UUID == MovementConfigUUID {
//                    peripheral.writeValue(enablyBytesMovement, forCharacteristic: thisCharacteristic,
//                        type: CBCharacteristicWriteType.WithResponse)
//                }
//                if thisCharacteristic.UUID == MovementPeriodUUID {
//                    peripheral.writeValue(periodBytesMovement, forCharacteristic: thisCharacteristic,
//                        type: CBCharacteristicWriteType.WithResponse)
//                }
//                else if thisCharacteristic.UUID == DeviceInfoSystemIDUUID {
//                    peripheral.readValueForCharacteristic(thisCharacteristic)
//                }
//                    
//                else {
//                    peripheral.writeValue(enablyBytes, forCharacteristic: thisCharacteristic, type: CBCharacteristicWriteType.WithResponse)
//                }
//            }
//        }
//    }
//    
//    // Get data values when they are updated
//    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
//        
//        if characteristic.UUID == MovementDataUUID {
//            let movementData = SensorReader.getMovementData(characteristic.value)
//            let accelData = SensorReader.getAccelerometerData(movementData)
//            var accelerometerX = accelData[0]
//            
//            if sensorLeftUUID == peripheral.identifier.UUIDString {
//                println("Left sensor: \(accelerometerX)");
//                self.publishLeft(accelData)
//            }
//                
//            else if sensorRightUUID == peripheral.identifier.UUIDString {
//                println("Right sensor: \(accelerometerX)");
//                self.publishRight(accelData)
//            }
//        }
//    }
//    
//    private func publishRight(data: [Double]) {
//        listener.onDataRightIncoming(data)
//    }
//    
//    private func publishLeft(data: [Double]) {
//        listener.onDataLeftIncoming(data)
//    }
//
//
