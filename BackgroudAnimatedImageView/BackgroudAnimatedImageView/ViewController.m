//
//  ViewController.m
//  BackgroudAnimatedImageView
//
//  Created by hushuangfei on 16/8/24.
//  Copyright © 2016年 胡双飞. All rights reserved.
//

#import "ViewController.h"
#import "HSF_AnimatedImagesView.h"
@interface ViewController ()<HSF_AnimatedImagesViewDatasource>
@property(nonatomic,strong)HSF_AnimatedImagesView *animatedImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.animatedImageView = [[HSF_AnimatedImagesView alloc]initWithFrame:self.view.frame];
    
    _animatedImageView.datasource = self;
    [self.view addSubview:_animatedImageView];
  
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self.animatedImageView startAnimating];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.animatedImageView stopAnimating];
}
#pragma mark - HSF_AnimatedImagesViewDatasource
-(NSInteger)numberOfImagesInAnimateImagesView:(HSF_AnimatedImagesView *)animatedImageView{
    return 4;
}

-(UIImage *)animatedImagesView:(HSF_AnimatedImagesView *)animatedImagesView imageAtIndex:(NSInteger)index{
    return [UIImage imageNamed:[NSString stringWithFormat:@"login%lu",index]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
