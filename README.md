# IrregularCollectionUIKit

![Swift](https://img.shields.io/badge/Swift-3-orange.svg)
![Objective-C](https://img.shields.io/badge/Objective-C-orange.svg)
[![CI Status](http://img.shields.io/travis/pisces/IrregularCollectionUIKit.svg?style=flat)](https://travis-ci.org/pisces/IrregularCollectionUIKit)
[![Version](https://img.shields.io/cocoapods/v/IrregularCollectionUIKit.svg?style=flat)](http://cocoapods.org/pods/IrregularCollectionUIKit)
[![License](https://img.shields.io/cocoapods/l/IrregularCollectionUIKit.svg?style=flat)](http://cocoapods.org/pods/IrregularCollectionUIKit)
[![Platform](https://img.shields.io/cocoapods/p/IrregularCollectionUIKit.svg?style=flat)](http://cocoapods.org/pods/IrregularCollectionUIKit)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## You can implement layout of collection view like this screenshot :)
<p valign="top">
<img src="screenshots/sh_002.png" width="320"/>
<img src="screenshots/sh_003.png" width="320"/>
</p>

### Implementation for collection view with the class IrregularCollectionViewController using UIKit
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
### Implementation for collection view with IrregularCollectionViewLayout
```Swift
let layout = IrregularCollectionViewLayout()
layout.delegate = self
layout.columnSpacing = 1
layout.numberOfColumns = 3
layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1)
        
let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
```

## Requirements

iOS Deployment Target 7.0 higher

## Installation

IrregularCollectionUIKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "IrregularCollectionUIKit"
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Alamofire into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "pisces/IrregularCollectionUIKit" ~> 2.0.1
```

Run `carthage update` to build the framework and drag the built `IrregularCollectionUIKit.framework` into your Xcode project.

## Author

Steve Kim, hh963103@gmail.com

## License

IrregularCollectionUIKit is available under the MIT license. See the LICENSE file for more info.
