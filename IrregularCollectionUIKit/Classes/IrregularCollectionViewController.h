//
//  IrregularCollectionViewController.h
//  IrregularCollectionUIKit
//
//  Created by pisces on 9/20/16.
//
//

#import <UIKit/UIKit.h>
#import "IrregularCollectionViewLayout.h"
#import "PropertyManagedViewController.h"

@interface IrregularCollectionViewController : PropertyManagedViewController <UICollectionViewDataSource, UICollectionViewDelegate, IrregularCollectionViewLayoutDelegate>
@property (nonnull, nonatomic, readonly) IrregularCollectionViewLayout *collectionViewLayout;
@property (nonnull, nonatomic) IBOutlet UICollectionView *collectionView;
- (void)insertItemsAtIndexPaths:(NSArray<NSIndexPath *> * _Nonnull)indexPaths;
- (void)insertItemsAtIndexPaths:(NSArray<NSIndexPath *> * _Nonnull)indexPaths completion:(void (^_Nullable)(void))completion;
- (void)reloadData;
@end
