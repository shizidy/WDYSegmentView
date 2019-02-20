//
//  HomeViewController.m
//  CustomSegmentView
//
//  Created by Macmini on 2019/2/18.
//  Copyright © 2019 Macmini. All rights reserved.
//

#import "HomeViewController.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"
#import "FourViewController.h"
#import "FiveViewController.h"
#import "SixViewController.h"
#import "HeaderView.h"
#import "ContentView.h"
#import "HomeViewModel.h"
#define kscreenWidth [UIScreen mainScreen].bounds.size.width
#define kscreenHeight [UIScreen mainScreen].bounds.size.height
#define kStatusBarHeight        [[UIApplication sharedApplication] statusBarFrame].size.height
#define kTopBarHeight           (44.f)

@interface HomeViewController () <HeaderViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) HeaderView *headerView;
@property (nonatomic, strong) ContentView *contentView;
@property (nonatomic, strong) HomeViewModel *homeViewModel;
@property (nonatomic, assign) CGPoint tempPoint;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark ========== HeaderViewDelegate ==========
- (void)collectionView:(UICollectionView *)collectionView selectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.contentView.scrollView setContentOffset:CGPointMake(indexPath.item * kscreenWidth, 0) animated:NO];
}

#pragma mark ========== UIScrollViewDelegate ==========
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.tempPoint = scrollView.contentOffset;
    self.headerView.startOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    self.headerView.slideView.frame = CGRectMake(offsetX/5, CGRectGetMinY(self.headerView.slideView.frame), CGRectGetWidth(self.headerView.slideView.frame), CGRectGetHeight(self.headerView.slideView.frame));
    self.headerView.offsetX = offsetX;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    self.headerView.slideView.frame = CGRectMake(offsetX/kscreenWidth * (kscreenWidth/5), CGRectGetMinY(self.headerView.slideView.frame), CGRectGetWidth(self.headerView.slideView.frame), CGRectGetHeight(self.headerView.slideView.frame));
    self.headerView.offsetX = offsetX;
}

- (void)setUI {

    OneViewController *oneVC = [[OneViewController alloc] init];
    TwoViewController *twoVC = [[TwoViewController alloc] init];
    ThreeViewController *threeVC = [[ThreeViewController alloc] init];
    FourViewController *fourVC = [[FourViewController alloc] init];
    FiveViewController *fiveVC = [[FiveViewController alloc] init];
    SixViewController *sixVC = [[SixViewController alloc] init];
    [self addChildViewController:oneVC];
    [self addChildViewController:twoVC];
    [self addChildViewController:threeVC];
    [self addChildViewController:fourVC];
    [self addChildViewController:fiveVC];
    [self addChildViewController:sixVC];
    
    [self.view addSubview:self.headerView];
    self.headerView.homeViewModel = self.homeViewModel;
    [self.view addSubview:self.contentView];
    
}


- (HeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kscreenWidth, 50) menuArray:self.homeViewModel.menuArray];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (ContentView *)contentView {
    if (!_contentView) {
        _contentView = [[ContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kscreenWidth, kscreenHeight - CGRectGetMaxY(self.headerView.frame)) homeViewController:self homeViewModel:self.homeViewModel];
        _contentView.scrollView.delegate = self;
    }
    return _contentView;
}

- (HomeViewModel *)homeViewModel {
    if (!_homeViewModel) {
        _homeViewModel = [[HomeViewModel alloc] init];
    }
    return _homeViewModel;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
