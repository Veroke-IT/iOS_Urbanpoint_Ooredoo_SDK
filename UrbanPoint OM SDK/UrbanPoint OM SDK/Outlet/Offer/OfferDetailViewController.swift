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
    var offerDetailViewModel: OfferDetailViewModel?
    
    //Events
    var TermsAndConditions: (() -> Void)?
    var redeemOffer: (() -> Void)?
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
        
        outletNameLabel.text = offer.outlet?.name
        offerDetailLabel.text = offer.description
        offerNameLabel.text = offer.title
        expiryDateLabel.text = offer.endDatetime
        savingLabel.text = "Save QAR " + String(offer.approxSaving ?? 0)
        detailExclusionLabel.text = offer.rulesOfPurchase
        
    }
    
    private func setupUI(){
        outletNameLabel.text = ""
        offerNameLabel.text = ""
        offerDetailLabel.text = ""
        detailExclusionLabel.text = ""
        expiryDateLabel.text = ""
        savingLabel.text = ""
    }
    
    @IBAction func onTermsAndConditionTapped(_ sender: Any){
        TermsAndConditions?()
    }
    @IBAction func onRedeemOfferTapped(_ sender: Any){}
    
}
