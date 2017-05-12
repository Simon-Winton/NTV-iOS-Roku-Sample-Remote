//
//  RemoteControlProtocol.swift
//  NowTvRemote
//
//  Created by Winton, Simon (Associate Software Developer) on 01/12/2016.
//  Copyright © 2016 Winton, Simon (Associate Software Developer). All rights reserved.
//

import Foundation

protocol RemoteControlProtocol
{
    
    func buttonPressed(remoteControlButton: RemoteControlButton)
    
    func sendCustomRequest(url: String)
    


}
