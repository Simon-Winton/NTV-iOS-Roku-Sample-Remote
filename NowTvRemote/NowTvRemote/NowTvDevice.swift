//
//  connectedDevice.swift
//  RokuRemote
//
//  Created by Winton, Simon (Associate Software Developer) on 17/11/2016.
//  Copyright © 2016 Winton, Simon (Associate Software Developer). All rights reserved.
//

import Foundation

public class NowTvDevice
{
    public var deviceName: String?
    public var ipAddress: String!
    public var serialNumber: String?
    
    var stringUtil = RemoteStringUtil()
    
    init(ipAddress:String)
    {
        self.ipAddress = ipAddress
    }
    
    /**
     * Method name: remoteControlHttpRequest
     * Description: Takes in RemoteControlButton which is an Enum, i.e RemoteControlButton.up and makes a post request
     * Parameters: remoteControlButton: RemoteControlButton
     */
    func remoteControlHttpRequest(remoteControlButton: RemoteControlButton)
    {
        let url = ipAddress + remoteControlButton.rawValue
        print(url)
        sendAsyncPostRequest(url: url)
    }
    
    /**
     * Method name: sendAsyncPostRequest
     * Description: sends Asynchornous POST request
     * Parameters: url: String
     */
    func sendAsyncPostRequest(url: String)
    {
        request(url, method: .post)
    }
    
    func getDeviceInfo(delegate: RokuHandlerDeviceInfoDelegate)
    {
        let deviceInfoPath = "query/device-info"
        let url = ipAddress + deviceInfoPath
        sendAsyncGetRequest(url: url)
        {
            (response: DataResponse<Data>) in
            
            if let deviceIp = self.stringUtil.extractURLFromResponse((response.response!.url?.absoluteString)!)
            {
                delegate.didReceiveDeviceInfo(data: response.data!, ip: deviceIp)
            }
        }
    }
    
    
    /**
     * Method name: sendAsyncGetRequest
     * Description: Function to send Asynchronous GET request with optional headers
     * Parameters: url: String, headers: HTTPHeaders (default is nil)
     */
    func sendAsyncGetRequest(url: String, headers: HTTPHeaders?=nil, completion: @escaping (_ response: DataResponse<Data>) -> Void)
    {
        request(url, method: .get, headers: headers).responseData
            {
                response in
                
                if(response.result.isSuccess && response.data != nil)
                {
                    completion(response)
                    //delegate.didReceiveSearchByUriForMoviesResponse!(response.data!)
                }
        }
    }
}
