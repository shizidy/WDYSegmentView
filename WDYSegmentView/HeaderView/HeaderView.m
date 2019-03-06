//
//  HeaderView.m
//  CustomSegmentView
//
//  Created by Macmini on 2019/2/18.
//  Copyright © 2019 Macmini. All rights reserved.
//

#import "HeaderView.h"
#define kscreenWidth [UIScreen mainScreen].bounds.size.width
#define kscreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenItemNum 5

@interface HeaderView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *menuArray;
@property (nonatomic, strong) NSMutableArray *fontArray;
@end

@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame menuArray:(NSMutableArray *)menuArr {
    if (self = [super initWithFrame:frame]) {
        self.menuArray = menuArr;
    }
    return self;
}

- (void)setSubViews {
    [self addSubview:self.collectionView];
    [self.collectionView addSubview:self.slideView];
}

- (void)setSubViewsConstraints {
    
}

#pragma mark ========== UICollectionViewDataSource ==========
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.menuArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    UILabel *menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cell.contentView.frame), CGRectGetHeight(cell.frame))];
    [cell.contentView addSubview:menuLabel];
    menuLabel.text = self.menuArray[indexPath.item];
    menuLabel.textColor = [UIColor orangeColor];
    menuLabel.textAlignment = NSTextAlignmentCenter;
    menuLabel.font = [UIFont systemFontOfSize:16];
    CGFloat scale = [self.fontArray[indexPath.item] floatValue];
    menuLabel.transform = CGAffineTransformMakeScale(scale, scale);
    return cell;
}

#pragma mark ========== UICollectionViewDelegate ==========
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.homeViewModel.menuArray.count > 4) {
        return CGSizeMake(kscreenWidth/kScreenItemNum, 50);
    } else {
        return CGSizeMake(kscreenWidth/self.homeViewModel.menuArray.count, 50);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = 0;
    if (self.homeViewModel.menuArray.count < kScreenItemNum) {
        itemWidth = CGRectGetWidth(self.frame)/self.homeViewModel.menuArray.count;
    } else {
        itemWidth = CGRectGetWidth(self.frame)/kScreenItemNum;
    }
    if (CGRectGetMinX(self.slideView.frame) != indexPath.item * itemWidth) {
        [UIView animateWithDuration:0.2 animations:^{
            self.slideView.frame = CGRectMake(indexPath.item * itemWidth, CGRectGetMinY(self.slideView.frame), CGRectGetWidth(self.slideView.frame), CGRectGetHeight(self.slideView.frame));
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
        
        if (indexPath.item <= (int)(kScreenItemNum/2)) {
            [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        //collectionView动画
        if (indexPath.item > (int)(kScreenItemNum/2) && indexPath.item < self.homeViewModel.menuArray.count - (int)(kScreenItemNum/2)) {
            [self.collectionView setContentOffset:CGPointMake((indexPath.item - (int)(kScreenItemNum/2))*(kscreenWidth/kScreenItemNum), 0) animated:YES];
        }
        
        if (indexPath.item >= self.homeViewModel.menuArray.count - (int)(kScreenItemNum/2)) {
            [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentSize.width - kscreenWidth, 0) animated:YES];
        }
        
        if ([self.delegate respondsToSelector:@selector(collectionView:selectItemAtIndexPath:)]) {
            [self.delegate collectionView:collectionView selectItemAtIndexPath:indexPath];
        }
    }
}

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

- (void)setOffsetX:(CGFloat)offsetX {
    _offsetX = offsetX;
    NSInteger index = (int)(offsetX/kscreenWidth);
    CGFloat rate = ((offsetX - index*kscreenWidth)/kscreenWidth)/4;
    if (self.startOffsetX < offsetX) {//向右
        if (index == self.homeViewModel.menuArray.count - 1) {
            [self.fontArray replaceObjectAtIndex:index withObject:@(0.25 + 1 - rate)];
        } else {
            [self.fontArray replaceObjectAtIndex:index + 1 withObject:@(rate + 1)];
            [self.fontArray replaceObjectAtIndex:index withObject:@(0.25 + 1 - rate)];
        }
    }
    if (self.startOffsetX > offsetX) {//向左
        if (offsetX/kscreenWidth < 0) {
            [self.fontArray replaceObjectAtIndex:index withObject:@(0.25 + 1 + rate)];
        } else {
            [self.fontArray replaceObjectAtIndex:index + 1 withObject:@(rate + 1)];
            [self.fontArray replaceObjectAtIndex:index withObject:@(0.25 + 1 - rate)];
        }
    }
    [self.collectionView reloadData];
    
    if (index <= kScreenItemNum/2) {
        [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    if (index > kScreenItemNum/2 && index < self.homeViewModel.menuArray.count - kScreenItemNum/2) {
        [self.collectionView setContentOffset:CGPointMake((index - kScreenItemNum/2)*(kscreenWidth/kScreenItemNum), 0) animated:YES];
    }
    
    if (index >= self.homeViewModel.menuArray.count - (int)(kScreenItemNum/2)) {
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentSize.width - kscreenWidth, 0) animated:YES];
    }
    
    
}

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
        _slideView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 2, CGRectGetWidth(self.frame)/5, 2)];
        _slideView.backgroundColor = [UIColor redColor];
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
