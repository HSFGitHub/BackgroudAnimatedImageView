//
//  HSF_AnimatedImagesView.m
//  BackgroudAnimatedImageView
//
//  Created by hushuangfei on 16/8/24.
//  Copyright © 2016年 胡双飞. All rights reserved.
//

#import "HSF_AnimatedImagesView.h"

#define kNoImageDisplayingIndex -1
#define kImageSwappingAnimationDuration 2.0f
#define kImageViewsBorderOffset 150
@interface HSF_AnimatedImagesView ()
{
    BOOL animating; //动画
    NSUInteger totalImages; //总计
    NSUInteger currentlyDisplayingImageViewIndex; //记录当前imageView
    NSInteger  currentlyDisplayingImageIndex;//记录当前image
}

@property(nonatomic,strong)NSArray *imageViews;
@property(nonatomic,strong)NSTimer *imageSwappingTimer;


@end

@implementation HSF_AnimatedImagesView
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self initAnimateImagesView];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self initAnimateImagesView];
    }
    
    return self;
}


//初始化
- (void)initAnimateImagesView
{
    NSMutableArray *imageViews = [NSMutableArray array];
    
    for (int i = 0; i < 2; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-kImageViewsBorderOffset*3.3, -kImageViewsBorderOffset, self.bounds.size.width + (kImageViewsBorderOffset * 2), self.bounds.size.height + (kImageViewsBorderOffset * 2))];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = NO;
        [self addSubview:imageView];
        
        [imageViews addObject:imageView];
    }
    
    self.imageViews = imageViews;
    
    currentlyDisplayingImageIndex = kNoImageDisplayingIndex;
}

-(void)startAnimating{
    if (!animating) {
        animating = YES;
        [self.imageSwappingTimer fire];
    }
}

- (void)exchangeImage
{
    UIImageView *needHideImageView = [self.imageViews objectAtIndex:currentlyDisplayingImageViewIndex];
    //切换imageView的标记
     currentlyDisplayingImageViewIndex = currentlyDisplayingImageViewIndex == 0 ? 1 : 0;
    UIImageView *needShowImageView = [self.imageViews objectAtIndex:currentlyDisplayingImageViewIndex];
    
    //随机切换image标记
    NSInteger showImageIndex = 0;
    do {
            showImageIndex = [self randomIntBetweenNumber:0 andNumber:totalImages - 1];
        
    } while (showImageIndex == currentlyDisplayingImageIndex);
    currentlyDisplayingImageIndex = showImageIndex;
    
    if ([_datasource respondsToSelector:@selector(animatedImagesView:imageAtIndex:)]) {
        needShowImageView.image = [self.datasource animatedImagesView:self imageAtIndex:currentlyDisplayingImageIndex];
    }
    
    static const CGFloat kMovementAndTransitionTimeOffset = 0.1;
    [UIView animateWithDuration:self.timePerImage+kImageSwappingAnimationDuration + kMovementAndTransitionTimeOffset delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState |UIViewAnimationOptionCurveLinear animations:^{
        
        //平移
        NSInteger randomTranslationValueX = kImageViewsBorderOffset*3.5 - [self  randomIntBetweenNumber:0 andNumber:kImageViewsBorderOffset];
        NSInteger randomTranslationValueY = 0;
        CGAffineTransform translationsform = CGAffineTransformMakeTranslation(randomTranslationValueX, randomTranslationValueY);
        
        //缩放
        CGFloat randomScaleTransformValue = [self  randomIntBetweenNumber:115 andNumber:120]/100;
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(randomScaleTransformValue, randomScaleTransformValue);
        needShowImageView.transform = CGAffineTransformConcat(translationsform, scaleTransform);
        
        
        [UIView animateWithDuration:kImageSwappingAnimationDuration delay:kMovementAndTransitionTimeOffset options:UIViewAnimationOptionBeginFromCurrentState |UIViewAnimationOptionCurveLinear  animations:^{
            needShowImageView.alpha = 1.0;
            needHideImageView.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                needHideImageView.transform = CGAffineTransformIdentity;
            }
        }];
    } completion:nil];
    
}

//停止动画
-(void)stopAnimating{
    if (animating) {
        [_imageSwappingTimer invalidate];
        _imageSwappingTimer = nil;
        
        [UIView animateWithDuration:kImageSwappingAnimationDuration delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            for (UIImageView *imageVie in self.imageViews) {
                imageVie.alpha = 0.0;
            }
        } completion:^(BOOL finished) {
            currentlyDisplayingImageIndex = kNoImageDisplayingIndex;
            animating = NO;
        }];
    }
}

//刷新数据
-(void)reloadData{
    
    NSAssert(![_datasource respondsToSelector:@selector(numberOfImagesInAnimateImagesView:)], @"请实现numberOfImagesInAnimateImagesView:数据源方法");
    totalImages = [self.datasource numberOfImagesInAnimateImagesView:self];
     [self.imageSwappingTimer fire];
}

- (NSUInteger)randomIntBetweenNumber:(NSUInteger)minNumber andNumber:(NSUInteger)maxNumber{
        if (minNumber > maxNumber) {
            return [self randomIntBetweenNumber:maxNumber andNumber:minNumber];
        }
        
        NSUInteger i = (arc4random() % (maxNumber - minNumber + 1)) + minNumber;
        return i;

}
#pragma mark - dealloc
-(void)dealloc{
    [self stopAnimating];
}

#pragma mark - 重写setter方法
-(void)setDatasource:(id<HSF_AnimatedImagesViewDatasource>)datasource{
    if (datasource != _datasource) {
        _datasource = datasource;
        if ([datasource respondsToSelector:@selector(numberOfImagesInAnimateImagesView:)]) {
           totalImages = [_datasource numberOfImagesInAnimateImagesView:self];
        }
    }
}

#pragma mark - 重写getter方法
-(NSTimer *)imageSwappingTimer{
    if (!_imageSwappingTimer) {
        _imageSwappingTimer = [NSTimer scheduledTimerWithTimeInterval:self.timePerImage target:self selector:@selector(exchangeImage) userInfo:nil repeats:YES];
    }
    
    return _imageSwappingTimer;
}

-(NSTimeInterval)timePerImage{
    if (_timePerImage == 0) {
        _timePerImage = kAnimatedImagesViewDefaultTimePerImage;
    }
    return _timePerImage;
}

@end
