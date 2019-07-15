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
- In GimbalAmplitudeAdapter.swift call: `GimbalAmplitudeAdapter.shared.start(gimbalApiKey: "ADD GIMBAL API KEY HERE", ampltiudeApiKey: "ADD AMPLITUDE API KEY HERE")`
- fill your API KEY for both Gimbal and Amplitude

Full Gimbal Docs [http://docs.gimbal.com/](http://docs.gimbal.com/)
Full Amplitude Docs [https://developers.amplitude.com/](https://developers.amplitude.com/)

```swift
import Amplitude_iOS

open class GimbalAmplitudeAdapter {

/**
* Singleton access.
*/
public static let shared = GimbalAmplitudeAdapter()


/**
* Receives forwarded callbacks from the GMBLPlaceManagerDelegate
*/
open var delegate: GMBLPlaceManagerDelegate?

/**
* Returns true if the adapter is started, otherwise false.
*/
open var isStarted: Bool {
    get {
        return Gimbal.isStarted()
    }
}

private let placeManager: GMBLPlaceManager
private let gimbalDelegate: GimbalDelegate

private init() {
    placeManager = GMBLPlaceManager()
    gimbalDelegate = GimbalDelegate()
    placeManager.delegate = gimbalDelegate
}

/**
* Starts the adapter.
* @param apiKey The Gimbal API key.
*/
func start(gimbalApiKey: String?, ampltiudeApiKey: String?) {
    Gimbal.setAPIKey(gimbalApiKey, options: nil)
    Gimbal.start()

    Amplitude.instance()?.trackingSessionEvents = true
    Amplitude.instance()?.initializeApiKey(ampltiudeApiKey)

    print("Started Gimbal Adapter. Gimbal application instance identifier: \(String(describing: Gimbal.applicationInstanceIdentifier()))")
}

/**
* Stops the adapter.
*/
func stop() {
    Gimbal.stop()
    print("Stopped Gimbal Adapter");
}
}

private class GimbalDelegate : NSObject, GMBLPlaceManagerDelegate {
private let source: String = "Gimbal"

func placeManager(_ manager: GMBLPlaceManager, didBegin visit: GMBLVisit) {
    print("Begin %@", visit.place.description)

    let eventProperties : [String: Any] = [
    "Place ID": visit.place.identifier!,
    "Place Name": visit.place.name!,
    "Place Attributes": visit.place.attributes!,
    "Arrival Date": visit.arrivalDate!,
    "Departure Date": "Still visiting",
    "Place Dwell Time": visit.dwellTime
]

Amplitude.instance()?.logEvent("New Place Entered", withEventProperties: eventProperties)
GimbalAmplitudeAdapter.shared.delegate?.placeManager?(manager, didBegin: visit)
}

func placeManager(_ manager: GMBLPlaceManager!, didBegin visit: GMBLVisit!, withDelay delayTime: TimeInterval) {
    GimbalAmplitudeAdapter.shared.delegate?.placeManager?(manager, didBegin: visit, withDelay: delayTime)
}

func placeManager(_ manager: GMBLPlaceManager, didEnd visit: GMBLVisit) {
    print("End %@", visit.place.description)

    let eventProperties : [AnyHashable: Any] = [
        "Place ID": visit.place.identifier!,
        "Place Name": visit.place.name!,
        "Place Attributes": visit.place.attributes!,
        "Arrival Date": visit.arrivalDate!,
        "Departure Date": visit.departureDate!,
        "Place Dwell Time": visit.dwellTime
    ]
    Amplitude.instance()?.logEvent("Place Exited", withEventProperties: eventProperties)

    GimbalAmplitudeAdapter.shared.delegate?.placeManager?(manager, didEnd: visit)
}

func placeManager(_ manager: GMBLPlaceManager!, didReceive sighting: GMBLBeaconSighting!, forVisits visits: [Any]!) {
    GimbalAmplitudeAdapter.shared.delegate?.placeManager?(manager, didReceive: sighting, forVisits: visits)
}

func placeManager(_ manager: GMBLPlaceManager!, didDetect location: CLLocation!) {
    GimbalAmplitudeAdapter.shared.delegate?.placeManager?(manager, didDetect: location)
}

}
