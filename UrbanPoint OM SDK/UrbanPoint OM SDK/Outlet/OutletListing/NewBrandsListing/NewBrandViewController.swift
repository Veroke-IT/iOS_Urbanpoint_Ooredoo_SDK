//
//  NewBrandViewController.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/14/23.
//

import UIKit

class NewBrandViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    private(set) var titleString = ""
    var viewModel: OutletListingPresenterContract
    var listingViewContainer: OutletListingContainerViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchUserLocation()
        titleLabel.text = titleString
        
    }
    
    
    init?(coder: NSCoder, viewModel: OutletListingPresenterContract,titleString: String) {
        self.titleString = titleString
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a home view model.")
    }
    
    
    
    //MARK: Initialize ChildViewControllers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OutletListingViewController"{
            listingViewContainer = segue.destination as? OutletListingContainerViewController
            listingViewContainer?.fetchOutletsNearby = fetchOutletsNearby
            listingViewContainer?.fetchOutletsAlphabatical = fetchOutletsAlphabatical
            listingViewContainer?.onOutletSelected = { outlet in
                
                outlet.isParentOutlet ? self.navigateToChildListingViewController(outlet: outlet)
                : self.navigateToOutletDetailScreen(id: outlet.id)
                
                
            }
            listingViewContainer?.onOfferSelected = { offer in
                let httpClient = UPURLSessionHttpClient(session: .shared)
                
                let viewController = UPOfferDetailComposer.createOfferDetailView(offerID: offer.id, httpClient: httpClient)
                self.navigationController?.present(viewController,animated: true)
                
            }
        }
    }
    
    private func navigateToChildListingViewController(outlet: UPOutletListingTableViewCell.Outlet){
        let childListingViewModel = ChildOutletListingViewModel(outletRepository:viewModel.outletRepository , parentID: outlet.id)
        let viewController = NewBrandComposer.createNewBrandViewController( viewModel: childListingViewModel, titleString: outlet.outletName )
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func navigateToOutletDetailScreen(id: Int){
        let httlCleint = UPURLSessionHttpClient(session: .shared)
        let viewController = UPOutletDetailComposer.createOutletDetailView(outletID: id, httpClient: httlCleint)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func fetchOutletsNearby(index: Int,
                              completion: @escaping ([UPOutletListingTableViewCell.Outlet]) -> Void){
        
        viewModel.fetchOutletNearby(searchText: nil, categoryID: nil, collectionID: nil, index: index){ response in
            if let error = response.1{
                debugPrint(error)
            }else{
                completion(response.0)
            }
       
        }
    }
    
    private func fetchOutletsAlphabatical(index: Int,
                              completion: @escaping ([UPOutletListingTableViewCell.Outlet]) -> Void){
        viewModel.fetchOutletAlphabatical(searchText: nil, categoryID: nil, collectionID: nil, index: index){ response in
                if let error = response.1{
                    debugPrint(error)
                }else{
                    completion(response.0)
                }
        }
    
    }
    
}
    

