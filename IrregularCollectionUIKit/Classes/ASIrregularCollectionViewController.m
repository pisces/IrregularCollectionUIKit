//
//  ASIrregularCollectionViewController.m
//  IrregularCollectionUIKit
//
//  Created by pisces on 9/17/16.
//
//

#import "ASIrregularCollectionViewController.h"

@implementation ASIrregularCollectionViewController

#pragma mark - Overridden: PropertyManagedViewController

- (void)dealloc {
    _collectionView.asyncDataSource = nil;
    _collectionView.asyncDelegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _collectionViewLayout = [[IrregularCollectionViewLayout alloc] initWithDelegate:self];
    _layoutInspector = [[IrregularCollectionViewLayoutInspector alloc] init];
    _collectionView = [[ASCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_collectionViewLayout];
    _collectionView.asyncDelegate = self;
    _collectionView.asyncDataSource = self;
    _collectionView.layoutInspector = _layoutInspector;
    self.view = _collectionView;
    
    [_collectionView tuningParametersForRangeMode:ASLayoutRangeModeVisibleOnly rangeType:ASLayoutRangeTypeFetchData];
    [_collectionView registerSupplementaryNodeOfKind:UICollectionElementKindSectionHeader];
    [_collectionView registerSupplementaryNodeOfKind:UICollectionElementKindSectionFooter];
}

#pragma mark - ASCollection data source

- (ASCellNode *)collectionView:(ASCollectionView *)collectionView nodeForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return [ASCellNode new];
}

#pragma mark - Public methods

- (void)performBatchUpdates:(void (^)())updates completion:(void (^)(BOOL))completion {
    [_layoutInspector preapareLayoutWithCollectionView:_collectionView];
    [_collectionView performBatchUpdates:updates completion:completion];
}

- (void)prepareLayout {
    [_layoutInspector preapareLayoutWithCollectionView:_collectionView];
}

- (void)reloadData {
    [_layoutInspector preapareLayoutWithCollectionView:_collectionView];
    [_collectionView reloadDataImmediately];
}

- (void)reloadDataWithCompletion:(void (^)())completion {
    [_layoutInspector preapareLayoutWithCollectionView:_collectionView];
    [_collectionView reloadDataWithCompletion:completion];
}

@end
