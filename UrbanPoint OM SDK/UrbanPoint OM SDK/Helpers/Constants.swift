//
//  TempConstants.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/10/23.
//

import UIKit


let passwordEncryption = "bhjglyoqck829uf513z4i06xvtmrew7ewojd"

let publicKeyUPEncryptedInternal = "U2FsdGVkX1+O7DnTK8A2llIbswxDjNfDrFVDn885oRSzFNNm2ff50yDkRcufVGpc"
let publicKeyUPEncryptedProduction = "U2FsdGVkX19MlY7evIzyH17oR6wpZx7pw5lsE8VShKkkVb1NAsPD7HIqL5VZ0Lr1"

let environmentEncryptedInternal = "U2FsdGVkX184xoruZhUU33T90KJrfjByBe1z1d4qn4Y="
let environmentEncryptedProduction = "U2FsdGVkX1+mPCbthcaKFK/RD5xrGs2PQIc6MF6GcsY="


enum UPEnvironment{
    case test_up_intrnl
    case live_om_prd
}

enum UrbanPointLanguage: String{
    case english = "english"
    case arabic = "arabic"
}

let Appbundle = Bundle(identifier: "com.UrbanPoint-OM-SDK")
var appEnvironment: UPEnvironment? = nil
let appID: String = "1"


var baseURL: String{
    get{
        switch appEnvironment {
        case .test_up_intrnl:
            return "http://ooredoo-sdk-internal.adminurban.com/api/"
        case .live_om_prd:
            return "http://ooredoo-sdk-internal.adminurban.com/api/"
        default:
            return ""
        }
    }
}

let guestAuthToken: String = "UP!and$"
let authTokenKey = "UPAuthToken"
var UPUserAuthToken: String?{
    get{
        UserDefaults.standard.string(forKey: authTokenKey)
    }
    set{
        UserDefaults.standard.set(newValue, forKey: authTokenKey)
    }
}


let imageBaseURL = "https://urbanpoint-storage.azureedge.net/test/uploads_staging/uploads/"
let termsAndServiceURL = "https://urbanpoint.com/terms-of-service"

let placeHolderImage = UIImage.loadImageWithName("placeholder")

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
