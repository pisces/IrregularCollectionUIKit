//
//  IrregularLayoutAttributesManager.h
//  Pods
//
//  Created by pisces on 9/18/16.
//
//

#import "IrregularCollectionViewLayout.h"

@interface IrregularLayoutAttributesManager : NSObject
@property (nonatomic, readonly) NSMutableArray<NSNumber *> *columnHeights;
@property (nonatomic, readonly) NSMutableArray<UICollectionViewLayoutAttributes *> *allItemAttributes;
@property (nonatomic, readonly) NSMutableArray<UICollectionViewLayoutAttributes *> *headersAttributes;
@property (nonatomic, readonly) NSMutableArray<UICollectionViewLayoutAttributes *> *footersAttributes;
@property (nonatomic, readonly) NSMutableArray<NSArray<UICollectionViewLayoutAttributes *> *> *sectionItemAttributes;
@property (nonatomic, readonly) NSMutableArray<NSArray<NSValue *> *> *sectionItemFrames;
- (instancetype)initWithLayout:(IrregularCollectionViewLayout *)layout;
- (void)prepareAttributes;
- (void)prepareFrames;
@end
