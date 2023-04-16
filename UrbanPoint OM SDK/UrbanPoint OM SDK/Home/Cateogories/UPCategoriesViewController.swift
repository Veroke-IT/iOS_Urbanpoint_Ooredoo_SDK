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
    var viewModel : UPCategoryViewModel
    var onBackButtonTapped: (() -> Void)? = nil
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titleString
        viewModel.fetchUserLocation()
        
        showActivityIndicator()
        viewModel.fetchCategories(completion: {[weak self] errorString in
            self?.hideActivityIndicator()
            if let errorString{
                    self?.showAlert(title: .alert, message: errorString)
            }else{
                if let listingController = self?.listingViewController{
                    if  self?.viewModel.currentLocation != nil{
                        listingController.fetchOutletsForListingNearby()
                    }else{
                        listingController.fetchOutletsForListingAlphabatical()
                    }
                }
                DispatchQueue.main.async {[weak self] in
                    self?.collectionView.reloadData()
                }
            }
        })
    }
    
    
    init?(coder: NSCoder, viewModel: UPCategoryViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a home view model.")
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
            listingViewController?.fetchOutletsNearby = fetchOutletsNearby
            listingViewController?.fetchOutletsAlphabatical = fetchOutletsAlphabatical
            listingViewController?.onOfferSelected = { offer in
                let httpClient = UPURLSessionHttpClient(session: .shared)
              
                    let viewController = UPOfferDetailComposer.createOfferDetailView(offerID: offer.id, httpClient: httpClient)
                self.navigationController?.present(viewController,animated: true)
                
            }
        }
    }
    
    private func fetchOutletsNearby(index: Int,
                              completion: @escaping ([UPOutletListingTableViewCell.Outlet]) -> Void){
        showActivityIndicator()
        viewModel.fetchOutletNearby(searchText: nil, categoryID: viewModel.selectedCategoryID, collectionID: viewModel.selectedCollectionID, index: index){[weak self] data in
            self?.hideActivityIndicator()
            if let errorString = data.1{
                self?.showAlert(title: .alert, message: errorString)
            }else{
                completion(data.0)
            }
       
        }
    }
    
    private func fetchOutletsAlphabatical(index: Int,
                              completion: @escaping ([UPOutletListingTableViewCell.Outlet]) -> Void){
        showActivityIndicator()
        viewModel.fetchOutletAlphabatical(searchText: nil, categoryID: viewModel.selectedCategoryID, collectionID: viewModel.selectedCollectionID, index: index){[weak self] data in
            self?.hideActivityIndicator()
            if let errorString = data.1{
                self?.showAlert(title: .alert, message: errorString)
            }else{
                completion(data.0)
            }
       
        }
    }
    
    

    
}


extension UPCategoriesViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.height, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UPCategoriesCollectionViewCell.reuseIdentifier, for: indexPath) as! UPCategoriesCollectionViewCell
        
        let imageURLString = imageBaseURL + (viewModel.categories[indexPath.row].image ?? "")
        if let url = URL(string: imageURLString){
            cell.configureCell(with: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        let selectedCategoryID = viewModel.categories[indexPath.row].id
        if selectedCategoryID != viewModel.selectedCollectionID{
            viewModel.selectedCollectionID = selectedCategoryID
            viewModel.currentLocation != nil ? listingViewController?.onNearbyButtonTouched(self)
                : listingViewController?.onAlphabaticalButtonTouched(self)
            
        }

    }
    
}
