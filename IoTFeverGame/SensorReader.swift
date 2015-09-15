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