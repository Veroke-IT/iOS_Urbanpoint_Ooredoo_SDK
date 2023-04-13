//
//  LocationManager.swift
//  Manqoosha
//
//  Created by Pasha on 20/06/2018.
//  Copyright © 2018 Andpercent. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol UPLocationManagerDelegate {
    func tracingLocation(currentLocation: CLLocation)
    func tracingLocationDidFailWithError(error: NSError)
}


class UPLocationManager: NSObject, CLLocationManagerDelegate {
    
    typealias UPUserLocation = (CLLocation?) -> ()
    static let sharedInstance: UPLocationManager = {
        let instance = UPLocationManager()
        return instance
    }()
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?{
        didSet
        {
         
        }
    }
   static var userLocation: CLLocation?
    var delegate: UPLocationManagerDelegate?
    
    override init()
    {
        super.init()
        
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }
        
//      if CLLocationManager.authorizationStatus() == .notDetermined {
//                // you have 2 choice
//                // 1. requestAlwaysAuthorization
//                // 2. requestWhenInUseAuthorization
//                locationManager.requestWhenInUseAuthorization()
//            }
//
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest // The accuracy of the location data
//            locationManager.distanceFilter = 200
//        // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
//        locationManager.delegate = self
        self.initialize()
    }
    func initialize()
    {
        if (UserDefaults.standard.object(forKey: "USERLOCATION") != nil) {
            
            
        let data:NSData = UserDefaults.standard.object(forKey: "USERLOCATION") as! NSData
            UPLocationManager.userLocation=NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? CLLocation
            }
    }
    
    func setUserLocation(_ userLocation: CLLocation)
    {
        //Update Location In CleverTap
        UPLocationManager.userLocation=userLocation
        let data:NSData = NSKeyedArchiver.archivedData(withRootObject: userLocation) as NSData
        UserDefaults.standard.set(data, forKey: "USERLOCATION")
        
    }
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            // you have 2 choice
            // 1. requestAlwaysAuthorization
            // 2. requestWhenInUseAuthorization
            locationManager.requestWhenInUseAuthorization()
        }
        else
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            locationManager.requestAlwaysAuthorization()
        }
            
        else
        if  CLLocationManager.authorizationStatus() == .restricted ||  CLLocationManager.authorizationStatus() == .denied {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
        else
        {
            
        }
                   
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // The accuracy of the location data
        locationManager.distanceFilter = 200
        // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
        locationManager.delegate = self
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
    
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        
        // singleton for get last(current) location
        currentLocation = location
        
        // use for real time update location
        setUserLocation(location)
        updateLocation(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        // do on error
        updateLocationDidFailWithError(error as NSError)
    }
    
    
    
    // Private function
    fileprivate func updateLocation(_ currentLocation: CLLocation){
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocation(currentLocation: currentLocation)
    }
    
    fileprivate func updateLocationDidFailWithError(_ error: NSError) {
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocationDidFailWithError(error: error)
    }
    
    
    
    //MARK:- Get Location
    func getLocation(location : @escaping UPUserLocation)
    {
        
    }
    //MARK:- check Location Permission Services
    
    func getDeviceLocationPermissionStatus() -> String
    {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                       return "notDetermined"
                case .restricted, .denied:
                    return "NoAccess"
                case .authorizedAlways, .authorizedWhenInUse:
                    return "Access"
                @unknown default:
                     return "NoAccess"
            }
            } else {
                return "disable"
            }
        
    }
    //MARK:-
    
    func getCurrentCountryCode() -> String
    {
        if let currentCountryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            print(currentCountryCode)
             return currentCountryCode
        }
        else
        {
            return ""
        }
       
    }
    func getCurrentRegionCode() -> String
    {
        if let currentRegionCode = Locale.current.regionCode {
                   print(currentRegionCode)
                    return currentRegionCode
               }
               else
               {
                   return ""
               }
    }
}
