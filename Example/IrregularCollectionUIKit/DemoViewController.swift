//
//  DemoViewController.swift
//  IrregularCollectionUIKit
//
//  Created by pisces on 9/19/16.
//  Copyright © 2016 Steve Kim. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controller = ChannelViewController(nibName: "ChannelView", bundle: NSBundle.mainBundle())
        
        self.presentViewController(controller, animated: false, completion: nil)
    }
}
