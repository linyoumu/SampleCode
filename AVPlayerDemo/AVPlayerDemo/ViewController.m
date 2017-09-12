//
//  ViewController.m
//  AVPlayerDemo
//
//  Created by Myfly on 17/9/2.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import "ViewController.h"
#import "LinMovieView.h"

@interface ViewController ()

@property (strong, nonatomic) LinMovieView *movieView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LinMovieView *movieView = [[LinMovieView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 300)];
    
    [self.view addSubview:movieView];
    
    self.movieView = movieView;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
