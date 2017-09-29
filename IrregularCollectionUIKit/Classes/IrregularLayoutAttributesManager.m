//
//  IrregularLayoutAttributesManager.m
//  IrregularCollectionUIKit
//
//  Created by pisces on 9/18/16.
//
//

#import "IrregularLayoutAttributesManager.h"

@implementation IrregularLayoutAttributesManager

#pragma mark - Properties

- (NSInteger)numberOfSections {
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

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return [layout.collectionView.dataSource collectionView:layout.collectionView numberOfItemsInSection:section];
}

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
            NSMutableArray<NSValue *> *itemFrames = [NSMutableArray array];
            
            [self columnsWithSection:section itemCount:^NSInteger {
                return [layout.collectionView numberOfItemsInSection:section];
            } map:^(NSIndexPath *indexPath, BOOL heightChanged, CGRect frame) {
                UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                attributes.frame = frame;
                
                [itemAttributes addObject:attributes];
                [itemFrames addObject:[NSValue valueWithCGRect:frame]];
                [_allItemAttributes addObject:attributes];

                if (heightChanged) {
                    [_columnHeights addObject:@(CGRectGetMaxY(frame))];
                }
            }];
            
            [_sectionItemAttributes addObject:itemAttributes];
            [_sectionItemFrames addObject:itemFrames];
            
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
    CGFloat columnHeight = 0;
    CGFloat viewWidth = 0;
    CGFloat xOffset = layout.sectionInset.left;
    CGFloat yOffset = _columnHeights.lastObject.floatValue;
    CGFloat width = [layout widthForSection:section];
    CGSize standardItemSize;
    
    __block NSInteger columnIndex = 0;
    __block CGRect frame;
    
    void (^setFrame)(CGRect, NSIndexPath *, NSInteger, BOOL) = ^void (CGRect rect, NSIndexPath *indexPath, NSInteger columnIndexIncrease, BOOL heightChanged) {
        frame = rect;
        map(indexPath, heightChanged, rect);
        columnIndex += columnIndexIncrease;
    };
    
    CGSize (^adjustedItemSize)(CGSize) = ^CGSize (CGSize size) {
        if (size.width/size.height > 4.0/3.0) {
            return CGSizeMake(4.0 * size.height / 3.0, size.height);
        }
        return size;
    };
    
    for (NSInteger i=0; i<numberOfItems; i++) {
        NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:i inSection:section];
        CGSize currentItemSize = [layout.delegate collectionView:layout.collectionView layout:layout originalItemSizeAtIndexPath:currentIndexPath];
        
        if (columnIndex == 0) {
            CGFloat rate = currentItemSize.width / currentItemSize.height;
            
            if (!wasFullWidth && rate >= 1.2) {
                wasFullWidth = YES;
                viewWidth = width;
                columnHeight = ceilf(viewWidth * currentItemSize.height / currentItemSize.width);
                setFrame(CGRectMake(xOffset, yOffset, viewWidth, columnHeight), currentIndexPath, layout.numberOfColumns, YES);
            } else {
                wasFullWidth = NO;
                viewWidth = i >= numberOfItems - 1 ? width : width - ((layout.numberOfColumns - 1) * layout.columnSpacing);
                currentItemSize = adjustedItemSize(currentItemSize);
                standardItemSize = currentItemSize;
                itemWidthSum = currentItemSize.width;
                
                for (NSInteger j=1; j<layout.numberOfColumns; j++) {
                    if (i+j < numberOfItems) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i+j inSection:section];
                        CGSize itemSize = adjustedItemSize([layout.delegate collectionView:layout.collectionView layout:layout originalItemSizeAtIndexPath:indexPath]);
                        CGFloat heightRate = standardItemSize.height / itemSize.height;
                        itemWidthSum += (itemSize.width * heightRate);
                    }
                }
                
                CGFloat calculatedWidth = (standardItemSize.width * currentItemSize.height) / standardItemSize.height;
                CGFloat widthRate = calculatedWidth / itemWidthSum;
                CGFloat currentItemWidth = ceilf(viewWidth * widthRate);
                columnHeight = ceilf((currentItemWidth * currentItemSize.height) / currentItemSize.width);
                
                for (NSInteger j=1; j<layout.numberOfColumns; j++) {
                    if (i+j < numberOfItems) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i+j inSection:section];
                        CGSize itemSize = adjustedItemSize([layout.delegate collectionView:layout.collectionView layout:layout originalItemSizeAtIndexPath:indexPath]);
                        CGFloat heightRate = standardItemSize.height / itemSize.height;
                        CGFloat widthRate = (itemSize.width * heightRate) / itemWidthSum;
                        CGFloat itemWidth = ceilf(viewWidth * widthRate);
                        columnHeight = MIN(columnHeight, ceilf((itemWidth * itemSize.height) / itemSize.width));
                    }
                }
                
                setFrame(CGRectMake(xOffset, yOffset, currentItemWidth, columnHeight), currentIndexPath, 1, YES);
            }
        } else {
            currentItemSize = adjustedItemSize(currentItemSize);
            CGFloat heightRate = standardItemSize.height / currentItemSize.height;
            CGFloat widthRate = (currentItemSize.width * heightRate) / itemWidthSum;
            CGFloat currentItemWidth = ceilf(viewWidth * widthRate);
            setFrame(CGRectMake(xOffset, yOffset, currentItemWidth, columnHeight), currentIndexPath, 1, NO);
        }
        
        columnIndex = columnIndex > layout.numberOfColumns - 1 ? 0 : columnIndex;
        xOffset = columnIndex == 0 ? layout.sectionInset.left : CGRectGetMaxX(frame) + layout.columnSpacing;
        
        if (columnIndex == 0) {
            yOffset += columnHeight + layout.columnSpacing;
        }
    }
}

@end
