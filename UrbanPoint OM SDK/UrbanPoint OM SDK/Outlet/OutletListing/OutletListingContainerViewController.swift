//
//  OutletListingContainerViewController.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/3/23.
//

import UIKit

class OutletListingContainerViewController: UIViewController {

    //MARK: IB Refrences
    @IBOutlet weak var alphaBaticalButton: UIButton!
    @IBOutlet weak var nearbyButton: UIButton!
    @IBOutlet weak var segmentedView: UIView!
    
    //MARK: UI State
    private var index: Int = 1
    private var outletListingViewController: OutletListingViewController?
    private var selectedSortCondition: OutletRepositoryParam.Sort = .nearby
    
    //MARK: Events
    internal var fetchOutlets: ((Int,
                                 OutletRepositoryParam.Sort,
                                         @escaping ([UPOutletListingTableViewCell.Outlet]) -> Void) -> Void)?
    internal var onBackButtonPressed: (() -> Void)?
    internal var onOutletSelected: ((UPOutletListingTableViewCell.Outlet) -> Void)?
    internal var onOfferSelected: ((UPOffer) -> Void)?
    internal var onTabledEndPointReached: ((Int) -> Void)?
    private var currentlyShownOutlets: [UPOutletListingTableViewCell.Outlet] = []
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onAlphabaticalButtonTouched(_ sender: Any){
        selectedSortCondition = .alphabatical
        setupButton(selectedButton: alphaBaticalButton, unSelectedButton: nearbyButton)
        index = 1
        fetchOutletsForListing()
    }
    
    //MARK: On Nearby Button Tapped
    @IBAction func onNearbyButtonTouched(_ sender: Any){
        selectedSortCondition = .nearby
        setupButton(selectedButton: nearbyButton, unSelectedButton: alphaBaticalButton)
        index = 1
        fetchOutletsForListing()
    }
    
    private func fetchOutletsForListing(){
        
        fetchOutlets?(index,selectedSortCondition){ outlets in
            DispatchQueue.main.async {[weak self] in
                guard let strongSelf = self else { return }
                if let vc = strongSelf.outletListingViewController{
                    if strongSelf.index == 1 {
                        strongSelf.currentlyShownOutlets = []
                    }
                    strongSelf.currentlyShownOutlets.append(contentsOf: outlets)
                    vc.showOutletData(strongSelf.currentlyShownOutlets)
                }
            }
        }
    }
    
    //MARK: Setups Button UI
    private func setupButton(selectedButton: UIButton, unSelectedButton: UIButton){
        selectedButton.backgroundColor = Colors.urbanPointRed
        unSelectedButton.backgroundColor = .white
        selectedButton.setTitleColor(.white, for: .normal)
        unSelectedButton.setTitleColor(.black, for: .normal)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OutletListing"{
            let destination = segue.destination as! OutletListingViewController
            self.outletListingViewController = destination
            self.outletListingViewController?.onOutletSelected = onOutletSelected
            self.outletListingViewController?.onOfferSelected = onOfferSelected
            self.outletListingViewController?.onTableEndPoisitionReached = onTableViewEndPositionReached
        }
    }
    
    private func onOutletSelected(_ outlet: UPOutletListingTableViewCell.Outlet){ onOutletSelected?(outlet) }
    private func onOfferSelected(_ offer: UPOffer){ onOfferSelected?(offer) }
   
    private func onTableViewEndPositionReached(){
        index += 1
        fetchOutletsForListing()
    }
}
