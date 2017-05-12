//
//  DeviceManager.swift
//  NowTvSampleRemote
//
//  Created by Winton, Simon (Associate Software Developer) on 17/02/2017.
//  Copyright © 2017 Winton, Simon (Associate Software Developer). All rights reserved.
//

import Foundation
import NowTvRemote

class DeviceManager
{
    var updateTimer: Timer!
    var deviceList = [RokuDevice]()
    var deviceListener : DeviceListener!
    var ConnectedDevice: RokuDevice!
    var isConnected = false
    var remoteControl: RemoteController?
    var delegate:DeviceListUpdatedDelegate!
    
    
    private let CONNECTED_CHECK_TIME:TimeInterval = 2
    private let BROADCAST_TIME_INTERVAL:TimeInterval = 3
    
    class var sharedInstance : DeviceManager
    {
        struct Static
        {
            static let instance: DeviceManager = DeviceManager()
        }
        return Static.instance
    }
    
    func beginBroadcast()
    {
        if( deviceListener == nil)
        {
            deviceListener = DeviceListener(timeBetweenBroadcast: BROADCAST_TIME_INTERVAL)
            deviceListener.delegate = self
            deviceListener.connectionDelegate = self as! ConnectionDelegate
        }
        else
        {
            deviceListener.startBroadcast()
        }
    }
    
    func stopBroadcast()
    {
        deviceListener.stopBroadcast()
    }
    
    func updateDeviceList()
    {
        let rokuDeviceList = deviceListener.getDevices()
        for device in rokuDeviceList
        {
            if !(deviceList.contains(where: {$0.ipAddress == device.ipAddress}))
            {
                deviceList.append(device)
            }
        }
    }
    
    func connectToDevice(device: RokuDevice)
    {
        deviceListener.connectToDevice(rokuDevice: device)
        self.ConnectedDevice = device
        self.updateTimer = Timer.scheduledTimer(timeInterval:CONNECTED_CHECK_TIME, target: self, selector: #selector(checkIfConnected), userInfo: nil, repeats: true)
    }
    
    @objc func checkIfConnected()
    {
        if(self.ConnectedDevice != nil)
        {
            self.ConnectedDevice.testIfLive(delegate: self as DeviceConnectedDelegate)
        }
        else
        {
            self.updateTimer.invalidate()
        }
    }
    
    func disconnectDevice()
    {
        updateTimer.invalidate()
        beginBroadcast()
        deviceList.removeAll()
        deviceList = self.deviceListener.getDevices()
        ConnectedDevice = nil
        isConnected = false
    }
    
}

extension DeviceManager: DeviceListUpdatedDelegate
{
    public func deviceListUpdated()
    {
        self.deviceList = self.deviceListener.getDevices()
        
        NotificationCenter.default.post(name: Notification.Name("DeviceListUpdated"), object: nil)
    }
    
    public func noDevicesFound()
    {
        if(isConnected)
        {
            self.disconnectDevice()
        }
        self.deviceList.removeAll()
    }
}

extension DeviceManager: ConnectionDelegate
{
    public func deviceConnected(remote: RemoteController)
    {
        self.remoteControl = remote
        self.isConnected = true
        stopBroadcast()
        NotificationCenter.default.post(name: Notification.Name("DeviceConnected"), object: nil)
    }
    
    public func deviceNotConnected()
    {
        self.remoteControl = nil
    }
}

extension DeviceManager: DeviceConnectedDelegate
{
    func deviceConnected(device: RokuDevice)
    {
        print("Still Connected")
    }
    
    func deviceNotConnected(device: RokuDevice)
    {
        print("Connection Lost")
        self.disconnectDevice()
        
    }
}
