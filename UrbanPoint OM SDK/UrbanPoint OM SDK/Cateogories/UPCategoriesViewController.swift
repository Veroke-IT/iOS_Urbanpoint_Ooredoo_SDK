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
     //   collectionView.delegate = self
      //  collectionView.dataSource = self
        titleLabel.text = titleString
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
            listingViewController?.onNearbyButtonTapped = onNearbyButtonTouched
            listingViewController?.onAlphabaticalButtonTapped = onAlphabaticalButtonTouched
            listingViewController?.onTabledEndPointReached = onTableViewEndReached
        }
    }
    
    //MARK: Fetch Alphabatical Outlets
    private func onAlphabaticalButtonTouched(completion: @escaping ([UPOutletListingTableViewCell.Outlet]) -> Void){
        listingViewModel?.fetchOutlet(completion: { outlet in
            let outlets = outlet.map { outlet in
                UPOutletListingTableViewCell.Outlet(id: outlet.outletID, outletName: outlet.outletName, image: outlet.outletImage, distance: outlet.outletDistance, isExpanded: false, offers: outlet.offers)
            }
            completion(outlets)
        })
    }
  
    
    //MARK: OnNearby Button Tapped
    private func onNearbyButtonTouched(completion: @escaping ([UPOutletListingTableViewCell.Outlet]) -> Void){}
    
    //MARK: Fetch New Items
    private func onTableViewEndReached(_ index: Int){}
    
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
