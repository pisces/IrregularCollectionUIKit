//
//  IrregularCollectionViewController.m
//  Pods
//
//  Created by pisces on 9/20/16.
//
//

#import "IrregularCollectionViewController.h"

@implementation IrregularCollectionViewController

#pragma mark - Overridden: UIViewController

- (void)dealloc {
    _collectionView.asyncDataSource = nil;
    _collectionView.asyncDelegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _collectionViewLayout = [[IrregularCollectionViewLayout alloc] initWithDelegate:self];
    _layoutInspector = [[IrregularCollectionViewLayoutInspector alloc] init];
    
    if ([self.view isKindOfClass:[UICollectionView class]]) {
        _collectionView = (UICollectionView *) self.view;
    } else {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_collectionViewLayout];
        self.view = _collectionView;
    }
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.layoutInspector = _layoutInspector;
    
    [_collectionView registerSupplementaryNodeOfKind:UICollectionElementKindSectionHeader];
    [_collectionView registerSupplementaryNodeOfKind:UICollectionElementKindSectionFooter];
}

- (void)reloadData {
    [_layoutInspector preapareLayoutWithCollectionView:_collectionView];
    [_collectionView reloadData];
}

@end
