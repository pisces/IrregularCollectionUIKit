# IrregularCollectionUIKit

[![CI Status](http://img.shields.io/travis/pisces/IrregularCollectionUIKit.svg?style=flat)](https://travis-ci.org/pisces/IrregularCollectionUIKit)
[![Version](https://img.shields.io/cocoapods/v/IrregularCollectionUIKit.svg?style=flat)](http://cocoapods.org/pods/IrregularCollectionUIKit)
[![License](https://img.shields.io/cocoapods/l/IrregularCollectionUIKit.svg?style=flat)](http://cocoapods.org/pods/IrregularCollectionUIKit)
[![Platform](https://img.shields.io/cocoapods/p/IrregularCollectionUIKit.svg?style=flat)](http://cocoapods.org/pods/IrregularCollectionUIKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## You can implement layout of collection view like this screenshot :)
<p valign="top">
<img src="screenshots/sh_002.png" width="320"/>
<img src="screenshots/sh_003.png" width="320"/>
</p>

### To implement collection view with the class IrregularCollectionViewController using UIKit
```Swift
class DemoViewController: IrregularCollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewLayout.columnSpacing = 1
        collectionViewLayout.numberOfColumns = 3
        collectionViewLayout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1)
        collectionView.register(SampleViewCell.self, forCellWithReuseIdentifier: "SampleViewCell")
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
}
```

## Requirements

## Installation

IrregularCollectionUIKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "IrregularCollectionUIKit"
```

## Author

Steve Kim, pisces@retrica.co

## License

IrregularCollectionUIKit is available under the MIT license. See the LICENSE file for more info.
