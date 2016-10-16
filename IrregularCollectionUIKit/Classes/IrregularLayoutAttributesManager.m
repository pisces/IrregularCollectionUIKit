//
//  IrregularLayoutAttributesManager.m
//  Pods
//
//  Created by pisces on 9/18/16.
//
//

#import "IrregularLayoutAttributesManager.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface IrregularLayoutAttributesManager ()
@property (nullable, nonatomic, readonly) ASCollectionView *asCollectionView;
@property (nonatomic, readonly) NSInteger numberOfSections;
@end

@implementation IrregularLayoutAttributesManager
{
    __weak IrregularCollectionViewLayout *layout;
}

#pragma mark - Properties

- (ASCollectionView *)asCollectionView {
    return (ASCollectionView *) layout.collectionView;
}

- (NSInteger)numberOfSections {
    if ([layout.collectionView isKindOfClass:[ASCollectionView class]]) {
        return [self.asCollectionView.asyncDataSource numberOfSectionsInCollectionView:self.asCollectionView];
    }
    return [layout.collectionView.dataSource numberOfSectionsInCollectionView:layout.collectionView];
}

#pragma mark - Constructor

- (instancetype)initWithLayout:(IrregularCollectionViewLayout *)_layout {
    self = [super init];
    
    if (self) {
        layout = _layout;
        _allItemAttributes = [NSMutableArray array];
        _columnHeights = [NSMutableArray array];
        _headersAttributes = [NSMutableArray array];
        _footersAttributes = [NSMutableArray array];
        _sectionItemAttributes = [NSMutableArray array];
        _sectionItemFrames = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - Public methods

- (void)prepareAttributes {
    NSInteger numberOfSections = layout.collectionView.numberOfSections;
    
    if (numberOfSections > 0) {
        [self clear];
        
        for (NSInteger section=0; section<numberOfSections; section++) {
            // header
            if (layout.headerHeight > 0) {
                CGFloat yOffset = _columnHeights.lastObject.floatValue;
                CGSize headerSize = [layout headerSizeForSection:section];
                UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes
                                                                layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
                attributes.frame = CGRectMake(layout.sectionInset.left, yOffset, headerSize.width, headerSize.height);
                [_headersAttributes addObject:attributes];
                [_allItemAttributes addObject:attributes];
                [_columnHeights addObject:@(CGRectGetMaxY(attributes.frame))];
            }
            
            // items
            NSMutableArray<UICollectionViewLayoutAttributes *> *itemAttributes = [NSMutableArray array];
            
            [self columnsWithSection:section itemCount:^NSInteger{
                return [layout.collectionView numberOfItemsInSection:section];
            } map:^(NSIndexPath *indexPath, BOOL heightChanged, CGRect frame) {
                UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                attributes.frame = frame;
                
                [itemAttributes addObject:attributes];
                [_allItemAttributes addObject:attributes];

                if (heightChanged) {
                    [_columnHeights addObject:@(CGRectGetMaxY(frame))];
                }
            }];
            
            [_sectionItemAttributes addObject:itemAttributes];
            
            // footer
            if (layout.footerHeight > 0) {
                CGFloat yOffset = _columnHeights.lastObject.floatValue;
                CGSize footerSize = [layout footerSizeForSection:section];
                UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes
                                                                layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
                attributes.frame = CGRectMake(layout.sectionInset.left, yOffset, footerSize.width, footerSize.height);
                [_footersAttributes addObject:attributes];
                [_allItemAttributes addObject:attributes];
                [_columnHeights addObject:@(CGRectGetMaxY(attributes.frame))];
            }
        }
    }
}

- (void)prepareFrames {
    NSInteger numberOfSections = self.numberOfSections;
    
    if (numberOfSections > 0) {
        [_sectionItemFrames removeAllObjects];
        
        for (NSInteger section=0; section<numberOfSections; section++) {
            NSMutableArray<NSValue *> *itemFrames = [NSMutableArray array];
            
            [self columnsWithSection:section itemCount:^NSInteger{
                return [self numberOfItemsInSection:section];
            } map:^(NSIndexPath *indexPath, BOOL heightChanged, CGRect frame) {
                [itemFrames addObject:[NSValue valueWithCGRect:frame]];
            }];
            
            [_sectionItemFrames addObject:itemFrames];
        }
    }
}

#pragma mark - Private methods

- (void)clear {
    [_allItemAttributes removeAllObjects];
    [_columnHeights removeAllObjects];
    [_headersAttributes removeAllObjects];
    [_footersAttributes removeAllObjects];
    [_sectionItemAttributes removeAllObjects];
}

- (void)columnsWithSection:(NSInteger)section itemCount:(NSInteger (^)(void))itemCount map:(void (^)(NSIndexPath *, BOOL, CGRect))map {
    BOOL wasFullWidth = NO;
    NSInteger numberOfItems = itemCount();
    CGFloat itemWidthSum = 0;
    NSInteger columnIndex = 0;
    CGFloat columnHeight = 0;
    CGFloat viewWidth = [layout widthForSection:section];
    CGFloat xOffset = layout.sectionInset.left;
    CGFloat yOffset = _columnHeights.lastObject.floatValue;
    CGRect frame;
    
    for (NSInteger i=0; i<numberOfItems; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        CGSize itemSize = [layout.delegate collectionView:layout.collectionView layout:layout originalItemSizeAtIndexPath:indexPath];
        
        if (columnIndex == 0) {
            CGFloat rate = itemSize.width / itemSize.height;
            
            if (!wasFullWidth && rate >= 1.3) {
                columnHeight = ceilf(viewWidth * itemSize.height / itemSize.width);
                frame = CGRectMake(xOffset, yOffset, viewWidth, columnHeight);
                map(indexPath, YES, frame);
                columnIndex += layout.numberOfColumns;
                wasFullWidth = YES;
            } else {
                itemWidthSum = itemSize.width;
                
                for (NSInteger j=1; j<layout.numberOfColumns; j++) {
                    if (i+j < numberOfItems) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i+j inSection:section];
                        CGSize itemSize = [layout.delegate collectionView:layout.collectionView layout:layout originalItemSizeAtIndexPath:indexPath];
                        itemWidthSum += itemSize.width;
                    }
                }
                
                CGFloat itemWidth = ceilf(viewWidth * (itemSize.width / itemWidthSum));
                columnHeight = ceilf((itemWidth * itemSize.height) / itemSize.width);
                
                for (NSInteger j=1; j<layout.numberOfColumns; j++) {
                    if (i+j < numberOfItems) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i+j inSection:section];
                        CGSize itemSize = [layout.delegate collectionView:layout.collectionView layout:layout originalItemSizeAtIndexPath:indexPath];
                        CGFloat itemWidth = ceilf(viewWidth * (itemSize.width / itemWidthSum));
                        columnHeight = MIN(columnHeight, ceilf((itemWidth * itemSize.height) / itemSize.width));
                    }
                }
                
                frame = CGRectMake(xOffset, yOffset, itemWidth, columnHeight);
                map(indexPath, YES, frame);
                columnIndex++;
                wasFullWidth = NO;
            }
        } else {
            CGFloat itemWidth = ceilf(viewWidth * (itemSize.width / itemWidthSum));
            frame = CGRectMake(xOffset, yOffset, itemWidth, columnHeight);
            map(indexPath, NO, frame);
            columnIndex++;
        }
        
        columnIndex = columnIndex > layout.numberOfColumns - 1 ? 0 : columnIndex;
        xOffset = columnIndex == 0 ? layout.sectionInset.left : CGRectGetMaxX(frame) + layout.columnSpacing;
        
        if (columnIndex == 0) {
            yOffset += columnHeight + layout.columnSpacing;
        }
    }
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    if ([layout.collectionView isKindOfClass:[ASCollectionView class]]) {
        return [self.asCollectionView.asyncDataSource collectionView:self.asCollectionView numberOfItemsInSection:section];
    }
    return [layout.collectionView.dataSource collectionView:layout.collectionView numberOfItemsInSection:section];
}

@end
