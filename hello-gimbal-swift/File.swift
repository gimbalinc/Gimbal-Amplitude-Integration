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
    
    // Keys
    private let placeManager: GMBLPlaceManager
//    private let gimbalDelegate: GimbalDelegate
    private let deviceAttributesManager: GMBLDeviceAttributesManager
    
    private init() {
        placeManager = GMBLPlaceManager()
//        gimbalDelegate = GimbalDelegate()
        deviceAttributesManager = GMBLDeviceAttributesManager()
//        placeManager.delegate = gimbalDelegate
    
    /**
     * Restores the adapter. Should be called in didFinishLaunchingWithOptions.
     */
    func restore() {
        updateDeviceAttributes()
    }
    
    /**
     * Starts the adapter.
     * @param apiKey The Gimbal API key.
     */
        func start(_ gimbalApiKey: String?, _ ampltiudeApiKey: String?) {
        Gimbal.setAPIKey(gimbalApiKey, options: nil)
        Amplitude.instance()?.initializeApiKey(ampltiudeApiKey)
        Gimbal.start()
        updateDeviceAttributes()
    }
    
    /**
     * Stops the adapter.
     */
    func stop() {
        Gimbal.stop()
    }
    
    func updateDeviceAttributes() {
        var deviceAttributes = Dictionary<AnyHashable, Any>()
        
        if (deviceAttributesManager.getDeviceAttributes() != nil && deviceAttributesManager.getDeviceAttributes().count > 0) {
            for (key,val) in deviceAttributesManager.getDeviceAttributes() {
                deviceAttributes[key] = val
            }
    }
        
//        if (UAirship.namedUser().identifier != nil) {
//            deviceAttributes["ua.nameduser.id"] = UAirship.namedUser().identifier
//        }
//
//        if (UAirship.push().channelID != nil) {
//            deviceAttributes["ua.channel.id"] = UAirship.push().channelID
//        }
//
//        if (deviceAttributes.count > 0) {
//            deviceAttributesManager.setDeviceAttributes(deviceAttributes)
//        }
//
//        let identifiers = UAirship.shared().analytics.currentAssociatedDeviceIdentifiers()
//        identifiers.setIdentifier(Gimbal.applicationInstanceIdentifier(), forKey: "com.urbanairship.gimbal.aii")
//        UAirship.shared().analytics.associateDeviceIdentifiers(identifiers);
    }
}

//private class GimbalDelegate : NSObject, GMBLPlaceManagerDelegate {
//    private let source: String = "Gimbal"
//
//    func placeManager(_ manager: GMBLPlaceManager, didBegin visit: GMBLVisit) {
//        GimbalAmplitudeAdapter.shared.delegate?.placeManager?(manager, didBegin: visit)
//        let eventProperties : [AnyHashable: Any] = [
//            visit.place.identifier: "Place ID",
//            visit.place.name : "Place Name",
//            visit.dwellTime : "Place Dwell Time"
//            ]
//        Amplitude.instance()?.logEvent("New Place Entered", withEventProperties: eventProperties)
//    }
//
//    func placeManager(_ manager: GMBLPlaceManager!, didBegin visit: GMBLVisit!, withDelay delayTime: TimeInterval) {
//        GimbalAmplitudeAdapter.shared.delegate?.placeManager?(manager, didBegin: visit, withDelay: delayTime)
//    }
//
//    func placeManager(_ manager: GMBLPlaceManager, didEnd visit: GMBLVisit) {
//        let regionEvent: UARegionEvent = UARegionEvent(regionID: visit.place.identifier, source: source, boundaryEvent: .exit)!
//        UAirship.shared().analytics.add(regionEvent)
//        GimbalAmplitudeAdapter.shared.delegate?.placeManager?(manager, didEnd: visit)
//    }
//
//    func placeManager(_ manager: GMBLPlaceManager!, didReceive sighting: GMBLBeaconSighting!, forVisits visits: [Any]!) {
//        GimbalAmplitudeAdapter.shared.delegate?.placeManager?(manager, didReceive: sighting, forVisits: visits)
//    }
//
//    func placeManager(_ manager: GMBLPlaceManager!, didDetect location: CLLocation!) {
//        GimbalAmplitudeAdapter.shared.delegate?.placeManager?(manager, didDetect: location)
//    }
}
