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
        createTableView()
        setupNavigationButtons()
        loadItems()
        
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
        
        bottomView.backgroundColor = .systemTeal
        itemTableView.backgroundColor = .systemPurple
      
        
        itemTableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.reuseIdentifier)
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
    }
}

extension CheckoutViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.reuseIdentifier, for: indexPath) as! TitleTableViewCell
        cell.brandLabel.text = items?[itemNum].brand
        cell.nameLabel.text = items?[itemNum].name
        return cell
    }
}
