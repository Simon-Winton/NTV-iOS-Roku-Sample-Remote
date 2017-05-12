//
//  NTVDiscoveryManager.swift
//  NowTvRemote
//
//  Created by Winton, Simon (Associate Software Developer) on 30/11/2016.
//  Copyright © 2016 Winton, Simon (Associate Software Developer). All rights reserved.
//

import Foundation

public class DeviceListener: DeviceListenerDelegate
{

    var deviceBucket = DeviceBucket()
    var mSearch: MSearch!
    
    
    public init (timeBetweenBroadcast: TimeInterval)
    {
        deviceBucket = DeviceBucket()
        mSearch = MSearch(deviceBucket: deviceBucket, timeBetweenBroadcast: timeBetweenBroadcast)
    }
    
    public func startBroadcast()
    {
        mSearch.startBroadcast()
    }
    
    public func stopBroadcast()
    {
        mSearch.stopBroadcast()
    }
    
    public func getDevices() -> [RokuDeviceAppModel]
    {
        return deviceBucket.getDevices()
    }
    
    public func connectToDevice(device: RokuDeviceAppModel) -> RemoteController
    {
        let connectedDevice =  NowTvDevice(ipAddress: device.ipAddress!)
        return RemoteController(device: connectedDevice)
    }
}
