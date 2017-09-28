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
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let navigationController = UINavigationController(rootViewController: SampleASCollectionViewController())
        present(navigationController, animated: true, completion: nil)
    }
}
