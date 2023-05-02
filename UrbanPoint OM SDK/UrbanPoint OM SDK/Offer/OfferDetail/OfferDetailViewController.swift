//
//  OfferDetailViewController.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/4/23.
//

import UIKit

class OfferDetailViewController: UIViewController {

    @IBOutlet weak var outletNameLabel: UILabel!
    @IBOutlet weak var offerNameLabel: UILabel!
    @IBOutlet weak var offerDetailLabel: UILabel!
    @IBOutlet weak var detailExclusionLabel: UILabel!
    @IBOutlet weak var expiryDateLabel: UILabel!
    @IBOutlet weak var savingLabel: UILabel!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var outletSubnameLabel: UILabel!
    @IBOutlet weak var ruleOfPurchaseLabel: UILabel!
    
    var offerDetailViewModel: OfferDetailViewModel?
    
    //Events
    var TermsAndConditions: (() -> Void)?
    var redeemOffer: ((OfferDetailApiResponse.Offer) -> Void)?
    var onBackButtonTapped: (() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let offerDetailViewModel else { return }
        coverView.isHidden = false
        showActivityIndicator()
        offerDetailViewModel.fetchOfferDetail(completion: {[weak self] errorString in
            self?.hideActivityIndicator()
            if let errorString{
                self?.showAlert(title: .alert, message: errorString,onOkTapped: self?.onBackButtonTapped)
            }else{
                DispatchQueue.main.async {[weak self] in
                    self?.setupOfferDetailUI()
                    self?.coverView.isHidden = true
                }
            }
        })
    }
    
    private func setupOfferDetailUI(){
        guard let offer = offerDetailViewModel?.offer else { return }
        
        if let outletNameComponents = offer.outlet?.name?.split(separator: "-"),
           let name = outletNameComponents.first,
           let brand = outletNameComponents.last{
            
            outletNameLabel.text = String(name) + " -"
            outletSubnameLabel.text = String(brand)
            
            offerNameLabel.text = String(brand).removingLeadingSpaces()
            
            
        }else{
            outletNameLabel.text = offer.outlet?.name
            outletSubnameLabel.text = ""
            offerNameLabel.text = ""
        }
        
        offerDetailLabel.text = offer.title
        ruleOfPurchaseLabel.text = offer.rulesOfPurchase
        
        
        expiryDateLabel.text = "Offer expires on ".localized + getDate(dateString: offer.endDatetime ?? "")
        
        savingLabel.text = ""
        if let saving = offer.approxSaving{
            savingLabel.text = "Save approximately " + String(saving) + " QAR"
        }
        detailExclusionLabel.text = offer.validFor
        
    }
    
    @IBAction func shareOffer(_ sender: Any){
//        let branchIO = BranchUniversalObject(canonicalIdentifier: "UrbanPoint")
//        let linkProperties = BranchLinkProperties()
//
//        let appID = "1"
//
//        linkProperties.addControlParam("id", withValue: String(offerDetailViewModel?.offer?.id ?? -1 ))
//        linkProperties.addControlParam("app_id", withValue: appID)
//        linkProperties.addControlParam("navigation_type", withValue: "offer")
//        linkProperties.addControlParam("$android_deeplink_path", withValue:  "urban-point.app.link//offerid=\(offerDetailViewModel?.offer?.id ?? -1)@\(appID)" )
//        branchIO.getShortUrl(with: linkProperties) { (url, error) in
//            if (error == nil) {
//                DispatchQueue.main.async {
//                 self.shareURL(url ?? "")
//                }
//            } else {
//                print(String(format: "Branch error : %@", error! as CVarArg))
//            }
//        }
    }
    
    private func shareURL(_ url: String){
        let textToShare = "Check this offer on UrbanPoint: \(offerDetailViewModel?.offer?.title ?? "") \n" + url
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    private func setupUI(){
        outletNameLabel.text = ""
        offerNameLabel.text = ""
        offerDetailLabel.text = ""
        detailExclusionLabel.text = ""
        expiryDateLabel.text = ""
        savingLabel.text = ""
        
        containerView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
    
    private func getDate(dateString: String) -> String{
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = formatter.date(from: dateString)else { return "" }
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    @IBAction func onTermsAndConditionTapped(_ sender: Any){
        TermsAndConditions?()
    }
    
    @IBAction func onRedeemOfferTapped(_ sender: Any){
        if let offer = offerDetailViewModel?.offer{
            redeemOffer?(offer)
        }
    }
    
}
