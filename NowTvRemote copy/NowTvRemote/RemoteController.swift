//
//  RemoteControls.swift
//  RokuRemote
//
//  Created by Winton, Simon (Associate Software Developer) on 17/11/2016.
//  Copyright © 2016 Winton, Simon (Associate Software Developer). All rights reserved.
//

import Foundation


public class RemoteController: RemoteControlProtocol
{

    var connectedDevice: NowTvDevice
    public var baseURL: String!
    
    public init (device: NowTvDevice)
    {
        connectedDevice = device
        baseURL = device.ipAddress
    }
    
    public func buttonPressed(remoteControlButton: RemoteControlButton)
    {
        connectedDevice.remoteControlHttpRequest(remoteControlButton: remoteControlButton)
    }
    
    public func sendCustomRequest(url: String)
    {
        connectedDevice.sendAsyncPostRequest(url: url)
    }
    
    
}
