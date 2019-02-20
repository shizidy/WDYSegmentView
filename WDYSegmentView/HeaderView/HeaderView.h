//
//  HeaderView.h
//  CustomSegmentView
//
//  Created by Macmini on 2019/2/18.
//  Copyright © 2019 Macmini. All rights reserved.
//

#import "BaseView.h"
#import "HomeViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HeaderViewDelegate <NSObject>
@optional
- (void)collectionView:(UICollectionView *)collectionView selectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface HeaderView : BaseView
@property (nonatomic, strong) HomeViewModel *homeViewModel;
@property (nonatomic, weak) id <HeaderViewDelegate> delegate;
@property (nonatomic, strong) UIView *slideView;
@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic, assign) CGFloat startOffsetX;
- (instancetype)initWithFrame:(CGRect)frame menuArray:(NSMutableArray *)menuArr;
@end

NS_ASSUME_NONNULL_END
