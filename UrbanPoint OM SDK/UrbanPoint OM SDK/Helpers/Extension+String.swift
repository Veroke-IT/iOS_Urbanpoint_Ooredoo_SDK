//
//  Extension+String.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/17/23.
//

import Foundation

extension String{
    func getNumberWithoutDecimal() -> String{
         let floatRepresentation = Float(self)
         return floatRepresentation?.clean ?? ""
     }
    
    var localized: String{
        return self
    }
}
extension Float {
       var clean: String {
          return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
       }
   }
extension Double {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
