//
//  OutletSearchViewController.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/30/23.
//

import UIKit

class OutletSearchViewController: UIViewController {
    
    private let searchBarTopConstraintHeight = 38
    private var index: Int = 1
    
    let outletSearchViewModel: UPOutletSearchViewModel = {
        let httpClient = UPURLSessionHttpClient(session: URLSession.shared)
        let trendingSearchRepository = UPTrendingSearchHttpRepository(httpClient: httpClient)
        let outletRepository = URLSessionOutletRepository(httpClient: httpClient)
        let viewModel = UPOutletSearchViewModel(trendingSearchRespository: trendingSearchRepository, outletRespository: outletRepository)
        return viewModel
    }()
    
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
    var outletListingController: OutletListingViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupInitialUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchTrendingSearches()
    }
    
    private func setupInitialUI(){
        outletListinContainerView.isHidden = true
        hideCancelButton()
        searchField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField){
        guard let searchText  = sender.text else {
            return
        }
        if searchText.isEmpty{
            if outletListingController?.outlets.count ?? 0 == 0{
                isShowingTrendingSearches = true
            }else{
                trendingSearchesContainerView.isHidden = true
                outletListinContainerView.isHidden = false
            }
        }
        else if searchText.count >= 1 { viewStoredSearches(searchText: searchText) }
    }
    
    private func viewStoredSearches(searchText: String){
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
        isShowingTrendingSearches = true
        self.searchBarViewTopConstraint.constant = CGFloat(self.searchBarTopConstraintHeight + 16)
        self.searchBarTrailingConstraint.constant = 0
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            self.cancelSearchButton.isHidden = true
            self.searchField.resignFirstResponder()

        }
   }
    
    private func showCancelButton(){
        if !cancelSearchButton.isHidden { return }
        self.searchBarTrailingConstraint.constant += self.cancelSearchButton.frame.width + 8
        self.searchBarViewTopConstraint.constant = 16
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        } completion: { success in
            self.cancelSearchButton.isHidden = false
        }
    }
    
    private func fetchTrendingSearches(){
        outletSearchViewModel.fetchTrendingSearches { success in
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
            outletListingController?.onOfferSelected = onOfferSelected
            outletListingController?.onTableEndPoisitionReached = onTableEndReached
        }
    }
    
    private func onTableEndReached(){
        if index < outletSearchViewModel.totalPages{
            index += 1
            fetchOutletData()
        }
    }

    private func fetchOutletData(){
        outletSearchViewModel.fetchOutlet(index: index) {  [weak self] errorString in
            guard let strongSelf = self else { return }
            if let errorString{
               debugPrint(errorString)
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
    
    private func onOfferSelected(offer: UPOffer){
        
        let httpClient = UPURLSessionHttpClient(session: URLSession.shared)
        let offerRepository = URLSessionOfferRepository(httpClient: httpClient)
        let viewModel = OfferDetailViewModel(offerID: offer.id, offerRepository: offerRepository)
        let storyBoardBundle = Bundle(identifier: "com.UrbanPoint-OM-SDK")
        let viewController = UIStoryboard(name: "Offer", bundle: storyBoardBundle).instantiateViewController(withIdentifier: "OfferDetailViewController") as! OfferDetailViewController
        
        viewController.offerDetailViewModel = viewModel
        navigationController?.present(viewController, animated: true)
        
    }
}

extension OutletSearchViewController: UITableViewDataSource,UITableViewDelegate{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        (isShowingTrendingSearches ? outletSearchViewModel.trendingSearches.count : outletSearchViewModel.storedSearches.count)
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
        return cell
    }
    
    private func makeTrendingSearchesTableViewCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendingTableViewCell.cellIdentifierString, for: indexPath) as? TrendingTableViewCell
        else{
            return UITableViewCell()
        }
        cell.configureCellWith(outletSearchViewModel.trendingSearches[indexPath.row].text)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            handelTrendingSearchSelection(indexPath: indexPath)
    }
    
    private func handelTrendingSearchSelection(indexPath: IndexPath){
        var searchText = ""
        searchText = isShowingTrendingSearches ?  outletSearchViewModel.trendingSearches[indexPath.row].text :
            outletSearchViewModel.storedSearches[indexPath.row]
        searchField.text = searchText
        showCancelButton()
    }
}

extension OutletSearchViewController: UITextFieldDelegate{
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showCancelButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let searchText = textField.text,!searchText.isEmpty{
            index = 1
            outletSearchViewModel.searchText = searchText
            fetchOutletData()
        }
        return true
    }
}
