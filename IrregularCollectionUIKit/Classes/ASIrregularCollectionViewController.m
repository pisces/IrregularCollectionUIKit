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
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_collectionView registerSupplementaryNodeOfKind:UICollectionElementKindSectionHeader];
    [_collectionView registerSupplementaryNodeOfKind:UICollectionElementKindSectionFooter];
    [self.view addSubview:_collectionView];
    
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    [self.view addConstraints:@[leading, top, trailing, bottom]];
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
