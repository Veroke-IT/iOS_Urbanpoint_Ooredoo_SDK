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
   
    var offerDetailViewModel: OfferDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let offerDetailViewModel else { return }
        offerDetailViewModel.fetchOfferDetail(completion: { errorString in
            if let errorString{
                debugPrint(errorString)
            }else{
                DispatchQueue.main.async {[weak self] in
                    self?.setupOfferDetailUI()
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
    
}
