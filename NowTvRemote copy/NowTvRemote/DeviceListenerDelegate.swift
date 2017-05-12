//
//  DeviceListenerDelegate.swift
//  NowTvRemote
//
//  Created by Winton, Simon (Associate Software Developer) on 01/12/2016.
//  Copyright © 2016 Winton, Simon (Associate Software Developer). All rights reserved.
//

import Foundation

internal protocol DeviceListenerDelegate
{

    func startBroadcast()
    
    func stopBroadcast()
    
    func getDevices() -> [RokuDeviceAppModel]
    
    func connectToDevice(device: RokuDeviceAppModel) -> RemoteController
    
}
