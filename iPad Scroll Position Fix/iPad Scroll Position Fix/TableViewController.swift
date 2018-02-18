//
//  TableViewController.swift
//  iPad Scroll Position Fix
//
//  Created by John Brayton on 2/18/18.
//  Copyright © 2018 John Brayton. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    let incorporateFix = true
    
    var scrollPositionFix: GHSScrollPositionFix?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        if self.incorporateFix {
            self.scrollPositionFix = GHSScrollPositionFix(scrollView: self.tableView)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String.localizedStringWithFormat("Row %ld", indexPath.row+1)
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("view will transition to \(size.width)x\(size.height)")
        super.viewWillTransition(to: size, with: coordinator)
        self.scrollPositionFix?.viewWillTransition(to: size, with: coordinator)
    }

}
