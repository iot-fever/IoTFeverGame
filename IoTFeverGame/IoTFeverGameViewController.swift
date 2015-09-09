//
//  IoTFeverGameViewController.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 3/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import UIKit
import CoreData
import CoreBluetooth

class IoTFeverGameViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate  {

    // MARK: UI Properties
    @IBOutlet weak var try1Image: UIImageView!
    @IBOutlet weak var try2Image: UIImageView!
    @IBOutlet weak var try3Image: UIImageView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeCountLabel: UILabel!
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var levelAmountLabel: UILabel!
    
    var countdown           : Int       = 90
    var intervalCountdown   : Double    = 1.0
    var intervalImage       : Double    = 3.0
    var duration            : UInt32    = UInt32(EntityManager.sharedInstance.get().runningLevel.duration)
    
    // BLE
    var centralManager          : CBCentralManager!
    var sensorTagPeripheral     : CBPeripheral!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        // Change Counter
        self.timeCountLabel.text    = String(90)
        var timerCountdown = NSTimer.scheduledTimerWithTimeInterval(intervalCountdown, target: self, selector: Selector("updateCountdown:"), userInfo: nil, repeats: true)
        
        // Change Image
        self.timeCountLabel.text   = String(EntityManager.sharedInstance.get().runningLevel.name)
        var timerImage = NSTimer.scheduledTimerWithTimeInterval(intervalImage, target: self, selector: Selector("updateImage:"), userInfo: nil, repeats: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Change Counter
    func updateCountdown(timer: NSTimer) {
        if(countdown >= 0) {
            self.timeCountLabel.text = String(countdown--)
        } else {
            timer.invalidate()
        }
    }
    
    // Change Image
    func updateImage(timer: NSTimer) {
        
        switch countdown {
        
        //Level1
        case 60...90:
            self.imageView.image = UIImage(named: LevelService.getNextRandomMove().path)
            //Sensortag - Validation
            
            timer.fireDate = timer.fireDate.dateByAddingTimeInterval(3)
            self.levelAmountLabel.text = String(1)
        
        //Level2
        case 30...60:
            self.imageView.image = UIImage(named: LevelService.getNextRandomMove().path)
            //Sensortag - Validation
            
            timer.fireDate = timer.fireDate.dateByAddingTimeInterval(2)
            self.levelAmountLabel.text = String(2)
        
        //Level3
        case 1...30:
            self.imageView.image = UIImage(named: LevelService.getNextRandomMove().path)
            //Sensortag - Validation
            
            timer.fireDate = timer.fireDate.dateByAddingTimeInterval(1)
            self.levelAmountLabel.text = String(3)
        
        //Finish
        case 0:
            timer.invalidate()
            
            var alert = UIAlertController(title: "Success", message: "Congratulation - You completed all Moves!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Next", style: UIAlertActionStyle.Default, handler: next))
            
            self.presentViewController(alert, animated: true, completion: nil)
        
        default:
            println("default")
        }
    }
    
    func next(alert: UIAlertAction!) {
        println("Success")
    }
    
    func cancel(alert: UIAlertAction!) {
        println("cancel")
    }
    
    /* Sensortag */
    
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
            self.centralManager.stopScan()
            self.sensorTagPeripheral = peripheral
            self.sensorTagPeripheral.delegate = self
            self.centralManager.connectPeripheral(self.sensorTagPeripheral, options: nil)
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
    
    
    /******* CBCentralPeripheralDelegate *******/
    
    // Check if the service discovered is valid i.e. one of the following:
    // IR Temperature Service
    // Accelerometer Service
    // Humidity Service
    // Magnetometer Service
    // Barometer Service
    // Gyroscope Service
    // (Others are not implemented)
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
                        
            println(String(format:"%f", accelData[0]))
        }
    }
    
    /* Sensortag */
}
