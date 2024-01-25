//
//  OutletSearchViewController.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/30/23.
//

import UIKit

class OutletSearchViewController: UIViewController {
    
    private let searchBarTopConstraintHeight = 48
    private var index: Int = 1
    
    var outletSearchViewModel: UPOutletSearchViewModel!
    
    var onBackButtonTapped: (() -> Void)?
    var showOutlet: ((UPOutletListingTableViewCell.Outlet) -> Void)?
    var onOfferSelected: ((UPOffer) -> Void)?
    
    //MARK: UIState Variables
    var isShowingTrendingSearches: Bool = true{
        didSet{
            tableView.reloadData()
        }
    }
    
    //MARK: IB Refrences
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var cancelSearchButton: UIButton!
    @IBOutlet weak var searchBarTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBarViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var trendingSearchesContainerView: UIView!
    @IBOutlet weak var outletListinContainerView: UIView!
    @IBOutlet weak var trendingSearchLabel: UILabel!
    var outletListingController: OutletListingViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialUI()
        fetchTrendingSearches()
    }
    
    
    private func setupInitialUI(){
        outletListinContainerView.isHidden = true
        hideCancelButton()
        searchField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func deleteStoredSearch(_ string: String){
        outletSearchViewModel.deleteStoredSearch(string)
        if let searchText = searchField.text{
            outletSearchViewModel.fetchStoredSearches(searchText: searchText) {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    
    private func viewStoredSearches(searchText: String){
        trendingSearchLabel.isHidden = true
        outletSearchViewModel.fetchStoredSearches(searchText: searchText) {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.outletListinContainerView.isHidden = true
            strongSelf.trendingSearchesContainerView.isHidden = false
            strongSelf.isShowingTrendingSearches = strongSelf.outletSearchViewModel.storedSearches.isEmpty
            
        }
    }
    
    @IBAction func onBackButtonPressed(_ sender: Any){
        navigationController?.popViewController(animated: true)
    }
    
    private func hideCancelButton(){
        if cancelSearchButton.isHidden { return }
        searchField.text = ""
        outletSearchViewModel.searchText = ""
        isShowingTrendingSearches = true
        self.searchBarViewTopConstraint.constant = CGFloat(self.searchBarTopConstraintHeight + 16)
        self.searchBarTrailingConstraint.constant = 0
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            self.cancelSearchButton.isHidden = true
            self.searchField.resignFirstResponder()
        }
        tableView.reloadData()
   }
    
    private func showCancelButton(){
        if !cancelSearchButton.isHidden { return }
        if appLanguage == .english{
            self.searchBarTrailingConstraint.constant += self.cancelSearchButton.frame.width + 8
        }else{
            self.searchBarTrailingConstraint.constant -= self.cancelSearchButton.frame.width + 8
        }
        self.searchBarViewTopConstraint.constant = 16
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        } completion: { success in
            self.cancelSearchButton.isHidden = false
        }
    }
    
    private func fetchTrendingSearches(){
        showActivityIndicator()
        outletSearchViewModel.fetchTrendingSearches {[weak self] success in
            self?.hideActivityIndicator()
            if success{
                DispatchQueue.main.async {  [weak self] in
                    self?.isShowingTrendingSearches = true
                }
            }
        }
    }
    
    @IBAction func onCancelButtonTapped(_ sender: Any){
        hideCancelButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OutletListing"{
            outletListingController = segue.destination as? OutletListingViewController
            outletListingController?.onTableEndPoisitionReached = onTableEndReached
            outletListingController?.onOfferSelected = onOfferSelected
            outletListingController?.onOutletSelected = showOutlet 
            
        }
    }
    
    private func onTableEndReached(){
        if index < outletSearchViewModel.totalPages{
            index += 1
            fetchOutletData()
        }
    }

    private func fetchOutletData(){
        showActivityIndicator()
        outletSearchViewModel.searchText = searchField.text ?? ""
        outletSearchViewModel.fetchOutlet(index: index) {  [weak self] errorString in
            guard let strongSelf = self else { return }
            self?.hideActivityIndicator()
            if errorString != nil{
           //     self?.showAlert(title: .alert, message: errorString)
                return
            }
            strongSelf.showOutletListing(outlets: strongSelf.outletSearchViewModel.outlets)
        }
    }
    private func showOutletListing(outlets: [UPOutletListingTableViewCell.Outlet]){
        if let outletListingController{
            DispatchQueue.main.async {
                self.trendingSearchesContainerView.isHidden = true
                self.outletListinContainerView.isHidden = false
                outletListingController.showOutletData(outlets)
            }
        }
    }
    
}

extension OutletSearchViewController: UITableViewDataSource,UITableViewDelegate{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isShowingTrendingSearches{
            if outletSearchViewModel.searchText.isEmpty{
                trendingSearchLabel.isHidden = false
                return outletSearchViewModel.trendingSearches.count
            }else{
                trendingSearchLabel.isHidden = true
                return outletSearchViewModel.autoCompleteOffers.count
            }
        }else{
            return outletSearchViewModel.storedSearches.count
        }
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if isShowingTrendingSearches { return makeTrendingSearchesTableViewCell(tableView: tableView, indexPath: indexPath)}
            else { return makeStoredSearchesTableViewCell(tableView: tableView, indexPath: indexPath) }
       
    }
    
    private func makeStoredSearchesTableViewCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoredSearchesTableViewCell.cellIdentifierString,for: indexPath) as? StoredSearchesTableViewCell
        else{
            return UITableViewCell()
        }
        cell.configureCellWith(outletSearchViewModel.storedSearches[indexPath.row])
        cell.onDeleteSearchTapped = deleteStoredSearch
        return cell
    }
    
    private func makeTrendingSearchesTableViewCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell{
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendingTableViewCell.cellIdentifierString, for: indexPath) as? TrendingTableViewCell
        else{
            return UITableViewCell()
        }
        let searchText = outletSearchViewModel.searchText.isEmpty ? outletSearchViewModel.trendingSearches[indexPath.row].text
        : outletSearchViewModel.autoCompleteOffers[indexPath.row]
        
        cell.configureCellWith(searchText)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            handelTrendingSearchSelection(indexPath: indexPath)
    }
    
    private func handelTrendingSearchSelection(indexPath: IndexPath){
        var searchText = ""
        
        if isShowingTrendingSearches{
            if outletSearchViewModel.searchText.isEmpty{
                searchText = outletSearchViewModel.trendingSearches[indexPath.row].text
            }else if outletSearchViewModel.autoCompleteOffers.count > indexPath.row {
                searchText = outletSearchViewModel.autoCompleteOffers[indexPath.row]
            }
        }else{
            searchText = outletSearchViewModel.storedSearches[indexPath.row]
        }
            
        searchField.text = searchText
        showCancelButton()
        fetchOutletData()
    }
    
    
}

extension OutletSearchViewController: UITextFieldDelegate{
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showCancelButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let searchText = textField.text,!searchText.isEmpty{
            index = 1
            fetchOutletData()
        }
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField){
        guard let searchText  = sender.text else {
            return
        }
        outletSearchViewModel.searchText = searchText
        if searchText.isEmpty{
            if outletListingController?.outlets.count ?? 0 == 0{
                isShowingTrendingSearches = true
            }
            else{
                trendingSearchesContainerView.isHidden = true
                outletListinContainerView.isHidden = false
            }
        }
        else if searchText.count <= 2 {
            viewStoredSearches(searchText: searchText)
        }else{
            outletSearchViewModel.fetchAutoCompleteOffers {
                DispatchQueue.main.async {[weak self] in
                    self?.isShowingTrendingSearches = true
                    self?.tableView.reloadData()
                }
            }
        }
    }
}
