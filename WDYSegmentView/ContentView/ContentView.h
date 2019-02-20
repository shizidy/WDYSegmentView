//
//  ContentView.h
//  CustomSegmentView
//
//  Created by Macmini on 2019/2/18.
//  Copyright © 2019 Macmini. All rights reserved.
//

#import "BaseView.h"
#import "HomeViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ContentViewDelegate <NSObject>
@optional
- (void)collectionView;

@end

@interface ContentView : BaseView
@property (nonatomic, weak) id <ContentViewDelegate> delegate;
@property (nonatomic, strong) UIScrollView *scrollView;
- (instancetype)initWithFrame:(CGRect)frame homeViewController:(UIViewController *)homeVC homeViewModel:(HomeViewModel *)homeViewModel;
@end

NS_ASSUME_NONNULL_END
