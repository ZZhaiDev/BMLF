//
//  ZJAddAptDateCell.swift
//  BMLF
//
//  Created by zijia on 5/18/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
private let cellId = "cellId"

class ZJAddAptDateCell: UICollectionViewCell {
    lazy var tableView: UITableView = {
       let tv = UITableView()
        tv.dataSource = self
        tv.delegate = self
        tv.backgroundColor = .clear
        tv.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        return tv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(tableView)
        tableView.fillSuperview()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ZJAddAptDateCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .clear
        cell.textLabel?.text = "日期"
        return cell
    }

}
