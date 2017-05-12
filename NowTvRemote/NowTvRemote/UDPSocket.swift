
import Foundation
import CocoaAsyncSocket

class UDPSocket : GCDAsyncUdpSocket, SocketConnectionProtocol, GCDAsyncUdpSocketDelegate
{
    //m-search request URI for discovering roku devices in the network
    let mSearchString: Data = "M-SEARCH * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nMAN: \"ssdp:discover\"\r\nMX: 3\r\nST: roku:ecp\r\nUSER-AGENT: iOS UPnP/1.1 TestApp/1.0\r\n\r\n".data(using: String.Encoding.utf8)!
    let broadcastAddress: String = "239.255.255.250"
    let broadcastPort: UInt16 = 1900
    let stringUtil = RemoteStringUtil()
    var udpSocket = GCDAsyncUdpSocket()
    var mSearchResponseDelegate: UDPSocketDelegate!
    
    
    
    
    init(delegate: UDPSocketDelegate)
    {
        mSearchResponseDelegate = delegate
        super.init(delegate: nil, delegateQueue: nil, socketQueue: nil)
        
        
    }
    
    /* broadCast
        Closes any open socket and sends out a m-search broadcast to find all roku devices on the same network
        Prepares the socket for recieving data if the m-search is succesful
    */
    func broadcast()
    {
        if(!udpSocket.isClosed()){
            self.closeSocket()
        }
        
        udpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
        
        udpSocket.send(mSearchString, toHost: broadcastAddress, port: broadcastPort, withTimeout: 20, tag: 0)
        
        do{
            try udpSocket.bind(toPort: broadcastPort)
            try udpSocket.joinMulticastGroup(broadcastAddress)
            try udpSocket.beginReceiving()
            print("Broadcast")
        }
        catch {
            print("Box Not Found")
        }
    }

    /* closeSocket
          Closes any open connections
    */
    
    func closeSocket()
    {
        udpSocket.close()
        
    }
    
    
    // MARK: Callbacks
    
    open func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?)
    {
        let dataStr = String(data: data, encoding: String.Encoding.utf8)
        
        if let str = dataStr
        {
            if (str.contains("roku"))
            {
                let optionalCleanIP = stringUtil.extractURLFromResponse(str)
                
                if let cleanIP = optionalCleanIP
                {
                    mSearchResponseDelegate.didReceiveMSearchResponse(cleanIP)
                }
            }
        }
    }
    
    
    // If the broadcast fails send the data again.
    open func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?)
    {
        print("Failed, sending broadcast again...\n")
        udpSocket.send(mSearchString, toHost: broadcastAddress, port: broadcastPort, withTimeout: 3, tag: 0)
    }

}
