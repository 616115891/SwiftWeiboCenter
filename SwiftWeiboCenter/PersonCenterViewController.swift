//
//  PersonCenterViewController.swift
//  SwiftWeiboCenter
//
//  Created by Ye on 4/26/17.
//  Copyright © 2017 Ye. All rights reserved.
//

import UIKit

class PersonCenterViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    var canScroll = false
    @IBOutlet weak var tableView: PersonTableView!
    var stretchableTableHeaderView = HFStretchableTableHeaderView()
    var userHeadView = UserHeadView.userHeaderView()
    lazy var segment:YUSegment = {
        var segment = YUSegment(titles: ["Profile","Weibo","Album"])
        segment.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44)
        segment.backgroundColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 1)
        segment.textColor = UIColor(colorLiteralRed: 0.53, green: 0.53, blue: 0.53, alpha: 1)
        segment.selectedTextColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1.0)
        segment.indicator.backgroundColor = UIColor(colorLiteralRed: 0.08, green: 0.77, blue: 1.0, alpha: 1)
        segment.addTarget(self, action: #selector(onSegmentChange), for: .valueChanged)
        return segment
    }()
    
    var contentCell:ContentViewCell!
    
    //监听segment的变化
    func onSegmentChange() {
        //改变pageView的页码
        self.contentCell.selectIndex = Int(self.segment.selectedIndex)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UIconfig()
        self.addNotification()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    func UIconfig() {
        self.canScroll = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.showsVerticalScrollIndicator = false
        ContentViewCell.regisCellForTable(tableView: self.tableView)
        self.stretchableTableHeaderView.stretchHeader(for: self.tableView, with: self.userHeadView)
        
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(onPageViewCtrlChange), name: NSNotification.Name(rawValue:"CenterPageViewScroll"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onOtherScrollToTop), name: NSNotification.Name(rawValue:"kLeaveTopNtf"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onScrollBottomView), name: NSNotification.Name(rawValue:"PageViewGestureState"), object: nil)
    }
    
    func onPageViewCtrlChange(ntf:NSNotification) {
        self.segment.selectedIndex = ntf.object as! UInt
    }
    
    func onOtherScrollToTop(ntf:NSNotification){
        self.canScroll = true
        self.contentCell.canScroll = false
    }
    
    func onScrollBottomView(ntf:NSNotification) -> Void {
        let string = ntf.object as! String
        if string == "ended" {
            self.tableView.isScrollEnabled = true
        }else {
            self.tableView.isScrollEnabled = false
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height - 44
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.segment
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (self.contentCell == nil) {
            self.contentCell = ContentViewCell.dequeueCellForTableView(tableView: tableView)
            self.contentCell.selectionStyle = .none
//            self.contentCell.delegate = self
            self.contentCell.setPageView()
        }
        return self.contentCell
    }
    
    override func viewDidLayoutSubviews() {
        self.stretchableTableHeaderView.resizeView()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //下拉放大 必须实现
        self.stretchableTableHeaderView.scrollDidScroll(scrollView)
        
        //计算导航栏的透明度
//        let minAlphaOffset:CGFloat = 0;
//        let maxAlphaOffset = UIScreen.main.bounds.width  / 1.34 - 64;
//        let offset = scrollView.contentOffset.y;
//        let alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
//        self.userPageNavBar.dl_alpha = alpha;
        
        
        //子控制器和主控制器之间的滑动状态切换
        
        let tabOffsetY = tableView.rect(forSection: 0).origin.y
        if (scrollView.contentOffset.y >= tabOffsetY) {
            scrollView.contentOffset = CGPoint(x:0,y:tabOffsetY);
            if (self.canScroll) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:"kScrollToTopNtf"), object: NSNumber(value: 1))
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"kScrollToTopNtf" object:@1];
                self.canScroll = false;
                self.contentCell.canScroll = true
            }
        } else {
            if (!self.canScroll) {
                scrollView.contentOffset = CGPoint(x:0, y:tabOffsetY);
            }
        }
    }

}
