//
//  M-Search.swift
//  NowTvRemote
//
//  Created by Winton, Simon (Associate Software Developer) on 21/11/2016.
//  Copyright © 2016 Winton, Simon (Associate Software Developer). All rights reserved.
//

import Foundation

public class RokuDeviceAppModel: NSObject
{
    public var deviceName: String?
    public var ipAddress: String!
    public var serialNumber: String?
    internal var lastConnected: NSDate!
    
    init(deviceName: String?, ipAddress: String!, serialNumber: String){
        self.deviceName = deviceName
        self.ipAddress = ipAddress
        self.serialNumber = serialNumber
        
        
        self.lastConnected = NSDate()
        
    }

}
