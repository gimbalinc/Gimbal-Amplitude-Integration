import UIKit
import Amplitude_iOS

let project = Amplitude.instance()

class ViewController: UITableViewController, GMBLPlaceManagerDelegate, GMBLCommunicationManagerDelegate {
    
    var communicationManager: GMBLCommunicationManager!
    var placeEvents : [GMBLVisit] = []
    
    override func viewDidLoad() -> Void {
        
        communicationManager = GMBLCommunicationManager()
        self.communicationManager.delegate = self
        
        GimbalAmplitudeAdapter.shared.delegate = self
        GimbalAmplitudeAdapter.shared.start(gimbalApiKey: "ADD GIMBAL API KEY HERE", ampltiudeApiKey: "ADD AMPLITUDE API KEY HERE")

    }
    
    func placeManager(_ manager: GMBLPlaceManager!, didBegin visit: GMBLVisit!) -> Void {
        self.placeEvents.insert(visit, at: 0)
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with:UITableView.RowAnimation.automatic)
    }
    
    func placeManager(_ manager: GMBLPlaceManager!, didEnd visit: GMBLVisit!) -> Void {
        self.placeEvents.insert(visit, at: 0)
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.automatic)
    }
    
    func communicationManager(_ manager: GMBLCommunicationManager!, presentLocalNotificationsForCommunications communications: [Any]!, for visit: GMBLVisit!) -> [Any]! {
        return communications
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: NSInteger) -> NSInteger {
        return self.placeEvents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let visit: GMBLVisit = self.placeEvents[indexPath.row]
        
        if (visit.departureDate == nil) {
            cell.textLabel!.text = NSString(format: "Begin: %@", visit.place.name) as String
            cell.detailTextLabel!.text = DateFormatter.localizedString(from: visit.arrivalDate, dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.medium)
        }
        else {
            cell.textLabel!.text = NSString(format: "End: %@", visit.place.name) as String
            cell.detailTextLabel!.text = DateFormatter.localizedString(from: visit.departureDate, dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.medium)
        }
        
        return cell
    }
}
