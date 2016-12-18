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
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_collectionViewLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [self.view addSubview:_collectionView];
    
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    [self.view addConstraints:@[leading, top, trailing, bottom]];
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
