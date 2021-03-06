//
//  DummyAsynchronousResizableCell.swift
//  BrickKit
//
//  Created by Ruben Cagnie on 10/1/16.
//  Copyright © 2016 Wayfair LLC. All rights reserved.
//

import UIKit
import BrickKit

class AsynchronousResizableBrick: Brick {
    var didChangeSizeCallBack: (() -> Void)?
    var newHeight: CGFloat = 200
}

class AsynchronousResizableBrickCell: BrickCell, Bricklike, AsynchronousResizableCell {
    typealias BrickType = AsynchronousResizableBrick

    weak var resizeDelegate: AsynchronousResizableDelegate?
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    var timer: NSTimer?

    override func updateContent() {
        super.updateContent()

        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(AsynchronousResizableBrickCell.fireTimer), userInfo: nil, repeats: false)
    }

    func fireTimer() {
        self.heightConstraint.constant = brick.newHeight
        self.resizeDelegate?.performResize(self, completion: { [weak self] (completed: Bool) in
            self?.brick.didChangeSizeCallBack?()
        })
    }
}

class DeinitNotifyingAsyncBrickCell: BrickCell, Bricklike, AsynchronousResizableCell {
    typealias BrickType = DeinitNotifyingAsyncBrick

    weak var resizeDelegate: AsynchronousResizableDelegate?

    override func updateContent() {
        super.updateContent()
        self.resizeDelegate?.performResize(self, completion: nil)
    }

    deinit {
        NSNotificationCenter.defaultCenter().postNotificationName("DeinitNotifyingAsyncBrickCell.deinit", object: nil)
    }
}

class DeinitNotifyingAsyncBrick: Brick {
    override class var cellClass: UICollectionViewCell.Type? {
        return DeinitNotifyingAsyncBrickCell.self
    }
}
