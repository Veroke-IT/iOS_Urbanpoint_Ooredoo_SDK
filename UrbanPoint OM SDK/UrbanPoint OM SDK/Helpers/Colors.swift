//
//  Colors.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/9/23.
//

import UIKit

struct Colors{
    
  
    
    static var urbanPointRed = fetchColor(named: "UrbanPointRed")
    static var urbanPointGrey = fetchColor(named: "UrbanPointGrey")
    static var urbanPointGreen = fetchColor(named: "UrbanPointGreen")
    
    
    static func fetchColor(named name: String) -> UIColor?{
        UIColor(named: name, in: Appbundle, compatibleWith: nil)
    }

}
