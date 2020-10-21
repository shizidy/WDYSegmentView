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
#import "SevenViewController.h"
#import "HeaderView.h"
#import "ContentView.h"
#import "HomeViewModel.h"

@interface HomeViewController () <HeaderViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) HeaderView *headerView;
@property (nonatomic, strong) ContentView *contentView;
@property (nonatomic, strong) HomeViewModel *homeViewModel;
@property (nonatomic, assign) CGFloat startX;
@property (nonatomic, assign) CGFloat endX;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - HeaderViewDelegate
- (void)collectionView:(UICollectionView *)collectionView selectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.contentView.scrollView setContentOffset:CGPointMake(indexPath.item * kscreenWidth, 0) animated:NO];
}

- (void)collectionView:(UICollectionView *)collectionView startSelectItemIndexPath:(NSIndexPath *)indexPath {
    // 点击菜单栏时，使contentView.scrollView的协议失效
    self.contentView.scrollView.delegate = nil;
}

-(void)collectionView:(UICollectionView *)collectionView endSelectItemIndexPath:(NSIndexPath *)indexPath {
    // 点击菜单栏结束后，使contentView.scrollView的协议恢复
    self.contentView.scrollView.delegate = self;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.headerView.startOffsetX = scrollView.contentOffset.x;
    self.startX = CGRectGetMinX(self.headerView.slideView.frame);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat slideViewY = CGRectGetMinY(self.headerView.slideView.frame);
    CGFloat slideViewH = CGRectGetHeight(self.headerView.slideView.frame);
    CGFloat slideViewX = offsetX / self.homeViewModel.titleItemNum;
    // slideView origin.x的前后运动距离
    CGFloat gap = slideViewX - self.startX;
    if (offsetX > self.headerView.startOffsetX) {// 手指左划
        if (gap < self.homeViewModel.titleItemWidth / 2) {
            self.headerView.slideView.frame = CGRectMake(slideViewX, slideViewY, self.homeViewModel.titleItemWidth + fabs(gap), slideViewH);
        } else {
            self.headerView.slideView.frame = CGRectMake(slideViewX, slideViewY, self.homeViewModel.titleItemWidth * 2 - fabs(gap), slideViewH);
        }
    }
    if (offsetX < self.headerView.startOffsetX) {// 手指右划
        if (fabs(gap) < self.homeViewModel.titleItemWidth / 2) {
            self.headerView.slideView.frame = CGRectMake(slideViewX - fabs(gap), slideViewY, self.homeViewModel.titleItemWidth + fabs(gap), slideViewH);
        } else {
            self.headerView.slideView.frame = CGRectMake(self.startX - self.homeViewModel.titleItemWidth, slideViewY, self.homeViewModel.titleItemWidth * 2 - fabs(gap), slideViewH);
        }
    }
    self.headerView.offsetX = offsetX;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat slideViewY = CGRectGetMinY(self.headerView.slideView.frame);
    CGFloat slideViewH = CGRectGetHeight(self.headerView.slideView.frame);
    CGFloat slideViewX = offsetX / self.homeViewModel.titleItemNum;
    self.headerView.slideView.frame = CGRectMake(slideViewX, slideViewY, self.homeViewModel.titleItemWidth, slideViewH);
    self.headerView.offsetX = offsetX;
    self.endX = CGRectGetMinX(self.headerView.slideView.frame);
}

#pragma mark - setUI
- (void)setUI {
    OneViewController *oneVC = [[OneViewController alloc] init];
    TwoViewController *twoVC = [[TwoViewController alloc] init];
    ThreeViewController *threeVC = [[ThreeViewController alloc] init];
    FourViewController *fourVC = [[FourViewController alloc] init];
    FiveViewController *fiveVC = [[FiveViewController alloc] init];
    SixViewController *sixVC = [[SixViewController alloc] init];
    SevenViewController *sevenVC = [[SevenViewController alloc] init];
    [self addChildViewController:oneVC];
    [self addChildViewController:twoVC];
    [self addChildViewController:threeVC];
    [self addChildViewController:fourVC];
    [self addChildViewController:fiveVC];
    [self addChildViewController:sixVC];
    [self addChildViewController:sevenVC];
    
    for (int i = 0; i < self.childViewControllers.count; i++) {
        NSString *title = [NSString stringWithFormat:@"菜单%d", i];
        [self.homeViewModel.menuArray addObject:title];
    }
    self.homeViewModel.titleItemNum = MIN(self.homeViewModel.menuArray.count, kScreenItemNum);
    self.homeViewModel.titleItemWidth = kscreenWidth / self.homeViewModel.titleItemNum;
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.contentView];
    
    self.startX = 0;
    self.endX = 0;
}

#pragma mark - 懒加载
- (HeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kscreenWidth, 50) delegate:self viewModel:self.homeViewModel];
    }
    return _headerView;
}

- (ContentView *)contentView {
    if (!_contentView) {
        __weak typeof(HomeViewController *)weakSelf = self;
        _contentView = [[ContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kscreenWidth, kscreenHeight - CGRectGetMaxY(self.headerView.frame)) delegate:weakSelf homeViewModel:self.homeViewModel];
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
