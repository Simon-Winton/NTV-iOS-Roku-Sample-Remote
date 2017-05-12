//
//  M-Search.swift
//  NowTvRemote
//
//  Created by Winton, Simon (Associate Software Developer) on 21/11/2016.
//  Copyright © 2016 Winton, Simon (Associate Software Developer). All rights reserved.
//

import Foundation

internal class MSearch: RokuHandlerDeviceInfoDelegate, UDPSocketDelegate
{
    var udpSocket: UDPSocket!
    var deviceBucket: DeviceBucket!
    var UDPDelegate: UDPResponceDelegate!
    var broadcastTimer: Timer!
    var timeBetweenBroadcast: TimeInterval!
    
    init(deviceBucket : DeviceBucket, timeBetweenBroadcast: TimeInterval)
    {
        self.udpSocket = UDPSocket(delegate: self as UDPSocketDelegate)
        self.deviceBucket = deviceBucket
        
        self.timeBetweenBroadcast = timeBetweenBroadcast
        startBroadcast()
        
    }
    
    func didReceiveDeviceInfo(data: Data, ip: String)
    {
        let result = try! XMLUtil().parseXMLDeviceInfo(data)
        
        let tempDevice = RokuDeviceAppModel(deviceName: result.deviceName, ipAddress: ip, serialNumber: result.serialNumber!)
        deviceBucket.addDevice(newDev: tempDevice)
        
    }
    
    internal func stopBroadcast()
    {
        self.broadcastTimer.invalidate()
        udpSocket.closeSocket()
    }
    
    internal func didReceiveMSearchResponse(_ dataStr: String)
    {
        let NTVDev = NowTvDevice(ipAddress: dataStr)
        NTVDev.getDeviceInfo(delegate: self)
    }
    
    
    
    @objc func broadcast()
    {
        udpSocket.broadcast()
    }
    
    func startBroadcast()
    {
        broadcast()
        self.broadcastTimer = Timer.scheduledTimer(timeInterval: self.timeBetweenBroadcast, target: self, selector: #selector(self.broadcast), userInfo: nil, repeats: true)
    }

}
