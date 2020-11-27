import UIKit
import Alamofire
import SDWebImage

class BeginCheckoutViewController: UIViewController {
    private let alertPresenter: AlertPresenter_Proto
    private let mobileService: MobileService_Protocol
    lazy var customModalTransitioningDelegate = CustomModalPresentationManager()
    
    lazy var beginCheckoutView: BeginCheckoutView = {
        return BeginCheckoutView()
    }()

    init(alertPresenter: AlertPresenter_Proto = AlertPresenter(),
         mobileService: MobileService_Protocol = MobileService()) {
        self.alertPresenter = alertPresenter
        self.mobileService = mobileService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = beginCheckoutView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        beginCheckoutView.checkoutButton.addTarget(self, action: #selector(didTapBeginButton(sender:)), for: .touchUpInside)
        
        loadCustomer()
    }

    @objc func didTapBeginButton(sender: AnyObject) {
//        alertPresenter.present(from: self,
//                               title: "Not Implemented",
//                               message: "This feature is not yet implemented.",
//                               dismissButtonTitle: "OK")
        
      //  let checkoutNavController = UINavigationController()
     //   let vc = checkoutNavController.children[0] as! CheckoutViewController
        
        let vc = CheckoutViewController()
        vc.transitioningDelegate = customModalTransitioningDelegate
        vc.modalPresentationStyle = .custom
        customModalTransitioningDelegate.currentPresentationStyle = .partiallyRevealed
        customModalTransitioningDelegate.isPresentingFromContainerView = true
        self.present(vc, animated: true, completion: nil)
    //    self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func loadCustomer() {
        showSpinner()
        mobileService.customer { result in
            self.hideSpinner()
            
            switch result {
            case let .success(customer):
                self.update(customer: customer)
            case let .failure(error):
                self.display(error: error)
            }
        }
    }
    
    private func display(error: Error) {
        alertPresenter.present(from: self,
                               title: "Unexpected Error",
                               message: "\(error)",
                               dismissButtonTitle: "OK")
    }
    
    private func update(customer: Customer) {
        beginCheckoutView.nameLabel.text = "Welcome, \(customer.name)!"
        beginCheckoutView.selfieImageView.sd_setImage(with: customer.selfieImageUrl)
        
        beginCheckoutView.selfieImageView.isHidden = false
        beginCheckoutView.nameLabel.isHidden = false
    }
    
    private func showSpinner() {
        beginCheckoutView.activityIndicatorView.startAnimating()
        beginCheckoutView.selfieImageView.isHidden = true
        beginCheckoutView.nameLabel.isHidden = true
    }
    
    private func hideSpinner() {
        self.beginCheckoutView.activityIndicatorView.stopAnimating()
    }
}
