//
//  ChannelCollectionViewController.swift
//  IrregularCollectionUIKit_Example
//
//  Created by Steve Kim on 09/17/2016.
//  Copyright (c) 2016 Steve Kim. All rights reserved.
//

import UIKit

class ChannelCollectionViewController: ASIrregularCollectionViewController {
    let sizeArray = [400, 300, 200]
    let imageNames = ["201499971412727010.jpg", "99763_62164_3159.jpg", "7.jpg", "20160408110556_11.jpg", "201606100719471127_1.jpg", "article_20150904-1.jpg", "img_20150502111148_a5d91d53.jpg", "R1280x0.jpg"]
    
    var contents: [SampleContent]!
    var scrollViewDelegate: UIScrollViewDelegate?
    
    // MARK: - Overridden: IrregularCollectionViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionViewLayout.columnSpacing = 1
        self.collectionViewLayout.numberOfColumns = 3
        self.collectionViewLayout.headerHeight = 0
        self.collectionViewLayout.footerHeight = 0
        self.collectionViewLayout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1)
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        dispatch_barrier_async(dispatch_get_main_queue()) {
            let contents = self.createRandomSizeItems(1000)
            self.contents = contents
            self.reloadData()
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let contents = contents else {
            return 0
        }
        return contents.count
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return contents == nil ? 0 : 1
    }
    
    override func collectionView(collectionView: ASCollectionView, nodeBlockForItemAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
        return {
            let content = self.contents[indexPath.row]
            return DemoViewCellNode(content: content)
        }
    }
    
    override func collectionView(collectionView: ASCollectionView, nodeForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> ASCellNode {
        let textAttributes: [String: AnyObject]! = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline),
                                                    NSForegroundColorAttributeName: UIColor.grayColor()]
        let textInsets = UIEdgeInsetsMake(11, 11, 11, 0)
        let node = ASTextCellNode(attributes: textAttributes, insets: textInsets)
        node.text = "\(kind) \(indexPath.section + 1)"
        return node
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, originalItemSizeAtIndexPath indexPath: NSIndexPath) -> CGSize {
        guard let contents = contents else {
            return CGSizeZero
        }
        return CGSizeMake(CGFloat(contents[indexPath.row].width), CGFloat(contents[indexPath.row].height))
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if let scrollViewDelegate = scrollViewDelegate {
            scrollViewDelegate.scrollViewDidScroll?(scrollView)
        }
    }
    
    // MARK: - Private methods
    
    private func createRandomSizeItems(count: Int) -> [SampleContent] {
        var source: Array<SampleContent> = []
        for i in 0...count {
            let indexOfHeight = Int(rand()%Int32(sizeArray.count))
            let indexOfWidth = Int(rand()%Int32(sizeArray.count))
            let content = SampleContent(width: sizeArray[indexOfWidth], height: sizeArray[indexOfHeight])
            content.url = imageNames[i%imageNames.count]
            source.append(content)
        }
        return source
    }
    
    private func createStaticItems() -> [SampleContent] {
        return [
            SampleContent(width: 300, height: 300),
            SampleContent(width: 400, height: 300),
            SampleContent(width: 400, height: 300),
            SampleContent(width: 400, height: 200),
            SampleContent(width: 400, height: 300),
            SampleContent(width: 400, height: 300),
            SampleContent(width: 400, height: 300),
            SampleContent(width: 400, height: 300),
            SampleContent(width: 400, height: 300),
            SampleContent(width: 400, height: 300),
            SampleContent(width: 400, height: 200),
            SampleContent(width: 400, height: 300),
            SampleContent(width: 400, height: 300),
            SampleContent(width: 400, height: 300),
            SampleContent(width: 400, height: 300),
            SampleContent(width: 400, height: 300),
            SampleContent(width: 400, height: 300),
            SampleContent(width: 400, height: 200),
            SampleContent(width: 400, height: 300),
            SampleContent(width: 200, height: 300),
            SampleContent(width: 200, height: 300),
            SampleContent(width: 200, height: 300),
            SampleContent(width: 200, height: 300),
            SampleContent(width: 400, height: 300),
            SampleContent(width: 400, height: 200),
            SampleContent(width: 400, height: 300),
            SampleContent(width: 400, height: 300),
            SampleContent(width: 400, height: 300),
            SampleContent(width: 400, height: 300)
        ]
    }
}

class DemoViewCellNode: ASCellNode {
    var imageNode: ASImageNode!
//    var textNode: ASTextNode!
    
    var textAttributes: [String : AnyObject]! {
        return [
            NSFontAttributeName: UIFont.systemFontOfSize(14),
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
    }
    
    convenience init(content: SampleContent!) {
        self.init()
        
        imageNode = ASImageNode()
        imageNode.image = UIImage(named: content.url!)
        imageNode.backgroundColor = UIColor.lightGrayColor()
        
//        textNode = ASTextNode()
//        textNode.attributedText = NSAttributedString(string: text, attributes: textAttributes)
        
        self.addSubnode(imageNode)
//        self.addSubnode(textNode)
    }
    
//    override func layout() {
//        super.layout()
//        
//        imageNode.frame = self.bounds
//    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASRelativeLayoutSpec .relativePositionLayoutSpecWithHorizontalPosition(ASRelativeLayoutSpecPosition.Start, verticalPosition: ASRelativeLayoutSpecPosition.Start, sizingOption: ASRelativeLayoutSpecSizingOption.Default, child: imageNode)
    }
}