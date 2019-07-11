# Gimbal+Amplitude Adapter
Integration Example on iOS written in Swift. This integration works as a drop-in class that starts both SDKs and logs location events in Amplitude as they occur in the Gimbal SDK.

## Before you create your iOS application
Using the **Gimbal Manager**:
[https://manager.gimbal.com/](https://manager.gimbal.com/)
- create your Gimbal account 
- create an **Application** and assign a bundle ID (generates you API KEY)
- create at least one **Place** (using a Beacon or Geofence) you can buy Beacons here [http://store.gimbal.com/](http://store.gimbal.com/)
- download the latest V2 SDK

## Installing Gimbal & Amplitude Dependencies
We use cocoapods to manage dependencies [https://cocoapods.org/](https://cocoapods.org)
- run the command **sudo gem install cocoapods** (if you do not already have cocoapods installed)
- cd to the directory where you have cloned this project
- configure your pod file by adding 'pod Gimbal' and pod 'Amplitude-iOS', '~> 4.0.4'
- run the command **pod install**
- open the **.xcworkspace** project file (not the .xcodeproj file)

## Starting the adapter
- Add GimbalAmplitudeAdapter.swift to your project
- In GimbalAmplitudeAdapter.swift call: `GimbalAmplitudeAdapter.shared.start(gimbalApiKey: "INSERT API KEY HERE", amplitudeApiKey: "INSERT API KEY HERE")`
- fill your API KEY for both Gimbal and Amplitude
- In .AppDelegate, call `restore` during `didFinishLaunchingWithOptions`:

```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {

   GimbalAdapter.shared.restore()

   ...
}
```

Full Gimbal Docs [http://docs.gimbal.com/](http://docs.gimbal.com/)

```swift
import UIKit

class ViewController: UITableViewController, GMBLPlaceManagerDelegate {
    
    var placeManager: GMBLPlaceManager!
    var placeEvents : [GMBLVisit] = []
    
    override func viewDidLoad() -> Void {
        Gimbal.setAPIKey("PUT_YOUR_GIMBAL_API_KEY_HERE", options: nil)
        
        placeManager = GMBLPlaceManager()
        self.placeManager.delegate = self

        communicationManager = GMBLCommunicationManager()
        self.communicationManager.delegate = self

        Gimbal.start()
    }
    
    func placeManager(manager: GMBLPlaceManager!, didBeginVisit visit: GMBLVisit!) -> Void {
        NSLog("Begin %@", visit.place.description)
        self.placeEvents.insert(visit, atIndex: 0)
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation:UITableViewRowAnimation.Automatic)
    }
    
    func placeManager(manager: GMBLPlaceManager!, didEndVisit visit: GMBLVisit!) -> Void {
        NSLog("End %@", visit.place.description)
        self.placeEvents.insert(visit, atIndex: 0)
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: NSInteger) -> NSInteger {
        return self.placeEvents.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        var visit: GMBLVisit = self.placeEvents[indexPath.row]
        
        if (visit.departureDate == nil) {
            cell.textLabel!.text = NSString(format: "Begin: %@", visit.place.name) as String
            cell.detailTextLabel!.text = NSDateFormatter.localizedStringFromDate(visit.arrivalDate, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.MediumStyle)
        }
        else {
            cell.textLabel!.text = NSString(format: "End: %@", visit.place.name) as String
            cell.detailTextLabel!.text = NSDateFormatter.localizedStringFromDate(visit.arrivalDate, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.MediumStyle)
        }
        
        return cell
    }
}
