//
//  HomeViewModel.m
//  CustomSegmentView
//
//  Created by Macmini on 2019/2/18.
//  Copyright © 2019 Macmini. All rights reserved.
//

#import "HomeViewModel.h"

@implementation HomeViewModel

- (NSMutableArray *)menuArray {
    if (!_menuArray) {
        _menuArray = [NSMutableArray arrayWithObjects:@"菜单1", @"菜单2", @"菜单3", @"菜单4", @"菜单5", @"菜单6", nil];
    }
    return _menuArray;
}
@end
