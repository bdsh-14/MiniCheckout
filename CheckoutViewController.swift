//
//  CheckoutViewController.swift
//  MiniCheckout
//
//  Created by Bidisha Biswas on 11/23/20.
//  Copyright © 2020 Stitch Fix. All rights reserved.
//

import UIKit

class CheckoutViewController: UIViewController {
    
    var itemTableView = UITableView()
    var bottomView = UIView()
    var rightButton = LeftRightButton(frame: .zero)
    var leftButton = LeftRightButton(frame: .zero)
    var items: [Item]?
    var itemNum = 0
    var item: Item?
    private let mobileService: MobileService_Protocol
    private let alertPresenter: AlertPresenter_Proto
    lazy var customModalTransitioningDelegate = CustomModalPresentationManager()
    
    init(alertPresenter: AlertPresenter_Proto = AlertPresenter(),
         mobileService: MobileService_Protocol = MobileService()) {
        self.alertPresenter = alertPresenter
        self.mobileService = mobileService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Checkout Items"
        let barbutton = UIBarButtonItem(title: "Checkout", style: .plain, target: self, action: #selector(backPressed))
        self.navigationItem.leftBarButtonItem = barbutton
        createTableView()
        setupNavigationButtons()
        loadItems()
        if itemNum == 0 {
            leftButton.isHidden = true
        }
        rightButton.isHidden = (items?.count == itemNum + 1)
    }
    
    @objc func backPressed() {
        self.navigationController?.popToRootViewController(animated: true)
       // dismiss(animated: true, completion: nil)
    }
    
    func loadItems() {
        mobileService.getItems { (result) in
            switch result {
            case let .success(items):
                self.items = items
                self.itemTableView.reloadData()
                for i in items {
                    print(i.name)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    //caching
    func createTableView() {
        view.addSubview(itemTableView)
        view.addSubview(bottomView)
        bottomView.backgroundColor = .white
        NSLayoutConstraint.activate([
            itemTableView.topAnchor.constraint(equalTo: view.topAnchor),
            itemTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            itemTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            itemTableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        itemTableView.register(TextTableViewCell.self, forCellReuseIdentifier: TextTableViewCell.reuseIdentifier)
        itemTableView.register(ItemImageTableViewCell.self, forCellReuseIdentifier: ItemImageTableViewCell.reuseIdentifier)

        itemTableView.tableFooterView = UIView()
        itemTableView.separatorStyle = .none
        itemTableView.dataSource = self
        itemTableView.rowHeight = UITableView.automaticDimension
        itemTableView.estimatedRowHeight = 100
        itemTableView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupNavigationButtons() {
        bottomView.addSubview(leftButton)
        bottomView.addSubview(rightButton)
        if #available(iOS 13.0, *) {
            let leftButtonImage = UIImage(systemName: "chevron.left.circle.fill",
                                          withConfiguration: UIImage.SymbolConfiguration(pointSize: 70, weight: .heavy, scale: .medium))?.withTintColor(.cyan)
            let rightButtonImage = UIImage(systemName: "chevron.right.circle.fill",
                                           withConfiguration: UIImage.SymbolConfiguration(pointSize: 70, weight: .heavy, scale: .medium))?.withTintColor(.cyan)
            leftButton.setImage(leftButtonImage, for: .normal)
            rightButton.setImage(rightButtonImage, for: .normal)
        } else {
            leftButton.setTitle("Previous", for: .normal)
            rightButton.setTitle("Next", for: .normal)
        }

        NSLayoutConstraint.activate([
            leftButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            leftButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 20),
            rightButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            rightButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -20),
        ])
       
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
    }
    
    @objc func leftButtonTapped(_ sender: UIButton) {
        if itemNum > 0 {
            itemNum -= 1
            let vc = CheckoutViewController()
            vc.itemNum = itemNum
            vc.transitioningDelegate = customModalTransitioningDelegate
            vc.modalPresentationStyle = .currentContext
            customModalTransitioningDelegate.currentPresentationStyle = .partiallyRevealed
            customModalTransitioningDelegate.isPresentingFromContainerView = true
            self.navigationController?.popViewController(animated: true)

           // self.present(vc, animated: true, completion: nil)
        } else if itemNum == 0 {
            leftButton.isHidden = true
        }
    }
    
    @objc func rightButtonTapped(_ sender: UIButton) {
        guard let items = items else { return }
        if itemNum < items.count - 1 {
            itemNum += 1
            let vc = CheckoutViewController()
            vc.itemNum = itemNum
            vc.transitioningDelegate = customModalTransitioningDelegate
            vc.modalPresentationStyle = .custom
            customModalTransitioningDelegate.currentPresentationStyle = .partiallyRevealed
            customModalTransitioningDelegate.isPresentingFromContainerView = true
            self.navigationController?.pushViewController(vc, animated: true)

          //  self.present(vc, animated: true, completion: nil)
        } else if itemNum == items.count - 1 {
                    alertPresenter.present(from: self,
                                           title: "End of list",
                                           message: "",
                                           dismissButtonTitle: "OK")
            rightButton.isHidden = true
        }
    }
}

extension CheckoutViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let items = items else { return UITableViewCell() }
        switch indexPath.row {
        case 0: // Brand and name
            let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.reuseIdentifier, for: indexPath) as! TextTableViewCell
            cell.brandLabel.text = items[itemNum].brand
            cell.nameLabel.text = items[itemNum].name
            return cell
        case 1: // Image
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemImageTableViewCell.reuseIdentifier, for: indexPath) as! ItemImageTableViewCell
            cell.imageUrl = items[itemNum].imageUrl
            return cell
        default: // size and price
            let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.reuseIdentifier, for: indexPath) as! TextTableViewCell
            cell.brandLabel.text = "Size: \(items[itemNum].size)"
            
            cell.nameLabel.text = " Price: $\(items[itemNum].price)"
            return cell
        }
    }
}
