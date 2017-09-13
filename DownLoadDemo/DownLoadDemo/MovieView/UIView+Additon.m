//
//  UIView+Additon.m
//  DoubanAlbum
//
//  Created by Tonny on 12-12-10.
//  Copyright (c) 2012年 SlowsLab. All rights reserved.
//

#import "UIView+Additon.h"
#import <objc/runtime.h>
#define loadingViewTag 3455899
#define defaultViewTag 3323221
#define hubViewTag 4343523
@implementation UIView (Additon)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
    return self.frame.origin.x;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.left + self.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    if(right == self.right){
        return;
    }
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.top + self.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    if(bottom == self.bottom){
        return;
    }
    
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    if(height == self.height){
        return;
    }
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin {
    return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size {
    return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* child in self.subviews) {
        UIView* it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}

- (id)subviewWithTag:(NSInteger)tag{
    for(UIView *view in [self subviews]){
        if(view.tag == tag){
            return view;
        }
    }
    
    return nil;
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


static char kActionHandlerTapBlockKey;
static char kActionHandlerTapGestureKey;

- (void)setMenuActionWithBlock:(void (^)(void))block {
	UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kActionHandlerTapGestureKey);
	
	if (!gesture) {
		gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
		[self addGestureRecognizer:gesture];
		objc_setAssociatedObject(self, &kActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
	}
    
	objc_setAssociatedObject(self, &kActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)handleActionForTapGesture:(UITapGestureRecognizer *)gesture {
	if (gesture.state == UIGestureRecognizerStateRecognized) {
		void(^action)(void) = objc_getAssociatedObject(self, &kActionHandlerTapBlockKey);
		
		if (action) {
			action();
		}
	}
}

- (void)moveOrigin:(CGPoint)origin
{
	self.origin = CGPointMake(self.frame.origin.x + origin.x, self.frame.origin.y + origin.y);
}

- (void)moveX:(CGFloat)x
{
	self.left = self.origin.x + x;
}

- (void)moveY:(CGFloat)y
{
	self.top = self.origin.y + y;
}



- (void)toLeft
{
	self.left = 0.0;
}

- (void)toTop
{
	self.top = 0.0;
}

- (void)toRight
{
	if( self.superview ){
		self.left = self.superview.width - self.width;
	}
}

- (void)toBottom
{
	if( self.superview ){
		self.top = self.superview.height - self.height;
	}
}

- (void)autoExpand
{
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (UIView*)subviewAtIndex:(NSInteger)index
{
	return [self.subviews objectAtIndex:index];
}

- (UIView*)prevView
{
	UIView*	view = nil;
	
	//Superviewが存在する場合のみ
	if( self.superview ){
		NSInteger	index = [self.superview indexOfSubview:self];
		if( 0 < index ){
			view = [self.superview subviewAtIndex:index-1];
		}
	}
	
	return view;
}

- (UIView*)nextView
{
	UIView*	view = nil;
	
	//Superviewが存在する場合のみ
	if( self.superview ){
		NSInteger	index = [self.superview indexOfSubview:self];
		if( index < [self.superview allSubviewsCount]-1 ){
			view = [self.superview subviewAtIndex:index+1];
		}
	}
	
	return view;
}

- (NSInteger)indexOfSubview:(UIView*)subview
{
	return [self.subviews indexOfObject:subview];
}

- (NSInteger)allSubviewsCount
{
	return [self.subviews count];
}

- (void)removeAllSubviews
{
	NSEnumerator*	enumerator = [self.subviews reverseObjectEnumerator];
	
	UIView*	subView = nil;
	while( subView = [enumerator nextObject] ){
		[subView removeFromSuperview];
	}
}

- (void)fadeInAnimationWithDuration:(NSTimeInterval)duration
						 completion:(void (^)(BOOL))completion
{
	[self.layer removeAllAnimations];
	
	self.alpha = 0.0;
	self.hidden = NO;
	
	//フェードインアニメーション
	[UIView animateWithDuration:duration
					 animations:^{
						 self.alpha = 1.0;
					 }
					 completion:^( BOOL finished ){
						 if( finished == NO ){
							 self.hidden = YES;
						 }
						 
						 //コールバック
						 if( completion ){
							 completion( finished );
						 }
					 }];
}

- (void)fadeOutAnimationWithDuration:(NSTimeInterval)duration
						  completion:(void (^)(BOOL))completion
{
	[self.layer removeAllAnimations];
	

	[UIView animateWithDuration:duration
					 animations:^{
						 self.alpha = 0.0;
					 }
					 completion:^( BOOL finished ){
						 self.alpha = 1.0;
						 if( finished == NO ){
							 self.hidden = NO;
						 }else{
							 self.hidden = YES;
						 }
						 

						 if( completion ){
							 completion( finished );
						 }
					 }];
}

- (UIImage*)capturedImageWithSize:(CGSize)size
{
	UIImage*	image = nil;
	CGRect		rect = CGRectZero;
	
	rect.size = size;
	
	UIGraphicsBeginImageContextWithOptions( /*rect.size*/self.bounds.size, NO, 0 );	// ラスト引数に0を指定する事により、機種依存の解像度を吸収してくれるっぽい
	
	CGContextRef	context = UIGraphicsGetCurrentContext();
	CGContextFillRect( context, rect );
	[self.layer renderInContext:context];
	image = [UIImage imageWithData:UIImagePNGRepresentation( UIGraphicsGetImageFromCurrentImageContext() )];
	
	UIGraphicsEndImageContext();
	
	return image;
}
// Ensure that both dimensions fit within the given size by scaling down
- (void) fitInSize: (CGSize) aSize
{
	CGFloat scale;
	CGRect newframe = self.frame;
	
	if (newframe.size.height && (newframe.size.height > aSize.height))
	{
		scale = aSize.height / newframe.size.height;
		newframe.size.width *= scale;
		newframe.size.height *= scale;
	}
	
	if (newframe.size.width && (newframe.size.width >= aSize.width))
	{
		scale = aSize.width / newframe.size.width;
		newframe.size.width *= scale;
		newframe.size.height *= scale;
	}
	
	self.frame = newframe;
}

- (void)showLoadingView
{
    
    [self showLoadingViewWithString:@"正在载入..."];
    
}
- (void)showLoadingViewWithString:(NSString *)str
{
    
    UIView *loadingView = [self viewWithTag:loadingViewTag];
    if (!loadingView) {
        
        CGSize strSize = [str sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake(self.bounds.size.width-100, self.bounds.size.height) lineBreakMode:NSLineBreakByWordWrapping];
        loadingView = [[UIView alloc]initWithFrame:self.bounds];
        loadingView.backgroundColor = [UIColor clearColor];
        loadingView.tag = loadingViewTag;
        [self addSubview:loadingView];
        
        
        CGFloat centerX = (self.bounds.size.width - (20+strSize.width))/2;
        
        //创建加载条
        UIActivityIndicatorView *aivWaiting = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [aivWaiting startAnimating];
        aivWaiting.frame = CGRectMake(centerX, loadingView.center.y-10, 20, 20);
        [loadingView addSubview:aivWaiting];
        
        
        UILabel *textLabel=[[UILabel alloc] initWithFrame:CGRectMake(aivWaiting.frame.origin.x+aivWaiting.frame.size.width+5, aivWaiting.frame.origin.y, 200, 20)];
        textLabel.textColor=[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
        [textLabel setFont:[UIFont systemFontOfSize:13.0f]];
        textLabel.backgroundColor=[UIColor clearColor];
        textLabel.textAlignment=NSTextAlignmentLeft;
        textLabel.text= str;
        [loadingView addSubview:textLabel];
        
    }
}
- (void)hideLoadingView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *loadingView = [self viewWithTag:loadingViewTag];
        if (!loadingView) {
            return;
        }else
        {
            [loadingView removeFromSuperview];
        }
    });
    
}

- (void)addCenterMsgView:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UILabel *label = (UILabel *)[self viewWithTag:defaultViewTag];
        
        if (!label) {
            
//            CGSize strSize = [msg sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(self.bounds.size.width-120, self.bounds.size.height) lineBreakMode:NSLineBreakByWordWrapping];
//            label = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, MIN(strSize.width+20, 200) , strSize.height+10)];
//            label.backgroundColor = [UIColor clearColor];
//            label.textAlignment  = NSTextAlignmentCenter;
//            label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
//            label.font = [UIFont systemFontOfSize:15];
//            label.textColor = [UIColor blackColor];
//            label.text = msg;
//            label.center  = self.center;
            label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height/2-20, 320, 40)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = msg;
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont fontWithName:@"Avenir-Medium" size:16];;
            label.tag = defaultViewTag;

            [self addSubview:label];
            [self bringSubviewToFront:label];
            
        }
        
        
    });
    
}
- (void)removeCenterMsgView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UILabel *label = (UILabel *)[self viewWithTag:defaultViewTag];
        if (label) {
            [UIView animateWithDuration:0.5 animations:^{
                label.alpha = 0;
                label.transform = CGAffineTransformMakeScale(0.1, 1);
            }];
            [label removeFromSuperview];
        }
    });
    
}
//---------------------------------------------------------------------------------
#pragma mark - Override
//---------------------------------------------------------------------------------
- (BOOL)isExclusiveTouch
{

	return YES;
}

@end
