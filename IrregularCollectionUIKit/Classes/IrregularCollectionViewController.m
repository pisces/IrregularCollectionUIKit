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
    _collectionView.dataSource = nil;
    _collectionView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _collectionViewLayout = [[IrregularCollectionViewLayout alloc] initWithDelegate:self];
    
    if ([self.view isKindOfClass:[UICollectionView class]]) {
        _collectionView = (UICollectionView *) self.view;
    } else {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_collectionViewLayout];
        self.view = _collectionView;
    }
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
}

- (void)reloadData {
    [_collectionView reloadData];
}

@end
