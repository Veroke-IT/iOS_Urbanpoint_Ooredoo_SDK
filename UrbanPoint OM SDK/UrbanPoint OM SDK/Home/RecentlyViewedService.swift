//
//  RecentlyViewedService.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/17/23.
//

import Foundation

protocol RecentlyViewedOutletEventDelegate{
    func saveOutlet(outletName: String,outletID: Int,outletLogoURL: String)
    func deleteOutletIfExists(outletID: Int)
}


class UserDefaultsRecentlyViewedOutletWrapper: RecentlyViewedOutletEventDelegate{

    private let session: UserDefaults
    static var sharedInstance = UserDefaultsRecentlyViewedOutletWrapper()
    private let keyIdentifier = "RecentlyViewedOutlets"
    
    private init(){
        self.session = UserDefaults.standard
    }
    
    func saveOutlet(outletName: String, outletID: Int, outletLogoURL: String) {
       
        let recentlyViewedOutlet = RecentlyViewedOutlet(id: outletID, outletName: outletName, outletLogoURL: outletLogoURL)
        saveOutletToUserDefaultIfAlreadyNotThere(recentlyViewedOutlet)
    }
    
    private func saveOutletToUserDefaultIfAlreadyNotThere(_ outlet: RecentlyViewedOutlet){
        
        var alreadySavedOutlets = deleteOutletFromList(outlet.id)
        if alreadySavedOutlets.count < 10{
            alreadySavedOutlets.insert(outlet, at: 0)
        }else{
            alreadySavedOutlets.removeLast()
            alreadySavedOutlets.insert(outlet, at: 0)
        }
        UserDefaults.standard.set(try? PropertyListEncoder().encode(alreadySavedOutlets), forKey:keyIdentifier)
    }
    
    func getRecentlyViewedOutlet() -> [RecentlyViewedOutlet]{
        if let data = UserDefaults.standard.value(forKey:keyIdentifier) as? Data,
           let outlets = try? PropertyListDecoder().decode(Array<RecentlyViewedOutlet>.self, from: data)
        {
            
            return outlets
        }
        
        return []
    }
    
    private func deleteOutletFromList(_ outletID: Int) -> [RecentlyViewedOutlet]{
        var alreadySavedOutlets = getRecentlyViewedOutlet()
        if let alreadyExistingIndex = alreadySavedOutlets.firstIndex(where: { $0.id == outletID }){
            alreadySavedOutlets.remove(at: alreadyExistingIndex)
        }
        return alreadySavedOutlets
    }
    
    func deleteOutletIfExists(outletID: Int){
        let outlets = deleteOutletFromList(outletID)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(outlets), forKey:keyIdentifier)
    }

    func clearUserDefaults(){
        UserDefaults.standard.removeObject(forKey: keyIdentifier)
    }
}


