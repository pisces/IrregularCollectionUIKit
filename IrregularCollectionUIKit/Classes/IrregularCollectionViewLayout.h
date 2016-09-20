//
//  IrregularCollectionViewLayout.h
//  Pods
//
//  Created by pisces on 9/18/16.
//
//

#import <UIKit/UIKit.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class IrregularLayoutAttributesManager;
@protocol IrregularCollectionViewLayoutDelegate;

@interface IrregularCollectionViewLayout : UICollectionViewLayout
@property (nullable, nonatomic, weak) id<IrregularCollectionViewLayoutDelegate> delegate;
@property (nonatomic) NSInteger numberOfColumns;
@property (nonatomic) CGFloat columnSpacing;
@property (nonatomic) CGFloat headerHeight;
@property (nonatomic) CGFloat footerHeight;
@property (nonatomic) UIEdgeInsets interItemSpacing;
@property (nonatomic) UIEdgeInsets sectionInset;
@property (nonnull, readonly) IrregularLayoutAttributesManager *attributesManager;
- (instancetype _Nonnull)initWithDelegate:(id<IrregularCollectionViewLayoutDelegate> _Nonnull)delegate;
- (CGFloat)columnWidthForSection:(NSUInteger)section;
- (CGSize)headerSizeForSection:(NSInteger)section;
- (CGSize)footerSizeForSection:(NSInteger)section;
@end

@protocol IrregularCollectionViewLayoutDelegate <ASCollectionViewDelegate>
- (CGSize)collectionView:(UICollectionView * _Nonnull)collectionView layout:(UICollectionViewLayout * _Nonnull)collectionViewLayout originalItemSizeAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
@end

@interface IrregularCollectionViewLayoutInspector : NSObject <ASCollectionViewLayoutInspecting>
- (void)preapareLayoutWithCollectionView:(ASCollectionView * _Nonnull)colllectionView;
@end

@protocol IrregularSizeObject <NSObject>
@property (nonatomic) NSInteger height;
@property (nonatomic) NSInteger width;
@end