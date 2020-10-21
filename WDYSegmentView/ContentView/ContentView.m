//
//  ContentView.m
//  CustomSegmentView
//
//  Created by Macmini on 2019/2/18.
//  Copyright © 2019 Macmini. All rights reserved.
//

#import "ContentView.h"

@interface ContentView ()
@property (nonatomic, strong) HomeViewModel *homeViewModel;
@end

@implementation ContentView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate homeViewModel:(HomeViewModel *)homeViewModel {
    if (self = [super initWithFrame:frame]) {
        self.homeViewModel = homeViewModel;
        self.delegate = delegate;
        [self addSubview:self.scrollView];
        UIViewController *rootVC = delegate;
        for (int i = 0; i < rootVC.childViewControllers.count; i++) {
            UIViewController *vc = rootVC.childViewControllers[i];
            vc.view.frame = CGRectMake(i * frame.size.width, 0, frame.size.width, frame.size.height);
            [self.scrollView addSubview:vc.view];
        }
    }
    return self;
}

- (void)setSubViews {
    
}

- (void)setSubViewsConstraints {
    
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * self.homeViewModel.menuArray.count, 0);
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
