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


- (void)insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self insertItemsAtIndexPaths:indexPaths completion:nil];
}

- (void)insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths completion:(void (^)(void))completion {
    [_collectionView performBatchUpdates:^{
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
    [_collectionView reloadData];
}

@end
