//
//  LinImageBrowseController.m
//  DealWithHTML
//
//  Created by Myfly on 17/9/18.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import "LinImageBrowseController.h"
#import "LinImageItemView.h"
#import "MBProgressHUD+Add.h"

@interface LinImageBrowseController ()<LinImageItemViewDelegate,UIScrollViewDelegate>
{
    CGFloat lastScale;
    UIView *_bgView;
    UIImageView * _img;
}
@property (nonatomic,strong)NSMutableArray * subViewList;
@property (nonatomic,strong)UIViewController * supViewController;

@end

@implementation LinImageBrowseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.subViewList = [NSMutableArray arrayWithCapacity:0];
    lastScale = 1.0;
    self.view.backgroundColor = [UIColor blackColor];
    
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapView)];
    //    [self.view addGestureRecognizer:tap];
    [self initScrollView];
    [self addOtherViews];
    [self setPicCurrentIndex:self.currentIndex];
}

- (void) viewWillAppear:(BOOL)animated{
    if (_isOpenUrl) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


-(void)initScrollView{
    //    [[SDImageCache sharedImageCache] cleanDisk];
    //    [[SDImageCache sharedImageCache] clearMemory];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    
    self.scrollView.delegate = self;
    self.scrollView.contentOffset = CGPointMake(0, 0);
    //设置放大缩小的最大，最小倍数
    //    self.scrollView.minimumZoomScale = 1;
    //    self.scrollView.maximumZoomScale = 2;
    [self.view addSubview:self.scrollView];
    if (self.imgArr) {
        self.scrollView.contentSize = CGSizeMake(self.imgArr.count*ScreenWidth, ScreenHeight);
        for (int i = 0; i < self.imgArr.count; i++) {
            [_subViewList addObject:[NSNull class]];
        }
    }else{
        self.scrollView.contentSize = CGSizeMake(self.modelArr.count*ScreenWidth, ScreenHeight);
        NSMutableArray * muArray = [[NSMutableArray alloc]initWithCapacity:0];
        for (NSDictionary * dic  in self.modelArr) {
            [_subViewList addObject:[NSNull class]];
            [muArray addObject:[dic valueForKey:self.key]];
        }
        self.imgArr = [NSArray arrayWithArray:muArray];
    }
    
    
}

-(void)addOtherViews{
    self.sliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, ScreenHeight - 56, 200, 38)];
    self.sliderLabel.backgroundColor = [UIColor clearColor];
    self.sliderLabel.textColor = [UIColor whiteColor];
    self.sliderLabel.shadowColor = [UIColor blackColor]; //增加阴影
    self.sliderLabel.shadowOffset = CGSizeMake(1,1);
    self.sliderLabel.text = [NSString stringWithFormat:@"%zd / %lu",self.currentIndex+1,(unsigned long)self.imgArr.count];
    [self.view addSubview:self.sliderLabel];
    //    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    //    [leftButton addTarget:self action:@selector(quitImgBrowseController) forControlEvents:UIControlEventTouchUpInside];
    //    [leftButton setTitle:@"退出" forState:UIControlStateNormal];
    //    [self.view addSubview:leftButton];
    UIButton * rightButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 60, ScreenHeight - 68, 60, 60)];
    [rightButton addTarget:self action:@selector(saveImageTophoto) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"pic_icon_xiazai_"] forState:UIControlStateNormal];
    [self.view addSubview:rightButton];
}


#pragma mark - ImageDelegate
- (void)disMissImageBrowseController{
    [self quitImgBrowseController];
}
- (void)saveImageTophoto{
    LinImageItemView * currentView = _subViewList [_currentIndex];
    UIImageWriteToSavedPhotosAlbum(currentView.imageView.image ? : nil, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [MBProgressHUD showTipMessag:@"图片保存成功" toView:self.view];
}
#pragma mark - seting
-(void)setPicCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    self.scrollView.contentOffset = CGPointMake(ScreenWidth*currentIndex, 0);
    [self loadPhote:_currentIndex];
    [self loadPhote:_currentIndex+1];
    [self loadPhote:_currentIndex-1];
}

-(void)loadPhote:(NSInteger)index{
    if (index<0 || index >=self.imgArr.count) {
        return;
    }
    [_img sd_setImageWithURL:[NSURL URLWithString:[self.imgArr objectAtIndex:index]]];
    id currentPhotoView = [_subViewList objectAtIndex:index];
    if (![currentPhotoView isKindOfClass:[LinImageItemView class]]) {
        //url数组
        CGRect frame = CGRectMake(index*_scrollView.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        LinImageItemView *photoV = [[LinImageItemView alloc] initWithFrame:frame withPhotoUrl:[self.imgArr objectAtIndex:index]];
        photoV.delegate = self;
        [self.scrollView insertSubview:photoV atIndex:0];
        [_subViewList replaceObjectAtIndex:index withObject:photoV];
    }
}

#pragma mark - PhotoViewDelegate
-(void)TapHiddenPhotoView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)OnTapView{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//手势
-(void)pinGes:(UIPinchGestureRecognizer *)sender{
    if ([sender state] == UIGestureRecognizerStateBegan) {
        lastScale = 1.0;
    }
    CGFloat scale = 1.0 - (lastScale -[sender scale]);
    lastScale = [sender scale];
    self.scrollView.contentSize = CGSizeMake(self.imgArr.count*ScreenWidth, ScreenHeight*lastScale);
    NSLog(@"scale:%f   lastScale:%f",scale,lastScale);
    CATransform3D newTransform = CATransform3DScale(sender.view.layer.transform, scale, scale, 1);
    
    sender.view.layer.transform = newTransform;
    if ([sender state] == UIGestureRecognizerStateEnded) {
        //
    }
}
#pragma mark - Show
- (void)presentFromRootViewControllerWithController:(UIViewController *)supViewController
{
    [supViewController presentViewController:self animated:NO completion:nil];
    self.view.hidden = YES;
    UIWindow * ws = [UIApplication sharedApplication].windows [0];
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _bgView.alpha = 0;
    [_bgView setBackgroundColor:[UIColor blackColor]];
    [ws addSubview:_bgView];
    _img = [[UIImageView alloc]initWithFrame:self.view.bounds];
    if (self.imgArr) {
        [_img sd_setImageWithURL:[NSURL URLWithString:self.imgArr [self.currentIndex]]];
    }else{
        [_img sd_setImageWithURL:[NSURL URLWithString:[self.modelArr [self.currentIndex] valueForKey:self.key]]];
    }
    _img.contentMode = UIViewContentModeScaleAspectFit;
    [_bgView addSubview:_img];
    [self shakeToShow:_bgView];
    [UIView animateWithDuration:0.25 animations:^{
        _bgView.alpha = 1;
    }];
    [self performSelector:@selector(presentController) withObject:self afterDelay:0.25];
}

#pragma mark - add dismiss Controller

- (void)presentController{
    _bgView.hidden = YES;
    self.view.hidden = NO;
}

- (void)quitImgBrowseController{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self disMissToShow:_bgView];
    [self performSelector:@selector(disMissController) withObject:self afterDelay:0.25];
    [UIView animateWithDuration:0.25 animations:^{
        _bgView.alpha = 0;
    }];
}
- (void)disMissController{
    [_bgView removeFromSuperview];
}
#pragma mark - animation

- (void)shakeToShow:(UIView*)aView{
    aView.hidden = NO;
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.25;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

- (void)disMissToShow:(UIView *)aView{
    aView.hidden = NO;
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.25;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int i = scrollView.contentOffset.x/ScreenWidth+1;
    [self loadPhote:i-1];
    
    self.sliderLabel.text = [NSString stringWithFormat:@"%d / %lu",i,(unsigned long)self.imgArr.count];
}


@end
