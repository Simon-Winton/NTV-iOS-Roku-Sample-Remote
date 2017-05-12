//
//  TableViewController.swift
//  NowTvSampleRemote
//
//  Created by Winton, Simon (Associate Software Developer) on 28/11/2016.
//  Copyright © 2016 Winton, Simon (Associate Software Developer). All rights reserved.
//

import UIKit
import NowTvRemote

class DeviceSelectionTableViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource
{
    var devices = [RokuDevice]()
    var deviceManager = DeviceManager.sharedInstance

    
    @IBOutlet weak var deviceTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //start broadcasting over network for devices
        self.deviceManager.beginBroadcast()
        
        
        deviceTableView.delegate = self
        deviceTableView.dataSource = self
        
        
        //observer for updates in the device list
        NotificationCenter.default.addObserver( self,
                                                selector: #selector(self.update),
                                                name: NSNotification.Name(rawValue: "DeviceListUpdated"),
                                                object: nil)
        
        //observer for updates in the device list
        NotificationCenter.default.addObserver( self,
                                                selector: #selector(self.goToRemote),
                                                name: NSNotification.Name(rawValue: "DeviceConnected"),
                                                object: nil)
    }

    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }


    // MARK: - Table Cell Functions
    
    func update()
    {
        DispatchQueue.main.async(execute: {
            self.devices = self.deviceManager.deviceList
            self.refresh(sender: self.deviceTableView)
        })
    }

    func refresh(sender:AnyObject)
    {
        DispatchQueue.main.async(execute: {
            
            self.deviceTableView.reloadData()
            if #available(iOS 10.0, *) {
                self.deviceTableView.refreshControl?.endRefreshing()
            } else {
                // Fallback on earlier versions
            }
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell( withIdentifier: "DeviceTableViewCell", for: indexPath) as! DeviceTableViewCell
        
        cell.titleLbl.text = "Serial Number:"
        cell.DeviceSNLbl.text = "\(self.devices[(indexPath as NSIndexPath).row].serialNumber!)"
        
        
        return cell
    }
    
    // MARK: - Navigation
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let row = indexPath.row

        self.deviceManager.connectToDevice(device: self.devices[row])
        
    }
    
    func goToRemote()
    {

        
        let remoteViewController = self.storyboard?.instantiateViewController(withIdentifier: "RemoteViewController") as! RemoteViewController
        remoteViewController.remoteController = RemoteController(device: deviceManager.ConnectedDevice)
        self.present(remoteViewController, animated: true, completion: nil)
    }
    
    
}
