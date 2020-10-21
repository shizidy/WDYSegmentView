//
//  HomeViewModel.m
//  CustomSegmentView
//
//  Created by Macmini on 2019/2/18.
//  Copyright © 2019 Macmini. All rights reserved.
//

#import "HomeViewModel.h"

@implementation HomeViewModel

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (NSMutableArray *)menuArray {
    if (!_menuArray) {
        _menuArray = [NSMutableArray array];
    }
    return _menuArray;
}
@end
