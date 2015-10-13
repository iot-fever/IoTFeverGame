//
//  SensorService.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 9/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation
import CoreBluetooth

let deviceName = "CC2650 SensorTag"

// Service UUIDs
let DeviceInfoServiceUUID    = CBUUID(string: "180A")
let MovementServiceUUID      = CBUUID(string: "F000AA80-0451-4000-B000-000000000000")

// Characteristic UUIDs
let DeviceInfoSystemIDUUID  = CBUUID(string: "2A23")
let MovementDataUUID        = CBUUID(string: "F000AA81-0451-4000-B000-000000000000")
let MovementConfigUUID      = CBUUID(string: "F000AA82-0451-4000-B000-000000000000")
let MovementPeriodUUID      = CBUUID(string: "F000AA83-0451-4000-B000-000000000000")

class SensorReader {
    
    // Check name of device from advertisement data
    class func sensorTagFound (advertisementData: [NSObject : AnyObject]!) -> Bool {
        let nameOfDeviceFound = (advertisementData as NSDictionary).objectForKey(CBAdvertisementDataLocalNameKey) as? NSString
        
        return (nameOfDeviceFound == deviceName)
    }
    
    
    // Check if the service has a valid UUID
    class func validService (service : CBService) -> Bool {
        if service.UUID == DeviceInfoServiceUUID ||
            service.UUID == MovementServiceUUID {
                return true
        }
        else {
            return false
        }
    }
    
    
    // Check if the characteristic has a valid data UUID
    class func validDataCharacteristic (characteristic : CBCharacteristic) -> Bool {
        if  characteristic.UUID == MovementDataUUID ||
            characteristic.UUID == DeviceInfoSystemIDUUID {
                return true
        }
        else {
            return false
        }
    }
    
    
    // Check if the characteristic has a valid config UUID
    class func validConfigCharacteristic (characteristic : CBCharacteristic) -> Bool {
        if  characteristic.UUID == MovementConfigUUID ||
            characteristic.UUID == MovementPeriodUUID ||
            characteristic.UUID == DeviceInfoSystemIDUUID {
                return true
        }
        else {
            return false
        }
    }
    
    // Convert NSData to array of bytes
    class func dataToSignedBytes16(value : NSData) -> [Int16] {
        let count = value.length
        var array = [Int16](count: count, repeatedValue: 0)
        value.getBytes(&array, length:count * sizeof(Int16))
        return array
    }
    
    class func dataToUnsignedBytes16(value : NSData) -> [UInt16] {
        let count = value.length
        var array = [UInt16](count: count, repeatedValue: 0)
        value.getBytes(&array, length:count * sizeof(UInt16))
        return array
    }
    
    class func dataToSignedBytes8(value : NSData) -> [Int8] {
        let count = value.length
        var array = [Int8](count: count, repeatedValue: 0)
        value.getBytes(&array, length:count * sizeof(Int8))
        return array
    }
    
    class func getMovementData(value: NSData) -> NSData {
        return value
    }
    
    // Get Accelerometer values
    class func getAccelerometerData(value: NSData) -> [Double] {
        let dataFromSensor = dataToSignedBytes16(value)
        let xVal = Double(dataFromSensor[3]) / 64
        let yVal = Double(dataFromSensor[4]) / 64
        let zVal = Double(dataFromSensor[5]) / 64 * -1
        return [xVal, yVal, zVal]
    }
    
}




// The UUID of the 2 sensors
let sensorLeftUUID = NSUserDefaults.standardUserDefaults().stringForKey("left_sensor_uuid")
let sensorRightUUID = NSUserDefaults.standardUserDefaults().stringForKey("right_sensor_uuid")

class SensorDelegate: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate {
    /******* CBCentralPeripheralDelegate *******/
    
    // Check if the service discovered is valid i.e. one of the following:
    // Movement Service
    // (Others are not implemented)
    
    var sensorTagPeripheralLeft : CBPeripheral!
    var sensorTagPeripheralRight : CBPeripheral!
    
    var sensorLeftFound = false
    var sensorRightFound = false
    
    var listener : SensorDataListenerProtocol = SensorDataListener()
    
    var whenSensorsConnected:(()->Void)?
    
    override init() {
        
    }
    
    func addConnectedCallback(callback : () -> ()) {
        self.whenSensorsConnected = callback
    }
    
    func subscribe(listener: SensorDataListenerProtocol) {
        self.listener = listener
    }
    
    func unsubscribe() {
        self.listener = SensorDataListener()
    }
    
    func sensorsFound() -> Bool {
        return sensorLeftFound && sensorRightFound
    }
    
    func sensorRightStatus() -> Bool {
        return sensorRightFound
    }
    
    func sensorLeftStatus() -> Bool {
        return sensorLeftFound
    }
    
    // Check status of BLE hardware
    func centralManagerDidUpdateState(central: CBCentralManager) {
        if central.state == CBCentralManagerState.PoweredOn {
            // Scan for peripherals if BLE is turned on
            central.scanForPeripheralsWithServices(nil, options: nil)
            print("Searching for BLE Devices")
        }
        else {
            // Can have different conditions for all states if needed - show generic alert for now
            print("Bluetooth switched off or not initialized")
        }
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber){
        
                var deviceUUID  = peripheral.identifier.UUIDString
        
                if SensorReader.sensorTagFound(advertisementData) == true {
        
                    print("Scanning...Detected \(deviceUUID)")
        
                    if sensorLeftUUID == deviceUUID {
                        self.sensorTagPeripheralLeft = peripheral
                        self.sensorTagPeripheralLeft.delegate = self
                        print("Left Sensor Found")
                        sensorLeftFound = true
                    }
        
                    else if sensorRightUUID == deviceUUID {
                        self.sensorTagPeripheralRight = peripheral
                        self.sensorTagPeripheralRight.delegate = self
                        print("Right Sensor Found")
                        sensorRightFound = true
                    }
        
                    central.connectPeripheral(peripheral, options: nil)
                    
                    if (self.sensorsFound()) {
                        self.whenSensorsConnected!()
                    }
                }
        
    }
    
    // Discover services of the peripheral
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("Discovering peripheral services")
        peripheral.discoverServices(nil)
    }
    
    
    // If disconnected, start searching again
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError!) {
        print("Disconnected")
        self.sensorLeftFound = false
        self.sensorRightFound = false
        central.scanForPeripheralsWithServices(nil, options: nil)
    }
    
    // Check if the service discovered is valid i.e. one of the following:
    // Accelerometer Service
    // (Others are not implemented)
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        for service in peripheral.services! {
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
        
        var periodValueMovement = 10
        let periodBytesMovement = NSData(bytes: &periodValueMovement, length: sizeof(UInt8))
        
        for charateristic in service.characteristics! {
            let thisCharacteristic = charateristic as! CBCharacteristic
            if SensorReader.validDataCharacteristic(thisCharacteristic) {
                peripheral.setNotifyValue(true, forCharacteristic: thisCharacteristic)
            }
            
            if SensorReader.validConfigCharacteristic(thisCharacteristic) {
                
                if thisCharacteristic.UUID == MovementConfigUUID {
                    peripheral.writeValue(enablyBytesMovement, forCharacteristic: thisCharacteristic,
                        type: CBCharacteristicWriteType.WithResponse)
                }
                if thisCharacteristic.UUID == MovementPeriodUUID {
                    peripheral.writeValue(periodBytesMovement, forCharacteristic: thisCharacteristic,
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
            let movementData = SensorReader.getMovementData(characteristic.value!)
            let accelData = SensorReader.getAccelerometerData(movementData)
            var accelerometerX = accelData[0]
            
            if sensorLeftUUID == peripheral!.identifier.UUIDString {
                print("Left sensor: \(accelerometerX)");
                //self.publishLeft(accelData)
                self.publishLeft(Float(accelData[0]))
            }
                
            else if sensorRightUUID == peripheral!.identifier.UUIDString {
                print("Right sensor: \(accelerometerX)");
                //self.publishRight(accelData)
                self.publishRight(Float(accelData[0]))
            }
        }
    }
    
    private func publishRight(data: Float) {
        listener.onDataRightIncoming(data)
    }
    
    private func publishLeft(data: Float) {
        listener.onDataLeftIncoming(data)
    }
    
}