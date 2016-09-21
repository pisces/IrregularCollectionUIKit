//
//  PropertyManagedViewController.h
//  IrregularCollectionUIKit
//
//  Created by pisces on 9/20/16.
//
//

#import <UIKit/UIKit.h>

@interface PropertyManagedViewController : UIViewController
@property (nonatomic, readonly) BOOL isFirstViewAppearence;
@property (nonatomic, readonly) BOOL isViewAppeared;
- (void)commitProperties;
- (void)initProperties;
- (void)invalidateProperties;
@end
