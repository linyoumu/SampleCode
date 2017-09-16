//
//  LinFaceView.m
//  tuwenhunpaiDemo
//
//  Created by Myfly on 17/9/16.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import "LinFaceView.h"
#import "LinFaceViewCell.h"

@interface LinFaceView () <UICollectionViewDataSource, UICollectionViewDelegate,LinFaceViewCellDelegate>
// [表情名]
@property (strong, nonatomic) NSMutableArray *faceArray;
// [表情名:图片名]
@property (strong, nonatomic) NSDictionary *facePlistDic;

@end

@implementation LinFaceView
#pragma mark - Init Methods
- (nonnull instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.itemSize = frame.size;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    if (self = [super initWithFrame:frame collectionViewLayout:flowLayout]) {
        [self registerClass:[LinFaceViewCell class] forCellWithReuseIdentifier:NSStringFromClass([LinFaceViewCell class])];
        
        self.delegate = self;
        self.dataSource = self;
        self.pagingEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.faceArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LinFaceViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LinFaceViewCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    [cell setEmojis:self.faceArray[indexPath.row] emojiPlistDic:self.facePlistDic];
    return cell;
}

#pragma mark - For PageControl
- (IBAction)scroll
{
    [self scrollViewDidScroll:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.delegateForContainer && [self.delegateForContainer respondsToSelector:@selector(faceViewDidScrollToPage:)]) {
        NSUInteger page = (NSUInteger)(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5) % self.faceArray.count;
        [self.delegateForContainer faceViewDidScrollToPage:page];
    }
}

#pragma mark - Custom Delegate
- (void)faceViewCellDidSelectFaceName:(NSString *)faceName
{
    if ([self.faceDelegate respondsToSelector:@selector(faceViewDidSelectFaceName:)]) {
        [self.faceDelegate faceViewDidSelectFaceName:faceName];
    }
}

- (void)faceViewCellDidSelectRemoveString
{
    if ([self.faceDelegate respondsToSelector:@selector(faceViewDidSelectRemoveString)]) {
        [self.faceDelegate faceViewDidSelectRemoveString];
    }
}

#pragma mark - Lazy Init
- (NSMutableArray *)faceArray
{
    if (!_faceArray) {
        _faceArray = [NSMutableArray array];
        
        // 加载源数据
        NSArray *originalArray = @[ @"[nzb]", @"[lyg]", @"[slw]", @"[haha]", @"[mmd]", @"[hxx]", @"[sh]", @"[jy]", @"[ok]", @"[ax]", @"[bz]", @"[bhys]", @"[bmb]", @"[dai]", @"[fhbl]", @"[fh]", @"[fan]", @"[han]", @"[jd]", @"[jx]", @"[nu]", @"[sq]", @"[sb]", @"[wa]", @"[xia]", @"[xx]", @"[ym]", @"[yun]", @"[zj]"];
        
        // 分组
        NSUInteger countPerPage = kEmojiInputViewCellRowCount * kEmojiInputViewCellColCount;
        //        NSUInteger countPerPage = kEmojiInputViewCellRowCount * kEmojiInputViewCellColCount - 2;
        NSUInteger pages = originalArray.count / countPerPage ;
        for (NSUInteger i = 0; i < pages; i++) {
            NSMutableArray *tempfaceArray = [NSMutableArray array];
            for (NSUInteger j = i*countPerPage; j<(i+1)*countPerPage; j++) {
                [tempfaceArray addObject:originalArray[j]];
            }
            [_faceArray addObject:tempfaceArray];
        }
        // 最后一组
        if (originalArray.count % countPerPage) {
            NSMutableArray *tempfaceArray = [NSMutableArray array];
            for (NSUInteger i = pages*countPerPage; i<originalArray.count; i++) {
                [tempfaceArray addObject:originalArray[i]];
            }

            [_faceArray addObject:tempfaceArray];
        }
    }
    return _faceArray;
}

- (NSDictionary *)facePlistDic
{
    if (!_facePlistDic) {
        _facePlistDic = [LinEmojiTool faceDictionary];
    }
    return _facePlistDic;
}

- (NSUInteger)totalPage
{
    return self.faceArray.count;
}

@end
