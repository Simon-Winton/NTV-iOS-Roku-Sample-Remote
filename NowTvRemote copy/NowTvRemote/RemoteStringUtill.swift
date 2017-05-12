//
//  Util.swift
//  RokuRemoteApp
//
//  Created by Thompson, Louis (Associate Software Developer) on 17/08/2016.
//  Copyright © 2016 Thuringer, Nicholas (Associate Software Developer). All rights reserved.
//

import Foundation


internal class RemoteStringUtil
{

    // Takes a String and, if it exists, extracts the location IP and returns it.
    internal func extractURLFromResponse(_ text: String) -> String? {
        
        let validIpAddressRegex = "http://(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}:([0-9]{4}/)"
        
        do
        {
            let regex = try NSRegularExpression(pattern: validIpAddressRegex, options: [])
            let nsString = text as NSString
            let result = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, nsString.length))
           
            // Check that result is not nil.
            if result != nil
            {
                return nsString.substring(with: result!.range)
            }
        }
        
        catch let error as NSError
        {
            print("invalid regex: \(error.localizedDescription)")
            return nil
        }
        
        // If there was no IP in the input string, return nil.
        return nil
    }
}
