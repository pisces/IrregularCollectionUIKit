//
//  IrregularCollectionViewLayout.m
//  IrregularCollectionUIKit
//
//  Created by pisces on 9/18/16.
//
//

#import "IrregularCollectionViewLayout.h"
#import "IrregularLayoutAttributesManager.h"

@implementation IrregularCollectionViewLayout

#pragma mark - Constructor

- (instancetype _Nonnull)init {
    self = [super init];
    if (self) {
        _columnSpacing = 1;
        _numberOfColumns = 3;
        _headerHeight = 0;
        _footerHeight = 0;
        _sectionInset = UIEdgeInsetsZero;
        _attributesManager = [self createAttributesManager];
    }
    return self;
}

- (instancetype _Nonnull)initWithDelegate:(id<IrregularCollectionViewLayoutDelegate>)delegate {
    self = [self init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

#pragma mark - Overridden: UICollectionViewLayout

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.bounds.size.width, _attributesManager.columnHeights.lastObject.floatValue);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *includedAttributes = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attributes in _attributesManager.allItemAttributes) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [includedAttributes addObject:attributes];
        }
    }
    return includedAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= _attributesManager.sectionItemAttributes.count ||
        indexPath.item >= _attributesManager.sectionItemAttributes[indexPath.section].count) {
        return nil;
    }
    return _attributesManager.sectionItemAttributes[indexPath.section][indexPath.item];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader] &&
        indexPath.section < _attributesManager.headersAttributes.count) {
        return _attributesManager.headersAttributes[indexPath.section];
    }
    if ([elementKind isEqualToString:UICollectionElementKindSectionFooter] &&
        indexPath.section < _attributesManager.footersAttributes.count) {
        return _attributesManager.footersAttributes[indexPath.section];
    }
    return nil;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return !CGSizeEqualToSize(self.collectionView.bounds.size, newBounds.size);
}

#pragma mark - Public methods

- (IrregularLayoutAttributesManager *)createAttributesManager {
    return [[IrregularLayoutAttributesManager alloc] initWithLayout:self];
}

- (CGFloat)columnWidthForSection:(NSUInteger)section {
    return ([self widthForSection:section] - ((_numberOfColumns - 1) * _columnSpacing)) / _numberOfColumns;
}

- (CGSize)headerSizeForSection:(NSInteger)section {
    return CGSizeMake([self widthForSection:section], _headerHeight);
}

- (CGSize)footerSizeForSection:(NSInteger)section {
    return CGSizeMake([self widthForSection:section], _footerHeight);
}

- (CGSize)itemSizeAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= _attributesManager.sectionItemFrames.count ||
        indexPath.item >= _attributesManager.sectionItemFrames[indexPath.section].count) {
        return CGSizeZero;
    }
    return _attributesManager.sectionItemFrames[indexPath.section][indexPath.item].CGRectValue.size;
}

- (void)prepareLayout {
    [self.attributesManager prepareAttributes];
    [self.attributesManager prepareFrames];
}

- (CGFloat)widthForSection:(NSUInteger)section {
    return self.collectionView.bounds.size.width - _sectionInset.left - _sectionInset.right;
}

@end
