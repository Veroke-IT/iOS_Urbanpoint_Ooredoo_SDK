//
//  FontLoader.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 5/8/23.
//

import UIKit

public class FontLoader {
    static public func loadFont(name: String,fontExtension: String) {
        
        if let fontUrl = Bundle(for: FontLoader.self).url(forResource: name, withExtension: fontExtension),
           let dataProvider = CGDataProvider(url: fontUrl as CFURL),
           let newFont = CGFont(dataProvider)
        {
            var error: Unmanaged<CFError>?
            if !CTFontManagerRegisterGraphicsFont(newFont, &error)
                {
                    print("Error loading Font!")
            } else {
                print("Loaded font")
            }
        } else {
            assertionFailure("Error loading font")
        }
    }
}
