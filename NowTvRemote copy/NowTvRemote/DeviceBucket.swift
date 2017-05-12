//
//  DeviceBucket.swift
//  NowTvRemote
//
//  Created by Winton, Simon (Associate Software Developer) on 01/12/2016.
//  Copyright © 2016 Winton, Simon (Associate Software Developer). All rights reserved.
//

import Foundation


internal class DeviceBucket
{
    private var devices = [RokuDeviceAppModel]()
    
    private var deviceTimeOut: TimeInterval = 120
    
    func updateDeviceList()
    {
        for device in devices
        {
            if NSDate() as Date > device.lastConnected.addingTimeInterval(deviceTimeOut) as Date
            {
                devices.remove(at: devices.index(of: device)!)
            }
            
        }
    }
    
    func addDevice(newDev: RokuDeviceAppModel)
    {
        let currentDevice = devices.filter{ $0.ipAddress == newDev.ipAddress }.first
        if currentDevice != nil
        {
            devices[devices.index(of: currentDevice! as RokuDeviceAppModel)!] = newDev
        }
        else{
            devices.append(newDev)
        }
    }
    
    func getDevices() -> [RokuDeviceAppModel]
    {
        updateDeviceList()
        return devices
    }
    
    func setDeviceTimeOut(TimeOutTime: TimeInterval)
    {
        deviceTimeOut = TimeOutTime
    }
    
    func getDeviceTimeOut() -> TimeInterval
    {
        return deviceTimeOut
    }
}


