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
    lazy var customModalTransitioningDelegate = CustomModalPresentationManager()
    
    
    init(mobileService: MobileService_Protocol = MobileService()) {
        self.mobileService = mobileService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Checkout Items"
        let button = UIBarButtonItem(title: "Begin Checkout", style: .plain, target: self, action: #selector(backPressed))
        self.navigationItem.leftBarButtonItem = button
        createTableView()
        setupNavigationButtons()
        loadItems()
        
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
        
        itemTableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.reuseIdentifier)
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
                                          withConfiguration: UIImage.SymbolConfiguration(pointSize: 70, weight: .heavy, scale: .medium))?.withTintColor(.systemGreen)
            let rightButtonImage = UIImage(systemName: "chevron.right.circle.fill",
                                           withConfiguration: UIImage.SymbolConfiguration(pointSize: 70, weight: .heavy, scale: .medium))?.withTintColor(.systemGreen)
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
//        guard let itemsCount = items?.count else { ret
//        if itemNum == items?.count ?? 0 - 1 {
//            rightButton.isHidden = true
//        } else if itemNum == 0 {
//            leftButton.isHidden = true
//        }
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
        } else {
            rightButton.isHidden = true
        }
    }
}
    

extension CheckoutViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let items = items else { return UITableViewCell() }
        switch indexPath.row {
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.reuseIdentifier, for: indexPath) as! TitleTableViewCell
            cell.brandLabel.text = items[itemNum].brand
            cell.nameLabel.text = items[itemNum].name
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemImageTableViewCell.reuseIdentifier, for: indexPath) as! ItemImageTableViewCell
            cell.imageUrl = items[itemNum].imageUrl
            return cell
        }
    }
}
