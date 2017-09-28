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
    var contents = [SampleContent]()
    
    // MARK: - Overridden: ASIrregularCollectionViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sample"
        edgesForExtendedLayout = .top
        collectionViewLayout.columnSpacing = 1
        collectionViewLayout.numberOfColumns = 3
        collectionViewLayout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstViewAppearence {
            contents = createRandomSizeItems(1000)
            reloadData()
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
            return SampleViewCellNode(content: self.contents[indexPath.item])
        }
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, originalItemSizeAt indexPath: IndexPath) -> CGSize {
        let content = contents[indexPath.item]
        return CGSize(width: CGFloat(content.width), height: CGFloat(content.height))
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

class SampleViewCellNode: ASCellNode {
    private var content: SampleContent?
    private lazy var imageNode: ASImageNode = {
        let node = ASImageNode()
        node.backgroundColor = .lightGray
        node.contentMode = .scaleAspectFill
        return node
    }()
    
    convenience init(content: SampleContent) {
        self.init()
        
        self.content = content
        addSubnode(imageNode)
    }
    
    override func clearFetchedData() {
        super.clearFetchedData()
        
        imageNode.image = nil
    }
    override func fetchData() {
        super.fetchData()
        
        if let url = content?.url {
            imageNode.image = UIImage(named: url)
        }
        setNeedsLayout()
    }
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let imageNodeSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 0, 0, 0), child: imageNode)
        return ASStaticLayoutSpec(children: [imageNodeSpec])
    }
}
