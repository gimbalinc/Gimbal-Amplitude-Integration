//
//  File.swift
//  hello-gimbal-swift
//
//  Created by Victor Nuñez on 7/11/19.
//

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
        NSLog("Begin %@", visit.place.description)

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
        NSLog("End %@", visit.place.description)
        
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
