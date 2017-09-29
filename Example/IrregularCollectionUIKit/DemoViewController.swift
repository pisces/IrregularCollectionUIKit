//
//  DemoViewController.swift
//  IrregularCollectionUIKit
//
//  Created by pisces on 9/19/16.
//  Copyright © 2016 Steve Kim. All rights reserved.
//

import UIKit

class DemoViewController: IrregularCollectionViewController {
    let sizeArray = [400, 300, 200]
    let imageNames = ["201499971412727010.jpg", "99763_62164_3159.jpg", "7.jpg", "20160408110556_11.jpg", "201606100719471127_1.jpg", "article_20150904-1.jpg", "img_20150502111148_a5d91d53.jpg", "R1280x0.jpg"]
    
    var contents: [SampleContent] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Overridden: IrregularCollectionViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "IrregularCollectionViewController"
        edgesForExtendedLayout = .top
        collectionViewLayout.columnSpacing = 1
        collectionViewLayout.numberOfColumns = 3
        collectionViewLayout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1)
        collectionView.register(SampleViewCell.self, forCellWithReuseIdentifier: "SampleViewCell")
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
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "SampleViewCell", for: indexPath)
    }
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? SampleViewCell)?.content = contents[indexPath.item]
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, originalItemSizeAt indexPath: IndexPath) -> CGSize {
        let content = contents[indexPath.item]
        return CGSize(width: CGFloat(content.width), height: CGFloat(content.height))
    }
    
    // MARK: - Private methods
    
    private func createRandomSizeItems(_ count: Int) -> [SampleContent] {
        var source: Array<SampleContent> = []
        for i in 0..<count {
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

class SampleViewCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var content: SampleContent? {
        didSet {
            if let url = content?.url {
                imageView.image = UIImage(named: url)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
