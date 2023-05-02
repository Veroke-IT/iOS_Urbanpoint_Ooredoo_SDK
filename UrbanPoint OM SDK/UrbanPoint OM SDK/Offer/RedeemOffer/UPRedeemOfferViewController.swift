//
//  UPRedeemOfferViewController.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/12/23.
//

import UIKit

class UPRedeemOfferViewController: UIViewController {
    
    @IBOutlet var pinCodeInputTextField: [UITextField]!
    @IBOutlet weak var outletNameLabel: UILabel!
    @IBOutlet weak var offerNameLabel: UILabel!
    @IBOutlet weak var outletLogoImage: UIImageView!
    @IBOutlet weak var successContainer: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var pinCodeLabel: UILabel!
    @IBOutlet weak var savingLabel: UILabel!
    @IBOutlet weak var outletLogoContainerView: UIView!
    
    var viewModel: UPRedeemOfferViewModel? = nil
    var onBackButtonTapped: (() -> Void)?
    var goToOutlet: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTextFieldDelegate()
        setupInProgressView()
    }
    
    private func setupUI(){
        outletNameLabel.text = viewModel?.offerData.outletName
        offerNameLabel.text = viewModel?.offerData.offerDetails
        savingLabel.text = "You save approximatly " + (viewModel?.offerData.saving.getNumberWithoutDecimal() ?? "") + " QAR!"
      
        outletLogoImage.applyshadowWithCorner(containerView: outletLogoContainerView, cornerRadious: outletLogoImage.layer.cornerRadius)
        outletLogoImage.sd_setImage(with: viewModel?.offerData.outletImage,placeholderImage: placeHolderImage)
    
    }
    
    @IBAction func onBackButtonPressed(_ sender: Any){
        onBackButtonTapped?()
    }
    
    private func setupTextFieldDelegate(){
        pinCodeInputTextField.forEach { textFeild in
            textFeild.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            textFeild.addTarget(self, action: #selector(textFieldDidBeign), for: .editingDidBegin)
        }
    }
    
    @IBAction func onRedeemOfferButtonTouched(_ sender: Any){
        redeemOffer()
    }
    
    private func redeemOffer(){
        if !successContainer.isHidden{
            goToOutlet?()
            return
        }
        var code = ""
        pinCodeInputTextField.forEach {
            if let text = $0.text?.first{
                code += String(text)
            }
        }
        
        showActivityIndicator()
        viewModel?.redeemOffer(pin: code, completion: {[weak self] result in
            self?.hideActivityIndicator()
            if let error = result.1{
                self?.showAlert(title: .alert, message: error)
            }else{
                DispatchQueue.main.async {[weak self] in
                    self?.setupSuccessView(withPin: result.0 ?? "")
                }
            }
        })
    }
    
    private func setupSuccessView(withPin: String){
        self.successContainer.isHidden = false
        pinCodeLabel.text = withPin
        submitButton.setTitle("Done", for: .normal)
    }
    
    private func setupInProgressView(){
        self.successContainer.isHidden = true
        self.pinCodeLabel.text = ""
        submitButton.setTitle("Confirm", for: .normal)
        submitButton.isEnabled = false
    }


    
}


extension UPRedeemOfferViewController{
    
    @objc private func textFieldDidChange(_ sender: UITextField){
        let index = indexOf(sender)
        if let text = sender.text?.last{
            sender.text = String(text)
            if index <= 2{
                pinCodeInputTextField[index+1].becomeFirstResponder()
            }else if index == 3{
                updateSubmitButton(isEnabled: true)
             }
        }
        else if index >= 1{
            pinCodeInputTextField[index - 1].becomeFirstResponder()
            updateSubmitButton(isEnabled: false)
        }
    }
    
    @objc private func textFieldDidBeign(_ sender: UITextField){
        let index = indexOf(sender)
        (0..<index).forEach {
            if let text = pinCodeInputTextField[$0].text,text.isEmpty{
                pinCodeInputTextField[$0].becomeFirstResponder()
                return
            }
        }
    }
    
    @IBAction func onBackButtonTapped(_ sender: Any){
        navigationController?.popViewController(animated: true)
    }
    
    private func indexOf(_ field: UITextField) -> Int{
        pinCodeInputTextField.firstIndex { $0 == field } ?? 0
    }
    
    private func updateSubmitButton(isEnabled: Bool){
        submitButton.isEnabled = isEnabled
        if isEnabled{
            pinCodeInputTextField.last?.resignFirstResponder()
        }
        submitButton.backgroundColor = isEnabled ? Colors.urbanPointRed : Colors.urbanPointGrey
        submitButton.setTitleColor(isEnabled ?  UIColor.white : UIColor.darkGray, for: .normal)
        submitButton.titleLabel?.textColor = isEnabled ?  UIColor.white : UIColor.darkGray
    }
    
}

