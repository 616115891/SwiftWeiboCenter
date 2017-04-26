//
//  PersonTableView.swift
//  SwiftWeiboCenter
//
//  Created by Ye on 4/26/17.
//  Copyright © 2017 Ye. All rights reserved.
//

import UIKit

class PersonTableView: UITableView,UIGestureRecognizerDelegate {
    //允许同时识别多个手势
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
