//
//  HSF_AnimatedImagesView.h
//  BackgroudAnimatedImageView
//
//  Created by hushuangfei on 16/8/24.
//  Copyright © 2016年 胡双飞. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAnimatedImagesViewDefaultTimePerImage 20.0f

@class HSF_AnimatedImagesView;
@protocol HSF_AnimatedImagesViewDatasource <NSObject>
@required
//动画图片的的个数
/**
 *  动画图片的个数
 *
 *  @param animatedImageView  HSF_AnimatedImagesView
 *
 *  @return 个数
 */
-(NSInteger)numberOfImagesInAnimateImagesView:(HSF_AnimatedImagesView *)animatedImageView;
/**
 *  在第index个显示图片
 *
 *  @param animatedImagesView HSF_AnimatedImagesView
 *  @param index              第几个
 *
 *  @return 返回image
 */
-(UIImage *)animatedImagesView:(HSF_AnimatedImagesView *)animatedImagesView imageAtIndex:(NSInteger)index;

@end

@interface HSF_AnimatedImagesView : UIView
//数据源
@property(nonatomic,weak)id<HSF_AnimatedImagesViewDatasource> datasource;
//时间
@property(nonatomic,assign)NSTimeInterval timePerImage;
/**
 *  在最小到最大之间产出一个随机数
 *
 *  @param minNumber 最小
 *  @param maxNumber 最大
 *
 *  @return 随机数
 */
- (NSUInteger)randomIntBetweenNumber:(NSUInteger)minNumber andNumber:(NSUInteger)maxNumber;
//开始动画
-(void)startAnimating;

//停止动画
-(void)stopAnimating;

//刷新数据
-(void)reloadData;
@end
