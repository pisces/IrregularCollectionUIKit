//
//  IrregularCollectionViewLayout.m
//  Pods
//
//  Created by pisces on 9/18/16.
//
//

#import "IrregularCollectionViewLayout.h"
#import "IrregularLayoutAttributesManager.h"

@interface IrregularCollectionViewLayout ()
@property (nullable, nonatomic, readonly) ASCollectionView *asCollectionView;
@end

@implementation IrregularCollectionViewLayout

#pragma mark - Constructor

- (instancetype _Nonnull)init {
    self = [super init];
    
    if (self) {
        _columnSpacing = 1;
        _numberOfColumns = 3;
        _headerHeight = 50;
        _footerHeight = 50;
        _sectionInset = UIEdgeInsetsZero;
        _attributesManager = [[IrregularLayoutAttributesManager alloc] initWithLayout:self];
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

#pragma mark - Properties

- (ASCollectionView *)asCollectionView {
    return (ASCollectionView *) self.collectionView;
}

#pragma mark - Overridden: UICollectionViewLayout

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.bounds.size.width, _attributesManager.columnHeights.lastObject.floatValue);
}

- (void)prepareLayout {
    [super prepareLayout];
    
    [_attributesManager prepareAttributes];
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

- (CGFloat)columnWidthForSection:(NSUInteger)section {
    return ([self widthForSection:section] - ((_numberOfColumns - 1) * _columnSpacing)) / _numberOfColumns;
}

- (CGSize)headerSizeForSection:(NSInteger)section {
    return CGSizeMake([self widthForSection:section], _headerHeight);
}

- (CGSize)footerSizeForSection:(NSInteger)section {
    return CGSizeMake([self widthForSection:section], _footerHeight);
}

#pragma mark - Private methods

- (CGSize)itemSizeAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= _attributesManager.sectionItemFrames.count ||
        indexPath.item >= _attributesManager.sectionItemFrames[indexPath.section].count) {
        return CGSizeZero;
    }
    return _attributesManager.sectionItemFrames[indexPath.section][indexPath.item].CGRectValue.size;
}

- (CGFloat)widthForSection:(NSUInteger)section {
    return self.collectionView.bounds.size.width - _sectionInset.left - _sectionInset.right;
}

@end

@implementation IrregularCollectionViewLayoutInspector

#pragma mark - Public methods

- (void)preapareLayoutWithCollectionView:(ASCollectionView *)collectionView {
    IrregularCollectionViewLayout *layout = (IrregularCollectionViewLayout *) collectionView.collectionViewLayout;
    
    [layout.attributesManager prepareFrames];
}

#pragma mark - ASCollectionViewLayoutInspecting protocol

- (ASSizeRange)collectionView:(ASCollectionView *)collectionView constrainedSizeForNodeAtIndexPath:(NSIndexPath *)indexPath {
    IrregularCollectionViewLayout *layout = (IrregularCollectionViewLayout *) collectionView.collectionViewLayout;
    return ASSizeRangeMake(CGSizeZero, [layout itemSizeAtIndexPath:indexPath]);
}

- (ASSizeRange)collectionView:(ASCollectionView *)collectionView constrainedSizeForSupplementaryNodeOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    IrregularCollectionViewLayout *layout = (IrregularCollectionViewLayout *) collectionView.collectionViewLayout;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return ASSizeRangeMake(CGSizeZero, [layout headerSizeForSection:indexPath.section]);
    }
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        return ASSizeRangeMake(CGSizeZero, [layout footerSizeForSection:indexPath.section]);
    }
    return ASSizeRangeMake(CGSizeZero, CGSizeZero);
}

- (NSUInteger)collectionView:(ASCollectionView *)collectionView numberOfSectionsForSupplementaryNodeOfKind:(NSString *)kind {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] ||
        [kind isEqualToString:UICollectionElementKindSectionFooter]) {
        return [collectionView.asyncDataSource numberOfSectionsInCollectionView:collectionView];
    } else {
        return 0;
    }
}

- (NSUInteger)collectionView:(ASCollectionView *)collectionView supplementaryNodesOfKind:(NSString *)kind inSection:(NSUInteger)section {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] ||
        [kind isEqualToString:UICollectionElementKindSectionFooter]) {
        return 1;
    } else {
        return 0;
    }
}

@end