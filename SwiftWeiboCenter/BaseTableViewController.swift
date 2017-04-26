//
//  BaseTableViewController.swift
//  SwiftWeiboCenter
//
//  Created by Ye on 4/26/17.
//  Copyright © 2017 Ye. All rights reserved.
//

import UIKit

protocol BaseTableViewControllerDelegate:class {
    func dl_viewControllerDidFinishRefresh(viewController:BaseTableViewController)
}

class BaseTableViewController: UITableViewController {

    weak var delegate:BaseTableViewControllerDelegate?
    
    var canScroll = false
    var isRefreshing = false
    //判断手指是否离开
    private var isTouch = false
    
    deinit {
        print("BaseTableViewController deinit")
    }
    
    func dl_refresh() {
        if !self.isRefreshing {
            self.isRefreshing = true
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                DispatchQueue.main.async {
                    self.delegate?.dl_viewControllerDidFinishRefresh(viewController: self)
                    self.isRefreshing = false
                }
                
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.showsVerticalScrollIndicator = false
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isTouch = true
    }
    
    ///用于判断手指是否离开了 要做到当用户手指离开了，tableview滑道顶部，也不显示出主控制器
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("手指离开了")
        self.isTouch = false
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !self.canScroll {
            scrollView.setContentOffset(CGPoint.zero, animated: false)
        }
        let offsetY = scrollView.contentOffset.y
        if offsetY<0 {
            if !self.isTouch {
                return
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"kLeaveTopNtf"), object: nil)
            self.canScroll = false
            scrollView.contentOffset = CGPoint.zero
        }
    }

}
