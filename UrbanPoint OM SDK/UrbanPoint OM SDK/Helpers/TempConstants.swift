//
//  TempConstants.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/10/23.
//

import UIKit


let imageBaseURL = "https://urbanpoint-storage.azureedge.net/test/uploads_staging/uploads/"
let Appbundle = Bundle(identifier: "com.UrbanPoint-OM-SDK")
let termsAndServiceURL = "https://urbanpoint.com/terms-of-service"
let placeHolderImage = UIImage.loadImageWithName("PlaceHolder")

enum UrbanPointLanguage: String{
    case english = "english"
    case arabic = "arabic"
}

var appLanguage: UrbanPointLanguage? {
    set{
        UserDefaults.standard.set(newValue?.rawValue ?? UrbanPointLanguage.english, forKey: "UP_LANGUAGE")
    }
    get{
        if let appLanguage = UserDefaults.standard.value(forKey: "UP_LANGUAGE") as? String{
            return UrbanPointLanguage(rawValue: appLanguage)
        }else{
            return .english
        }
    }
}
