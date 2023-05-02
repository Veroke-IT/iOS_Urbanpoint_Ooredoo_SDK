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
    @IBOutlet weak var tableView: UITableView!
    
    var titleString = ""
    var viewModel: OutletListingPresenterContract!
    var searchingViewModel: UPOutletSearchViewModel? = nil
    var listingViewContainer: OutletListingContainerViewController? = nil

    var onBackButtonTapped: (() -> Void)?
    var showOutlet: ((UPOutletListingTableViewCell.Outlet) -> Void)?
    var onOfferSelected: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchUserLocation()
        titleLabel.text = titleString
        tableView.isHidden = true
        searchBarView.isHidden = true
        if searchingViewModel == nil{
            searchButton.isHidden = true
            searchImageView.isHidden = true
           
            searchButton.isEnabled = false
        }else{
            searchBar.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
      
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.fetchListing()
        }
        
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField){
        guard let searchText  = sender.text else {
            return
        }
        if !searchText.isEmpty{
            searchingViewModel?.fetchAutoCompleteOffers {
                DispatchQueue.main.async {
                    if (self.searchingViewModel?.autoCompleteOffers.count ?? 0) > 0{
                        
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                    }else{
                        self.tableView.isHidden = true
                    }
                }
            }
        }else{
            tableView.isHidden = true
        }
    }
    
//    init?(coder: NSCoder,
//          viewModel: OutletListingPresenterContract,
//          titleString: String,
//          searchViewModel: UPOutletSearchViewModel? = nil,
//          onBackButtonTapped: @escaping () -> Void) {
//        self.titleString = titleString
//        self.viewModel = viewModel
//        self.searchingViewModel = searchViewModel
//        self.onBackButtonTapped = onBackButtonTapped
//        super.init(coder: coder)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("You must create this view controller with a home view model.")
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
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
        tableView.isHidden = true
        shouldShowSearchBar(false)
        searchBar.resignFirstResponder()
     
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
            listingViewContainer?.onOutletSelected = onOutletSelected
            listingViewContainer?.onOfferSelected = {[weak self] offer in
                if let id = offer.id{
                    self?.onOfferSelected?(id)
                }
            }
        }
    }
    
    private func onOutletSelected(outlet: UPOutletListingTableViewCell.Outlet){
        showOutlet?(outlet)
    }
    
    private func navigateToChildListingViewController(outlet: UPOutletListingTableViewCell.Outlet){
        let childListingViewModel = ChildOutletListingViewModel(outletRepository:viewModel.outletRepository , parentID: outlet.id)
        let viewController = NewBrandComposer.createNewBrandViewController( viewModel: childListingViewModel, titleString: outlet.outletName, onBackButtonTapped: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        } )
        navigationController?.pushViewController(viewController, animated: true)
    }
    

    
    private func fetchOutletsNearby(index: Int,
                              completion: @escaping ([UPOutletListingTableViewCell.Outlet]) -> Void){
        
        showActivityIndicator()
        viewModel.fetchOutletNearby(searchText: searchBar.text, categoryID: nil, collectionID: nil, index: index){[weak self] response in
            self?.hideActivityIndicator()
            if let _ = response.1{
               // self?.showAlert(title: .alert, message: error)
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
                if let _ = response.1{
                 //   self?.showAlert(title: .alert, message: error)
                }else{
                    completion(response.0)
                }
        }
    
    }
    
}
    

extension NewBrandViewController: UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        if let searchText = textField.text,!searchText.isEmpty{
           fetchListing()
        }
        textField.resignFirstResponder()
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchingViewModel?.autoCompleteOffers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrendingTableViewCell.cellIdentifierString) as! TrendingTableViewCell
        if let text = searchingViewModel?.autoCompleteOffers[indexPath.row]{
            cell.configureCellWith(text)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let text = searchingViewModel?.autoCompleteOffers[indexPath.row]{
            self.searchBar.text = text
        }
        self.tableView.isHidden = true
        searchBar.resignFirstResponder()
        fetchListing()
    }
    
    
}


