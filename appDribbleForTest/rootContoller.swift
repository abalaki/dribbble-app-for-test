//
//  ViewController.swift
//  Dribbble
//
//  Created by аймак on 25.08.17.
//  Copyright © 2017 Kaplya LLC. All rights reserved.
//

import UIKit

class rootViewController: UIViewController, PRrootContoroller {
    
    var table:shotsTableView!
    var isDataLoaded:Bool = false
    let acticityIndicator = UIActivityIndicatorView()
    var nowPage:Int = 1
    let refresher = UIRefreshControl()
    var isFetching:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isDataLoaded == false { fetchData(page: nowPage) }
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.white
        let naviBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 64))
        let titleItem = UINavigationItem(title: "Shots")
        naviBar.setItems([titleItem], animated: false)
        naviBar.isTranslucent = true
        
        table = shotsTableView(frame: CGRect.init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), style: .plain)
        table.isHidden = true
        view.addSubview(table)
        acticityIndicator.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        view.addSubview(acticityIndicator)
        acticityIndicator.activityIndicatorViewStyle = .gray
        acticityIndicator.center = view.center
        acticityIndicator.startAnimating()
        acticityIndicator.hidesWhenStopped = true
        view.addSubview(naviBar)
        table.addSubview(refresher)
        refresher.tintColor = UIColor.white
        refresher.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        table.rootDelegate = self
    }
    
    func fetchData(page:Int) {
        isDataLoaded = true
        let fetch = request()
        fetch.fetch(method: "shots", parameters: "list=attachments,debuts,playoffs,rebounds,teams&page=\(page)&per_page=50") { (spshots) in
            if spshots.isSuccess == false {
                if self.nowPage == 1 {
                    self.showAlert(title: "Ошибка", msg: "Произошла ошибка при загрузке данных. Вам будут показаны данные из последнего успешного запроса.")
                    self.refresher.endRefreshing()
                    self.table.isScrollEnabled = true
                    self.fetchLocalData()
                } else {
                    self.showAlert(title: "Ошибка", msg: "Произошла ошибка при загрузке данных.")
                }
            } else {
                if self.nowPage == 1 { fetchShots.removeAll() }
                self.nowPage = self.nowPage + 1
                self.isFetching = false
                if self.refresher.isRefreshing == true {
                    fetchShots = spshots.shots
                    self.refresher.endRefreshing()
                    self.table.isScrollEnabled = true
                }
                else { fetchShots.append(contentsOf: spshots.shots) }
                DispatchQueue.main.async {
                    self.acticityIndicator.stopAnimating()
                    self.table.reloadData()
                    self.table.isHidden = false
                }
            }
        }
    }
    
    func showAlert(title:String?, msg:String?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let alertaction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertaction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func refreshData() {
        table.isScrollEnabled = false
        fetchData(page: 1)
    }
    
    func pullDownToRefresh() {
        if isFetching == false && nowPage > 1 {
            isFetching = true
            fetchData(page: nowPage)
        }
    }
    
    func fetchLocalData() {
        let fetch = request()
        fetch.fetchLocal { (spshots) in
            if spshots.isSuccess == true {
                fetchShots = spshots.shots
                DispatchQueue.main.async {
                    self.acticityIndicator.stopAnimating()
                    self.table.reloadData()
                    self.table.isHidden = false
                }
            }
        }
    }
}

protocol PRrootContoroller {
    func pullDownToRefresh()
}
