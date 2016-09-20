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
    IrregularCollectionViewLayout *layout;
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
        [_allItemAttributes removeAllObjects];
        [_columnHeights removeAllObjects];
        [_headersAttributes removeAllObjects];
        [_footersAttributes removeAllObjects];
        [_sectionItemAttributes removeAllObjects];
        
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
            } map:^(NSIndexPath *indexPath, NSInteger columnIndex, CGRect frame) {
                UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                attributes.frame = frame;
                
                [itemAttributes addObject:attributes];
                [_allItemAttributes addObject:attributes];

                if (columnIndex == 0) {
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
            } map:^(NSIndexPath *indexPath, NSInteger columnIndex, CGRect frame) {
                [itemFrames addObject:[NSValue valueWithCGRect:frame]];
            }];
            
            [_sectionItemFrames addObject:itemFrames];
        }
    }
}

#pragma mark - Private methods

- (void)columnsWithSection:(NSInteger)section itemCount:(NSInteger (^)(void))itemCount map:(void (^)(NSIndexPath *, NSInteger, CGRect))map {
    BOOL wasVertical = NO;
    NSInteger count = itemCount();
    NSInteger columnIndex = 0;
    NSInteger rowIndex = 0;
    CGFloat columnWidth = [layout columnWidthForSection:section];
    CGFloat columnHeight = 0;
    CGFloat xOffset = layout.sectionInset.left;
    CGFloat yOffset = _columnHeights.lastObject.floatValue;
    
    for (NSInteger i=0; i<count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        CGSize itemSize = [layout.delegate collectionView:layout.collectionView layout:layout originalItemSizeAtIndexPath:indexPath];
        CGFloat multiply = 0;
        CGRect frame;
        
        if (columnIndex == 0) {
            if (itemSize.width > itemSize.height) {
                CGFloat rate = itemSize.width / itemSize.height;
                multiply = rate > 1.34 ? 2 : 1;
            } else {
                CGFloat rate = itemSize.height / itemSize.width;
                if (rate > 1.5) {
                    multiply = 1;
                    wasVertical = YES;
                } else {
                    multiply = rate < 1.34 ? 2 : 1;
                }
            }
            
            CGFloat columnSpacing = ((multiply-1) * layout.columnSpacing);
            CGFloat measuredWidth = (columnWidth * multiply) + columnSpacing;
            CGFloat measuredHeight = wasVertical || multiply == 2 ? (columnWidth * multiply) * itemSize.height / itemSize.width : columnWidth;
            
            if (measuredHeight > columnWidth) {
                columnHeight = wasVertical || multiply == 2 ? measuredWidth * itemSize.height / itemSize.width : columnWidth;
            } else {
                columnHeight = columnWidth;
            }
            
            frame = CGRectMake(xOffset, yOffset, measuredWidth, columnHeight);
            
            map(indexPath, columnIndex, frame);
        } else if (columnIndex < layout.numberOfColumns - 1) {
            multiply = wasVertical ? 2 : 1;
            CGFloat columnSpacing = ((multiply-1) * layout.columnSpacing);
            frame = CGRectMake(xOffset, yOffset, (columnWidth * multiply) + columnSpacing, columnHeight);
            
            map(indexPath, columnIndex, frame);
            
            if (wasVertical) {
                wasVertical = NO;
            }
        } else {
            if (columnHeight > columnWidth && indexPath.row + 1 < count) {
                CGFloat measuredHeight = MIN(columnHeight, (itemSize.height * columnWidth) / itemSize.width);
                NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:section];
                CGSize nextItemSize = [layout.delegate collectionView:layout.collectionView layout:layout originalItemSizeAtIndexPath:nextIndexPath];
                
                frame = CGRectMake(xOffset, yOffset, columnWidth, measuredHeight);
                
                map(indexPath, columnIndex, frame);
                
                CGFloat nextItemHeight = columnHeight - measuredHeight - layout.columnSpacing;
                
                if (nextItemHeight > 0) {
                    map(nextIndexPath, columnIndex, CGRectMake(xOffset, CGRectGetMaxY(frame) + layout.columnSpacing, columnWidth, nextItemHeight));
                    i++;
                }
            } else {
                frame = CGRectMake(xOffset, yOffset, columnWidth, columnHeight);
                map(indexPath, columnIndex, frame);
            }
            
            multiply = 1;
        }
        
        columnIndex = columnIndex + multiply > layout.numberOfColumns - 1 ? 0 : columnIndex + multiply;
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
