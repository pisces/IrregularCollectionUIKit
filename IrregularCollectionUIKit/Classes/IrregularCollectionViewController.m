//
//  IrregularCollectionViewController.m
//  IrregularCollectionUIKit
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
    
    IrregularCollectionViewLayout *layout = [IrregularCollectionViewLayout new];
    layout.delegate = self;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    self.view = _collectionView;
}

@end
