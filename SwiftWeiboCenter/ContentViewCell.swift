//
//  ContentViewCell.swift
//  SwiftWeiboCenter
//
//  Created by Ye on 4/26/17.
//  Copyright © 2017 Ye. All rights reserved.
//

import UIKit

protocol ContentViewCellDelegate:class {
    func dl_contentViewCellDidRecieveFinishRefreshingNotificaiton(cell:ContentViewCell)
}

class ContentViewCell: UITableViewCell,UIPageViewControllerDelegate,UIPageViewControllerDataSource,BaseTableViewControllerDelegate,UIScrollViewDelegate {

    private var dataArray = [BaseTableViewController]()
    private var pageScrollView:UIScrollView!
    private var pageViewCtrl:UIPageViewController!
    
    weak var delegate:ContentViewCellDelegate?
    class func regisCellForTable(tableView:UITableView) {
        tableView.register(ContentViewCell.self, forCellReuseIdentifier: "cellid")
    }
    
    class func dequeueCellForTableView(tableView:UITableView) -> ContentViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cellid") as! ContentViewCell
    }
    
    var canScroll = false {
        didSet {
            for ctrl in self.dataArray {
                ctrl.canScroll = canScroll
                if !canScroll {
                    ctrl.tableView.contentOffset = CGPoint.zero
                }
            }
        }
    }
    var selectIndex = 0 {
        didSet {
            self.pageViewCtrl.setViewControllers([self.dataArray[selectIndex]], direction: .forward, animated: false, completion: nil)
        }
    }
    
    func setPageView() {
        self.customPageView()
    }
    
    func dl_refresh() {
        self.dataArray[self.selectIndex].dl_refresh()
    }
    
    func dl_viewControllerDidFinishRefresh(viewController: BaseTableViewController) {
        self.delegate?.dl_contentViewCellDidRecieveFinishRefreshingNotificaiton(cell: self)
    }
    
    private func customPageView() {
        let option = NSMutableDictionary()
        option[UIPageViewControllerOptionSpineLocationKey] = UIPageViewControllerSpineLocation.mid
        self.pageViewCtrl = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: (option as! [String : Any]))
        self.pageViewCtrl.dataSource = self
        self.pageViewCtrl.delegate = self
        let ctrl1 = LeftTableViewController()
        ctrl1.delegate = self
        let ctrl2 = MiddleViewController()
        ctrl2.delegate = self
        let ctrl3 = RightViewController()
        ctrl3.delegate = self
        
        self.dataArray.append(ctrl1)
        self.dataArray.append(ctrl2)
        self.dataArray.append(ctrl3)
        self.pageViewCtrl.setViewControllers([self.dataArray[0]], direction: .forward, animated: true, completion: nil)
        self.contentView.addSubview(self.pageViewCtrl.view)
        for view in self.pageViewCtrl.view.subviews {
            if view.isKind(of: UIScrollView.self) {
                self.pageScrollView = view as! UIScrollView
                self.pageScrollView.addObserver(self, forKeyPath: "panGestureRecognizer.state", options: .new, context: nil)
                
            }
        }
        self.pageViewCtrl.view.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let scrollView = object as! UIScrollView
        if scrollView.panGestureRecognizer.state == .changed {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"PageViewGestureState"), object: "changed")
        }else if scrollView.panGestureRecognizer.state == .ended {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"PageViewGestureState"), object: "ended")
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = false
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController =  viewController as? BaseTableViewController {
            let index = self.dataArray.index(of: viewController)
            if index == 0 || index == NSNotFound {
                return nil
            }
            let selected = self.dataArray.index(before: index!)
            return self.dataArray[selected]
        }
        return nil
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController =  viewController as? BaseTableViewController {
            let index = self.dataArray.index(of: viewController)
            if index == self.dataArray.count - 1 || index == NSNotFound {
                return nil
            }
            let selected = self.dataArray.index(after: index!)
            return self.dataArray[selected]
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let viewController =  self.pageViewCtrl.viewControllers?.first as? BaseTableViewController {
            let index = self.dataArray.index(of: viewController)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"CenterPageViewScroll"), object: NSNumber.init(value: index!))
        }
        
    }
    
}
