//
//  MineViewController.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 1/4/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit

class MineViewController: UIViewController {

    private lazy var myArray: Array = {
        return [[["icon":"mine_feedBack", "title": "Talk to CarloudyNews"],
                 ["icon":"mine_setting", "title": "Carloudy Setting"]],

                [["icon":"mine_feedBack", "title": "夜间模式"],
                 ["icon":"mine_mail", "title": "我要反馈"],
                 ["icon":"mine_judge", "title": "给我们评分"]],

            [["icon":"mine_feedBack", "title": "about"],
             ["icon":"mine_mail", "title": "feedback"],
             ["icon":"mine_judge", "title": "rate"]],

            [["icon":"mine_feedBack", "title": "about"],
             ["icon":"mine_mail", "title": "feedback"],
             ["icon":"mine_judge", "title": "rate"]],

            [["icon":"mine_feedBack", "title": "about"],
             ["icon":"mine_mail", "title": "feedback"],
             ["icon":"mine_judge", "title": "rate"]]
        ]

    }()

    private lazy var head: MineHead = {
        return MineHead(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
    }()

    let cellId = "cellId"
    lazy var tableView: UITableView = {
        let tView = UITableView(frame: .zero, style: .grouped)
        tView.backgroundColor = UIColor.background
        tView.delegate = self
        tView.dataSource = self
        tView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        return tView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .white
    }
}

extension MineViewController {

    fileprivate func setupUI() {
        view.addSubview(tableView)
        navigationItem.title = "Setting"
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        tableView.parallaxHeader.view = head
        tableView.parallaxHeader.height = 200
        tableView.parallaxHeader.minimumHeight = 0
        tableView.parallaxHeader.mode = .topFill
    }

    @objc fileprivate func imageClicked() {
        UIView.animate(withDuration: 0.3) {
        }
    }
}

extension MineViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return myArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionArray = myArray[section]
        return sectionArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        let sectionArray = myArray[indexPath.section]
        let dict: [String: String] = sectionArray[indexPath.row]
        cell.imageView?.image = UIImage(named: dict["icon"] ?? "")
        cell.textLabel?.text = dict["title"]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == [0, 0] {
            let talkToNews = UIViewController()
            navigationController?.pushViewController(talkToNews, animated: true)
        } else if indexPath == [0, 1] {
            let csVC = InfoController()
            navigationController?.pushViewController(csVC, animated: true)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > -30 {
            self.navigationController?.navigationBar.alpha = 1
        } else if scrollView.contentOffset.y > -(zjStatusHeight+100) {
            UIView.animate(withDuration: 0.5) {
                self.navigationController?.navigationBar.alpha = (scrollView.contentOffset.y+80)*0.02
                self.navigationController?.navigationBar.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.0) {
                self.navigationController?.navigationBar.alpha = 0
                self.navigationController?.navigationBar.isHidden = true
            }
        }

    }

}
