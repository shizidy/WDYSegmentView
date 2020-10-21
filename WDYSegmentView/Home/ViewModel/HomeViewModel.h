//
//  HomeViewModel.h
//  CustomSegmentView
//
//  Created by Macmini on 2019/2/18.
//  Copyright © 2019 Macmini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define kscreenWidth [UIScreen mainScreen].bounds.size.width
#define kscreenHeight [UIScreen mainScreen].bounds.size.height
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kTopBarHeight (44.f)
#define kScreenItemNum 5

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewModel : NSObject

@property (nonatomic, assign) CGFloat titleItemWidth;
@property (nonatomic, assign) CGFloat titleItemNum;
@property (nonatomic, strong) NSMutableArray *menuArray;
@end

NS_ASSUME_NONNULL_END
