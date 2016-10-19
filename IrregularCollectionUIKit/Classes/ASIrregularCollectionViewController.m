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

- (void)performBatchUpdates:(void (^)())updates completion:(void (^)(BOOL))completion {
    [_layoutInspector preapareLayoutWithCollectionView:_collectionView];
    [_collectionView performBatchUpdates:updates completion:completion];
}

- (void)prepareLayout {
    [_layoutInspector preapareLayoutWithCollectionView:_collectionView];
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
