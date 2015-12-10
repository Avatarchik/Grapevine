//
//  OverlayView.swift
//  Grapevine
//
//  Referenced from TinderSwipeCardsSwift created by Gao Chao
//  https://github.com/reterVision/TinderSwipeCardsSwift
//
//  Created by Jenny Yang on 12/6/15.
//  Copyright © 2015 Jenny Yang. All rights reserved.
//

import Foundation
import UIKit

enum GGOverlayViewMode {
    case GGOverlayViewModeLeft
    case GGOverlayViewModeRight
}

class OverlayView: UIView{
    var _mode: GGOverlayViewMode! = GGOverlayViewMode.GGOverlayViewModeLeft
    var imageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(image: UIImage(named: "nah"))
        self.addSubview(imageView)
    }
    
    func setMode(mode: GGOverlayViewMode) -> Void {
        if _mode == mode {
            return
        }
        _mode = mode
        
        if _mode == GGOverlayViewMode.GGOverlayViewModeLeft {
            imageView.image = UIImage(named: "nah")
            imageView.frame = CGRectMake(50, 30, 156, 131)
        } else {
            imageView.image = UIImage(named: "interested")
            imageView.frame = CGRectMake(0, 30, 285, 187)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}