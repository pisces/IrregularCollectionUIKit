//
//  IrregularLayoutAttributesManager.h
//  IrregularCollectionUIKit
//
//  Created by pisces on 9/18/16.
//
//

#import "IrregularCollectionViewLayout.h"

@interface IrregularLayoutAttributesManager : NSObject
{
@protected
    __weak IrregularCollectionViewLayout *layout;
}
@property (nonatomic, readonly) NSInteger numberOfSections;
@property (nonatomic, readonly) NSMutableArray<NSNumber *> *columnHeights;
@property (nonatomic, readonly) NSMutableArray<UICollectionViewLayoutAttributes *> *allItemAttributes;
@property (nonatomic, readonly) NSMutableArray<UICollectionViewLayoutAttributes *> *headersAttributes;
@property (nonatomic, readonly) NSMutableArray<UICollectionViewLayoutAttributes *> *footersAttributes;
@property (nonatomic, readonly) NSMutableArray<NSArray<UICollectionViewLayoutAttributes *> *> *sectionItemAttributes;
@property (nonatomic, readonly) NSMutableArray<NSArray<NSValue *> *> *sectionItemFrames;
- (instancetype)initWithLayout:(IrregularCollectionViewLayout *)layout;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (void)prepareAttributes;
- (void)prepareFrames;
@end
