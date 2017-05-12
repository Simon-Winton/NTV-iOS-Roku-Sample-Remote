//
//  RokuHandlerDeviceInfoDelegate.swift
//  RokuRemoteApp
//
//  Created by Thuringer, Nicholas (Associate Software Developer) on 21/09/2016.
//  Copyright © 2016 Thuringer, Nicholas (Associate Software Developer). All rights reserved.
//

import Foundation

protocol RokuHandlerDeviceInfoDelegate
{
    func didReceiveDeviceInfo(data: Data, ip: String)
}
