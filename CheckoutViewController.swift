//
//  CheckoutViewController.swift
//  MiniCheckout
//
//  Created by Bidisha Biswas on 11/23/20.
//  Copyright © 2020 Stitch Fix. All rights reserved.
//

import UIKit

class CheckoutViewController: UIViewController {
    
    var itemTableView: UITableView!
    var items: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Checkout Items"
        view.backgroundColor = .systemPink
    }
    
    
    func createTableView() {
        itemTableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(itemTableView)
        navigationController?.navigationBar.prefersLargeTitles = false
        itemTableView.tableFooterView = UIView()
        itemTableView.estimatedRowHeight = 120
        itemTableView.separatorStyle = .none
        itemTableView.allowsSelection = false
        itemTableView.dataSource = self
        itemTableView.rowHeight = UITableView.automaticDimension
        itemTableView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
}

extension CheckoutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        return cell
    }
    
}
