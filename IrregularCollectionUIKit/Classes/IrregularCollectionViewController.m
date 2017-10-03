//
//  IrregularCollectionViewController.m
//  IrregularCollectionUIKit
//
//  Created by pisces on 9/20/16.
//
//

#import "IrregularCollectionViewController.h"

@implementation IrregularCollectionViewController

#pragma mark - Overridden: PropertyManagedViewController

- (void)dealloc {
    _collectionView.dataSource = nil;
    _collectionView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    IrregularCollectionViewLayout *layout = [IrregularCollectionViewLayout new];
    layout.delegate = self;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    self.view = _collectionView;
}

#pragma mark - UICollectionView data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - IrregularCollectionViewLayout delegate

- (CGSize)collectionView:(UICollectionView * _Nonnull)collectionView layout:(UICollectionViewLayout * _Nonnull)collectionViewLayout originalItemSizeAtIndexPath:(NSIndexPath * _Nonnull)indexPath {
    return CGSizeZero;
}

@end
