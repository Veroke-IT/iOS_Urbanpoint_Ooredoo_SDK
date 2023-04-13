//
//  UPCategoriesViewController.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/5/23.
//

import UIKit

class UPCategoriesViewController: UIViewController {

     @IBOutlet private weak var collectionView: UICollectionView!
     @IBOutlet private weak var titleLabel: UILabel!
    
    var titleString: String = ""
    
    private var listingViewController: OutletListingContainerViewController? = nil
    var listingViewModel : OutletListingPresenter? = nil
    var onBackButtonTapped: (() -> Void)? = nil

    let categories: [Int] = [1,2,3,4,5,6]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleString
        listingViewModel?.fetchUserLocation()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: onBackButtonPressed
    @IBAction func onBackButtonPressed(_ sender: Any){
        onBackButtonTapped?()
    }
    
    //MARK: Initialize ChildViewControllers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OutletListingViewController"{
            listingViewController = segue.destination as? OutletListingContainerViewController
            listingViewController?.fetchOutlets = fetchOutlets
            listingViewController?.onOfferSelected = { offer in
                let httpClient = UPURLSessionHttpClient(session: .shared)
              
                    let viewController = UPOfferDetailComposer.createOfferDetailView(offerID: offer.id, httpClient: httpClient)
                self.navigationController?.present(viewController,animated: true)
                
            }
        }
    }
    
    private func fetchOutlets(index: Int,sortCondition: OutletRepositoryParam.Sort,
                              completion: @escaping ([UPOutletListingTableViewCell.Outlet]) -> Void){
        listingViewModel?.fetchOutletNearby(index: index, sortCondition: sortCondition, completion: { response in
            
            if response.0.isEmpty {
                debugPrint(response.1)
                return
            }
            
            let outlets = response.0
                .map { outlet in
                    UPOutletListingTableViewCell.Outlet(id: outlet.outletID, outletName: outlet.outletName, image: URL(string: imageBaseURL + outlet.outletImage), distance: outlet.outletDistance, isExpanded: false, offers: outlet.offers)
            }
            completion(outlets)
        })
    }
    
    

    
}


extension UPCategoriesViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.height, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.identifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
}
