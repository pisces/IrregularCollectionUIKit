//
//  ChannelViewController.swift
//  IrregularCollectionUIKit
//
//  Created by pisces on 9/19/16.
//  Copyright © 2016 Steve Kim. All rights reserved.
//

import Foundation
import UIKit

class ChannelViewController: UIViewController, UICollectionViewDelegate {
    
    // MARK: - Properties
    
    @IBOutlet private weak var channelProfileViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var channelProfileViewTop: NSLayoutConstraint!
    @IBOutlet private weak var channelProfileView: UIImageView!
    
    private var originContentOffset: CGPoint?
    private var collectionViewController: ChannelCollectionViewController!
    
    private var maskLayer: CAShapeLayer {
        get {
            let maskLayer = CAShapeLayer()
            let maskRect = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), channelProfileViewHeight.constant + channelProfileViewTop.constant)
            maskLayer.path = CGPathCreateWithRect(maskRect, nil)
            return maskLayer
        }
    }
    
    // MARK: - Overridden: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewController = ChannelCollectionViewController()
        collectionViewController.scrollViewDelegate = self
        
        self.addChildViewController(collectionViewController)
        self.view.addSubview(collectionViewController.view)
        self.view.addSubview(channelProfileView)
        
        collectionViewController.collectionView.contentInset = UIEdgeInsetsMake(channelProfileViewHeight.constant, 0, 0, 0)
        
        let collectionViewLeading = NSLayoutConstraint(item: collectionViewController.view, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 0)
        let collectionViewTop = NSLayoutConstraint(item: collectionViewController.view, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 0)
        let collectionViewTrailing = NSLayoutConstraint(item: collectionViewController.view, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: 0)
        let collectionViewBottom = NSLayoutConstraint(item: collectionViewController.view, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0)
        
        self.view.addConstraints([collectionViewLeading, collectionViewTop, collectionViewTrailing, collectionViewBottom])
    }
    
    // MARK: - UIScrollView delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        channelProfileViewTop.constant = min(0, (scrollView.contentInset.top + scrollView.contentOffset.y) * -0.5)
        channelProfileView.layer.mask = maskLayer
        
//        let scale = max(1, abs(scrollView.contentOffset.y)/scrollView.contentInset.top)
//        channelProfileView.transform = CGAffineTransformMakeScale(scale, scale)
        
        if let originContentOffset = originContentOffset {
            if (scrollView.contentOffset.y-0.25) > -scrollView.contentInset.top && scrollView.contentOffset.y < scrollView.contentSize.height-CGRectGetHeight(scrollView.frame) {
                let dy = originContentOffset.y - scrollView.contentOffset.y
                
                UIView.animateWithDuration(1.0, animations: {
                    self.navigationController?.navigationBar.alpha = dy < 0 ? 0 : 1
                })
            }
        }
        
        originContentOffset = scrollView.contentOffset
    }
}
