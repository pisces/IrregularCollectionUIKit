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
    NSMutableArray<NSIndexPath *> *reloadIndexPaths = @[[NSIndexPath indexPathForRow:indexPaths.firstObject.row - 1 inSection:indexPaths.firstObject.section],
                                                        [NSIndexPath indexPathForRow:indexPaths.lastObject.row + 1 inSection:indexPaths.lastObject.section],
                                                        [NSIndexPath indexPathForRow:indexPaths.lastObject.row + 2 inSection:indexPaths.lastObject.section]
                                                        ];
    
    [reloadIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.row < 0 || obj.row >= [_collectionView numberOfItemsInSection:indexPaths.lastObject.section]) {
            [reloadIndexPaths removeObject:obj];
        }
    }];
    
    [_collectionView performBatchUpdates:^{
        [_collectionView insertItemsAtIndexPaths:indexPaths];
        
        if (reloadIndexPaths.count > 0) {
            [_collectionView reloadItemsAtIndexPaths:reloadIndexPaths];
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
