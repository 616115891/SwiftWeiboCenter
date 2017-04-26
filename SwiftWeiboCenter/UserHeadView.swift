//
//  UserHeadView.swift
//  SwiftWeiboCenter
//
//  Created by Ye on 4/26/17.
//  Copyright © 2017 Ye. All rights reserved.
//

import UIKit

class UserHeadView: UIView {

    class func userHeaderView() -> UserHeadView {
        return Bundle.main.loadNibNamed("UserHeadView", owner: nil, options: nil)?.first as! UserHeadView
    }

}
