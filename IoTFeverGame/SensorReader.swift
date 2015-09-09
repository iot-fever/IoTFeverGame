//
//  SensorTag.swift
//  SwiftSensorTag

import Foundation
import CoreBluetooth


let deviceName = "CC2650 SensorTag"

// Service UUIDs
let IRTemperatureServiceUUID = CBUUID(string: "F000AA00-0451-4000-B000-000000000000")
let HumidityServiceUUID      = CBUUID(string: "F000AA20-0451-4000-B000-000000000000")
let BarometerServiceUUID     = CBUUID(string: "F000AA40-0451-4000-B000-000000000000")
let AccelerometerServiceUUID = CBUUID(string: "F000AA10-0451-4000-B000-000000000000")
let MagnetometerServiceUUID  = CBUUID(string: "F000AA30-0451-4000-B000-000000000000")
let GyroscopeServiceUUID     = CBUUID(string: "F000AA50-0451-4000-B000-000000000000")
let MovementServiceUUID      = CBUUID(string: "F000AA80-0451-4000-B000-000000000000")

// Characteristic UUIDs
let IRTemperatureDataUUID   = CBUUID(string: "F000AA01-0451-4000-B000-000000000000")
let IRTemperatureConfigUUID = CBUUID(string: "F000AA02-0451-4000-B000-000000000000")
let AccelerometerDataUUID   = CBUUID(string: "F000AA11-0451-4000-B000-000000000000")
let AccelerometerConfigUUID = CBUUID(string: "F000AA12-0451-4000-B000-000000000000")
let HumidityDataUUID        = CBUUID(string: "F000AA21-0451-4000-B000-000000000000")
let HumidityConfigUUID      = CBUUID(string: "F000AA22-0451-4000-B000-000000000000")
let MagnetometerDataUUID    = CBUUID(string: "F000AA31-0451-4000-B000-000000000000")
let MagnetometerConfigUUID  = CBUUID(string: "F000AA32-0451-4000-B000-000000000000")
let BarometerDataUUID       = CBUUID(string: "F000AA41-0451-4000-B000-000000000000")
let BarometerConfigUUID     = CBUUID(string: "F000AA42-0451-4000-B000-000000000000")
let GyroscopeDataUUID       = CBUUID(string: "F000AA51-0451-4000-B000-000000000000")
let GyroscopeConfigUUID     = CBUUID(string: "F000AA52-0451-4000-B000-000000000000")

let MovementDataUUID        = CBUUID(string: "F000AA81-0451-4000-B000-000000000000")
let MovementConfigUUID      = CBUUID(string: "F000AA82-0451-4000-B000-000000000000")
let MovementPeriodUUID      = CBUUID(string: "F000AA83-0451-4000-B000-000000000000")

class SensorReader {
    
    // Check name of device from advertisement data
    class func sensorTagFound (advertisementData: [NSObject : AnyObject]!) -> Bool {
        
        for item in advertisementData {
            println(item)
        }
        
        let nameOfDeviceFound = (advertisementData as NSDictionary).objectForKey(CBAdvertisementDataLocalNameKey) as? NSString
        return (nameOfDeviceFound == deviceName)
    }
    
    
    // Check if the service has a valid UUID
    class func validService (service : CBService) -> Bool {
        
        if service.UUID == IRTemperatureServiceUUID || service.UUID == AccelerometerServiceUUID ||
            service.UUID == HumidityServiceUUID || service.UUID == MagnetometerServiceUUID ||
            service.UUID == BarometerServiceUUID || service.UUID == GyroscopeServiceUUID
            || service.UUID == MovementServiceUUID {
                return true
        }
        else {
            return false
        }

    }
    
    
    // Check if the characteristic has a valid data UUID
    class func validDataCharacteristic (characteristic : CBCharacteristic) -> Bool {
        if  characteristic.UUID == IRTemperatureDataUUID ||
            characteristic.UUID == AccelerometerDataUUID ||
            characteristic.UUID == HumidityDataUUID ||
            characteristic.UUID == MagnetometerDataUUID ||
            characteristic.UUID == BarometerDataUUID ||
            characteristic.UUID == GyroscopeDataUUID ||
            characteristic.UUID == MovementDataUUID {
                return true
        }
        else {
            return false
        }
    }
    
    
    // Check if the characteristic has a valid config UUID
    class func validConfigCharacteristic (characteristic : CBCharacteristic) -> Bool {
        if  characteristic.UUID == IRTemperatureConfigUUID ||
            characteristic.UUID == AccelerometerConfigUUID ||
            characteristic.UUID == HumidityConfigUUID ||
            characteristic.UUID == MagnetometerConfigUUID ||
            characteristic.UUID == BarometerConfigUUID ||
            characteristic.UUID == GyroscopeConfigUUID ||
            characteristic.UUID == MovementConfigUUID {
                return true
        }
        else {
            return false
        }
    }
    
    
    // Get labels of all sensors
    class func getSensorLabels () -> [String] {
        let sensorLabels : [String] = [
            "Accelerometer X",
            "Accelerometer Y",
            "Accelerometer Z"
        ]
        return sensorLabels
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
    
    // Get magnetometer values
    class func getMagnetometerData(value: NSData) -> [Double] {
        let dataFromSensor = dataToSignedBytes16(value)
        let xVal = Double(dataFromSensor[6]) * 2000 / 65536 * -1
        let yVal = Double(dataFromSensor[7]) * 2000 / 65536 * -1
        let zVal = Double	(dataFromSensor[8]) * 2000 / 65536
        return [xVal, yVal, zVal]
    }
    
    

    
}