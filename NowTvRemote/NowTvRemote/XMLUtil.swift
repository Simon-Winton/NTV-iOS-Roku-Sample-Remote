import Foundation


open class XMLUtil
{
    struct DeviceInfoStruct
    {
        var deviceName : String? = nil
        var serialNumber : String? = nil
    }

    enum XMLUtilErrors: Error {
        case nilXMLDoc
        case notWellFormatedXMLDoc
    }
    
    /**
     * Method name: parseXMLDeviceInfo
     * Description: Parses the serial number and user device name from the XML doc recieved from querying device info into a structure
     * Parameters: XML : NSData
     * Returns: DeviceInfoStruct
     */
    func parseXMLDeviceInfo(_ xml : Data!) throws -> DeviceInfoStruct
    {
        var deviceStruct : DeviceInfoStruct = DeviceInfoStruct()
        
        if xml != nil {
            
            let xmlDoc : AEXMLDocument
            
            do {
                xmlDoc = try AEXMLDocument(xml: xml )
            }
            catch
            {
                throw XMLUtilErrors.notWellFormatedXMLDoc
            }
            
            //Parse serial number
            if(xmlDoc.root["serial-number"].value != nil)
            {
                deviceStruct.serialNumber = xmlDoc.root["serial-number"].value!
            }
            
            //Parse user device name if it has been setted
            if xmlDoc.root["user-device-name"].value != nil
            {
                deviceStruct.deviceName = xmlDoc.root["user-device-name"].value!
            }
        }
        else {
            throw XMLUtilErrors.nilXMLDoc
        }
        
        return deviceStruct
    }
    
}

