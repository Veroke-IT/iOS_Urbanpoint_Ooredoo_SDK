import UIKit
protocol CustomSwitchDelegate {
    func switchButtonAction(_ isOn: Bool, sender: CustomSwitch)
}

class CustomSwitch: UIView {
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.urbanPointGreen
        return view
    }()
    
    private let innerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.urbanPointGrey
        return view
    }()
    
    var isOn: Bool = false
    private var leadingContraint: NSLayoutConstraint!
    
    public var delegate: CustomSwitchDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        innerView.layer.cornerRadius = innerView.frame.height / 2
        indicatorView.layer.cornerRadius = indicatorView.frame.height  / 2
    }
    
    
    fileprivate func setupUI() {
        
        self.addSubview(innerView)
        self.addSubview(indicatorView)
        
        NSLayoutConstraint.activate([
            indicatorView.widthAnchor.constraint(equalToConstant: self.frame.size.height),
            indicatorView.heightAnchor.constraint(equalToConstant: self.frame.size.height),
            
            indicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            innerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            innerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            innerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            innerView.heightAnchor.constraint(equalTo: indicatorView.heightAnchor, multiplier: 0.75)
            
        ])
        
        
        if appLanguage == .english {
            leadingContraint = indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
        } else {
            leadingContraint = indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.frame.size.width / 2)
        }

        
        leadingContraint.isActive = true
        
        addTapGesture()
        
    }
    
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapSwitch))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapSwitch(_ gesture: UITapGestureRecognizer) {
        let circularLayer = CAShapeLayer()
        circularLayer.path = UIBezierPath(roundedRect: CGRect(x: (indicatorView.frame.width / 2) - ((indicatorView.frame.width * 2) / 2), y: (indicatorView.frame.height / 2) - ((indicatorView.frame.height * 2) / 2), width: indicatorView.frame.width * 2, height: indicatorView.frame.height * 2), cornerRadius: (indicatorView.frame.width * 2) / 2).cgPath
        circularLayer.fillColor = UIColor(red: 43/255, green: 164/255, blue: 164/255, alpha: 0.4).cgColor
        indicatorView.layer.insertSublayer(circularLayer, at: 0)
        
        if appLanguage == .english {
            isOn = true
            leadingContraint.constant = self.frame.size.width / 2
        } else {
            isOn = false
            leadingContraint.constant = 0
        }
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut) {
            self.layoutIfNeeded()
        } completion: { _ in
            circularLayer.removeFromSuperlayer()
            self.delegate?.switchButtonAction(self.isOn, sender: self)
            //self.delegate?.switchButtonAction(Constants.UPDATA.appLanguage == .English, sender: self)
        }
    }

}
