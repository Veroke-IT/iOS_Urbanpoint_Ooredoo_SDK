//
//  UPSettingsViewController.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/17/23.
//

import UIKit

class UPSettingsViewController: UIViewController {

    @IBOutlet weak var daysOfAccessRemaining: UILabel!
    @IBOutlet weak var englishLanguageLabel: UILabel!
    @IBOutlet weak var arabicLanguageLabel: UILabel!
    @IBOutlet weak var languageSwitch: UISwitch!
    
    /// Events
    var onBack: (() -> Void)?
    var onGoBackToOoreddo: (() -> Void)?
    var showTermsAndConditions: (() -> Void)?
    var showUsedOffers: (() -> Void)?
    var onSwitchMoved: ((Bool) -> Void)?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languageSwitch.isOn = appLanguage == .english
    }

    @IBAction func onUsedOffersTapped(_ sender: Any){
        showUsedOffers?()
    }
    
    @IBAction func onTermsAndConditionTapped(_ sender: Any){
        showTermsAndConditions?()
    }

    
    @IBAction func onSwitchChanged(_ sender:Any){
        
        onSwitchMoved?((sender as? UISwitch)?.isOn ?? false)
    }
    
    @IBAction func onGoBackToOoredooTapped(_ sender: Any){
        onGoBackToOoreddo?()
    }
    @IBAction func onBackButtonTapped(_ sender: Any){
        onBack?()
    }
}
