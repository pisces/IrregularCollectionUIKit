//
//  ASIrregularCollectionViewController.m
//  IrregularCollectionUIKit
//
//  Created by pisces on 9/17/16.
//
//

#import "ASIrregularCollectionViewController.h"

@implementation ASIrregularCollectionViewController

#pragma mark - Overridden: UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _collectionViewLayout = [[IrregularCollectionViewLayout alloc] initWithDelegate:self];
    _layoutInspector = [[IrregularCollectionViewLayoutInspector alloc] init];
    
    if ([self.view isKindOfClass:[ASCollectionView class]]) {
        _collectionView = (ASCollectionView *) self.view;
    } else {
        _collectionView = [[ASCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_collectionViewLayout];
        self.view = _collectionView;
    }
    
    _collectionView.asyncDelegate = self;
    _collectionView.asyncDataSource = self;
    _collectionView.layoutInspector = _layoutInspector;
    
    [_collectionView registerSupplementaryNodeOfKind:UICollectionElementKindSectionHeader];
    [_collectionView registerSupplementaryNodeOfKind:UICollectionElementKindSectionFooter];
}

- (void)insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self insertItemsAtIndexPaths:indexPaths completion:nil];
}

- (void)insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths completion:(void (^)(void))completion {
    [_collectionView performBatchUpdates:^{
        [_layoutInspector preapareLayoutWithCollectionView:_collectionView];
        [_collectionView insertItemsAtIndexPaths:indexPaths];
        
        NSInteger previousRow = indexPaths.firstObject.row - 1;
        if (previousRow > -1) {
            NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:previousRow inSection:indexPaths.firstObject.section];
            [_collectionView reloadItemsAtIndexPaths:@[previousIndexPath]];
        }
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)reloadData {
    [_layoutInspector preapareLayoutWithCollectionView:_collectionView];
    [_collectionView reloadData];
}

- (void)reloadDataWithCompletion:(void (^)())completion {
    [_layoutInspector preapareLayoutWithCollectionView:_collectionView];
    [_collectionView reloadDataWithCompletion:completion];
}

@end
