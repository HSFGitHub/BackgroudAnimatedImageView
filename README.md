# BackgroudAnimatedImageView
     ##                 简单的动态背景
     1. 使用方式：
        直接将HSF_AnimatedImagesView.h 和.m 拖到项目中，通过实现数据源的方式创建简单的动态背景.
![](https://github.com/hushuangfei/HSFGitHub/BackgroudAnimatedImageView/raw/master/BackgroudAnimatedImageView/backgroud.gif)
        
     2. 创建方式：
     （1）遵守数据源方法
      #import "HSF_AnimatedImagesView.h"
      @interface ViewController()<HSF_AnimatedImagesViewDatasource>
      @property(nonatomic,strong)HSF_AnimatedImagesView *animatedImageView;
      @end
      
      (2)创建动画视图
      self.animatedImageView = [[HSF_AnimatedImagesView 
                    alloc]initWithFrame:self.view.frame];
                    
       _animatedImageView.datasource = self;
       
       [self.view addSubview:_animatedImageView];
      (3)实现数据源方法
      #pragma mark - HSF_AnimatedImagesViewDatasource
      //当前要显示多少个ImageView
      -(NSInteger)numberOfImagesInAnimateImagesView:(HSF_AnimatedImagesView*)animatedImageView{
       return 4;
      }
      
      //在哪个index显示哪个image
      -(UIImage *)animatedImagesView:(HSF_AnimatedImagesView *)animatedImagesView 
                        imageAtIndex:(NSInteger)index{
        return [UIImage imageNamed:[NSString stringWithFormat:@"login%lu",index]];
      }
      
      (4)开始动画
      -(void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:animated];
        [self.animatedImageView startAnimating];
      }
      (5)结束动画 
      -(void)viewWillDisappear:(BOOL)animated{
        [super viewWillDisappear:animated];
        [self.animatedImageView stopAnimating];
      }     

