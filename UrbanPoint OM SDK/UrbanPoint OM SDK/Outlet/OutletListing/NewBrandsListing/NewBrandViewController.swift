//
//  NewBrandViewController.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/14/23.
//

import UIKit

class NewBrandViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchImageView: UIImageView!
    
    private(set) var titleString = ""
    var viewModel: OutletListingPresenterContract
    var searchingViewModel: UPOutletSearchViewModel? = nil
    var listingViewContainer: OutletListingContainerViewController? = nil

    var onBackButtonTapped: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchUserLocation()
        titleLabel.text = titleString
        searchBarView.isHidden = true
        if searchingViewModel == nil{
            searchButton.isHidden = true
            searchImageView.isHidden = true
            searchButton.isEnabled = false
        }
        
    }
    
    init?(coder: NSCoder,
          viewModel: OutletListingPresenterContract,
          titleString: String,
          searchViewModel: UPOutletSearchViewModel? = nil,
          onBackButtonTapped: @escaping () -> Void) {
        self.titleString = titleString
        self.viewModel = viewModel
        self.searchingViewModel = searchViewModel
        self.onBackButtonTapped = onBackButtonTapped
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a home view model.")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchListing()
    }
    
    private func fetchListing(){
        if let listingController = self.listingViewContainer{
            if self.viewModel.currentLocation != nil{
                listingController.fetchOutletsForListingNearby()
            }else{
                listingController.fetchOutletsForListingAlphabatical()
            }
        }
    }
    
    @IBAction func onShowSearchBarTapped(_ sender: Any){
        shouldShowSearchBar(true)
    }
    
    @IBAction func onHideSearchBarTapped(_ sender: Any){
        searchBar.text = ""
        shouldShowSearchBar(false)
    }
    
    private func shouldShowSearchBar(_ visiblity: Bool){
        searchBarView.isHidden = !visiblity
    }
    
    @IBAction func onBackButtonTapped(_ sender: Any){
        onBackButtonTapped?()
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

                
            }
        }
    }
    
    private func navigateToChildListingViewController(outlet: UPOutletListingTableViewCell.Outlet){
        let childListingViewModel = ChildOutletListingViewModel(outletRepository:viewModel.outletRepository , parentID: outlet.id)
        let viewController = NewBrandComposer.createNewBrandViewController( viewModel: childListingViewModel, titleString: outlet.outletName, onBackButtonTapped: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        } )
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func navigateToOutletDetailScreen(id: Int){
        let httlCleint = UPURLSessionHttpClient(session: .shared)
        let viewController = UPOutletDetailComposer.createOutletDetailView(outletID: id, httpClient: httlCleint)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func fetchOutletsNearby(index: Int,
                              completion: @escaping ([UPOutletListingTableViewCell.Outlet]) -> Void){
        
        showActivityIndicator()
        viewModel.fetchOutletNearby(searchText: searchBar.text, categoryID: nil, collectionID: nil, index: index){[weak self] response in
            self?.hideActivityIndicator()
            if let error = response.1{
                self?.showAlert(title: .alert, message: error)
            }else{
                completion(response.0)
            }
       
        }
    }
    
    private func fetchOutletsAlphabatical(index: Int,
                              completion: @escaping ([UPOutletListingTableViewCell.Outlet]) -> Void){
        showActivityIndicator()
        viewModel.fetchOutletAlphabatical(searchText: searchBar.text, categoryID: nil, collectionID: nil, index: index){[weak self] response in
                self?.hideActivityIndicator()
                if let error = response.1{
                    self?.showAlert(title: .alert, message: error)
                }else{
                    completion(response.0)
                }
        }
    
    }
    
}
    

extension NewBrandViewController: UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        if let searchText = textField.text,!searchText.isEmpty{
           fetchListing()
        }
        return true
    }
    
    
}
