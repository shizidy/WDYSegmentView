//
//  HeaderView.m
//  CustomSegmentView
//
//  Created by Macmini on 2019/2/18.
//  Copyright © 2019 Macmini. All rights reserved.
//

#import "HeaderView.h"

@interface HeaderView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) HomeViewModel *homeViewModel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *fontArray;
@end

@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate viewModel:(nonnull HomeViewModel *)viewModel {
    if (self = [super initWithFrame:frame]) {
        self.homeViewModel = viewModel;
        self.delegate = delegate;
    }
    return self;
}

- (void)setSubViews {
    [self addSubview:self.collectionView];
    [self.collectionView addSubview:self.slideView];
}

- (void)setSubViewsConstraints {
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.homeViewModel.menuArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    //
    UILabel *menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cell.contentView.frame), CGRectGetHeight(cell.frame))];
    [cell.contentView addSubview:menuLabel];
    menuLabel.text = self.homeViewModel.menuArray[indexPath.item];
    menuLabel.textColor = [UIColor whiteColor];
    menuLabel.textAlignment = NSTextAlignmentCenter;
    menuLabel.font = [UIFont systemFontOfSize:16];
    CGFloat scale = [self.fontArray[indexPath.item] floatValue];
    menuLabel.transform = CGAffineTransformMakeScale(scale, scale);
    //
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(cell.contentView.frame) - 1, 0, 1, CGRectGetHeight(cell.frame))];
    [cell.contentView addSubview:view];
    view.backgroundColor = [UIColor greenColor];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.homeViewModel.titleItemWidth, 50);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:startSelectItemIndexPath:)]) {
        [self.delegate collectionView:collectionView startSelectItemIndexPath:indexPath];
    }
    if (CGRectGetMinX(self.slideView.frame) != indexPath.item * self.homeViewModel.titleItemWidth) {
        [UIView animateWithDuration:0.2 animations:^{
            self.slideView.frame = CGRectMake(indexPath.item * self.homeViewModel.titleItemWidth, CGRectGetMinY(self.slideView.frame), CGRectGetWidth(self.slideView.frame), CGRectGetHeight(self.slideView.frame));
        } completion:^(BOOL finished) {
            
        }];
        //字体大小
        for (int i = 0; i < self.homeViewModel.menuArray.count; i++) {
            if (i == indexPath.item) {
                [self.fontArray replaceObjectAtIndex:i withObject:@(0.25 + 1)];
            } else {
                [self.fontArray replaceObjectAtIndex:i withObject:@(1)];
            }
        }
        [self.collectionView reloadData];
        
        [self setCollectionView:self.collectionView index:indexPath.item];
        
        if ([self.delegate respondsToSelector:@selector(collectionView:selectItemAtIndexPath:)]) {
            [self.delegate collectionView:collectionView selectItemAtIndexPath:indexPath];
        }
    }
    if ([self.delegate respondsToSelector:@selector(collectionView:endSelectItemIndexPath:)]) {
        [self.delegate collectionView:collectionView endSelectItemIndexPath:indexPath];
    }
}

#pragma mark - setHomeViewModel
- (void)setHomeViewModel:(HomeViewModel *)homeViewModel {
    _homeViewModel = homeViewModel;
    for (int i = 0; i < homeViewModel.menuArray.count; i++) {
        if (i == 0) {
            [self.fontArray addObject:@(0.25 + 1)];
        } else {
            [self.fontArray addObject:@(1)];
        }
    }
    [self.collectionView reloadData];
}

#pragma mark - setOffsetX
- (void)setOffsetX:(CGFloat)offsetX {
    _offsetX = offsetX;
    NSInteger index = (int)(offsetX / kscreenWidth);
    CGFloat rate = ((offsetX - index * kscreenWidth) / kscreenWidth) / 4;
    if (self.startOffsetX < offsetX) {// 手指左划
        if (index == self.homeViewModel.menuArray.count - 1) {
            [self.fontArray replaceObjectAtIndex:index withObject:@(0.25 + 1 - rate)];
        } else {
            [self.fontArray replaceObjectAtIndex:index + 1 withObject:@(rate + 1)];
            [self.fontArray replaceObjectAtIndex:index withObject:@(0.25 + 1 - rate)];
        }
    }
    if (self.startOffsetX > offsetX) {// 手指右划
        if (offsetX / kscreenWidth < 0) {
            [self.fontArray replaceObjectAtIndex:index withObject:@(0.25 + 1 + rate)];
        } else {
            [self.fontArray replaceObjectAtIndex:index + 1 withObject:@(rate + 1)];
            [self.fontArray replaceObjectAtIndex:index withObject:@(0.25 + 1 - rate)];
        }
    }
    [self.collectionView reloadData];
    
    [self setCollectionView:self.collectionView index:index];
}

- (void)setCollectionView:(UICollectionView *)collectionView index:(NSInteger)index {
    if (index <= (int)(self.homeViewModel.titleItemNum / 2)) {
        [collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    if (index > (int)(self.homeViewModel.titleItemNum / 2) && index < self.homeViewModel.menuArray.count - (int)(self.homeViewModel.titleItemNum / 2)) {
        [collectionView setContentOffset:CGPointMake((index - (int)(self.homeViewModel.titleItemNum / 2)) * (kscreenWidth / self.homeViewModel.titleItemNum), 0) animated:YES];
    }
    
    if (index >= self.homeViewModel.menuArray.count - (int)(self.homeViewModel.titleItemNum / 2)) {
        [collectionView setContentOffset:CGPointMake(collectionView.contentSize.width - kscreenWidth, 0) animated:YES];
    }
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    }
    return _collectionView;
}

- (UIView *)slideView {
    if (!_slideView) {
        _slideView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 4, CGRectGetWidth(self.frame)/5, 4)];
        _slideView.backgroundColor = [UIColor whiteColor];
    }
    return _slideView;
}

- (NSMutableArray *)fontArray {
    if (!_fontArray) {
        _fontArray = [NSMutableArray array];
    }
    return _fontArray;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
