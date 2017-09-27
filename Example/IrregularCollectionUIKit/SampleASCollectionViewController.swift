//
//  SampleASCollectionViewController.swift
//  IrregularCollectionUIKit_Example
//
//  Created by Steve Kim on 09/17/2016.
//  Modified by Steve Kim on 09/27/2017.
//  Copyright (c) 2016-2017 Steve Kim. All rights reserved.
//

import UIKit

class SampleASCollectionViewController: ASIrregularCollectionViewController {
    let sizeArray = [400, 300, 200]
    let imageNames = ["201499971412727010.jpg", "99763_62164_3159.jpg", "7.jpg", "20160408110556_11.jpg", "201606100719471127_1.jpg", "article_20150904-1.jpg", "img_20150502111148_a5d91d53.jpg", "R1280x0.jpg"]
    
    weak var scrollViewDelegate: UIScrollViewDelegate?
    var contents: [SampleContent] = [] {
        didSet {
            reloadData()
        }
    }
    
    // MARK: - Overridden: ASIrregularCollectionViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewLayout.columnSpacing = 1
        collectionViewLayout.numberOfColumns = 3
        collectionViewLayout.headerHeight = 0
        collectionViewLayout.footerHeight = 0
        collectionViewLayout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstViewAppearence {
            contents = createRandomSizeItems(1000)
        }
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }
    override func collectionView(_ collectionView: ASCollectionView, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            let content = self.contents[indexPath.row]
            return DemoViewCellNode(content: content)
        }
    }
    override func collectionView(_ collectionView: ASCollectionView, nodeForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNode {
        let textAttributes: [String: AnyObject]! = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .headline),
                                                    NSForegroundColorAttributeName: UIColor.gray]
        let textInsets = UIEdgeInsetsMake(11, 11, 11, 0)
        let node = ASTextCellNode(attributes: textAttributes, insets: textInsets)
        node.text = "\(kind) \(indexPath.section + 1)"
        return node
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, originalItemSizeAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(contents[indexPath.row].width), height: CGFloat(contents[indexPath.row].height))
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let scrollViewDelegate = scrollViewDelegate {
            scrollViewDelegate.scrollViewDidScroll?(scrollView)
        }
    }
    
    // MARK: - Private methods
    
    private func createRandomSizeItems(_ count: Int) -> [SampleContent] {
        var source: Array<SampleContent> = []
        for i in 0...count {
            let indexOfHeight = Int(arc4random()%UInt32(sizeArray.count))
            let indexOfWidth = Int(arc4random()%UInt32(sizeArray.count))
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
    var textAttributes: [String : AnyObject]! {
        return [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.white
        ]
    }
    
    convenience init(content: SampleContent!) {
        self.init()
        
        imageNode = ASImageNode()
        imageNode.image = UIImage(named: content.url!)
        imageNode.backgroundColor = .lightGray
        
        self.addSubnode(imageNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASRelativeLayoutSpec.relativePositionLayoutSpec(withHorizontalPosition: ASRelativeLayoutSpecPosition(rawValue: 0), verticalPosition: ASRelativeLayoutSpecPosition(rawValue: 0), sizingOption: ASRelativeLayoutSpecSizingOption(rawValue: 0), child: imageNode)
    }
}
