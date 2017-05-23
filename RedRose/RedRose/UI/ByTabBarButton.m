//
//  TabBarButton.m
//  梦香菜谱
//
//  Created by imac on 15/9/28.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "ByTabBarButton.h"

@implementation ByTabBarButton

//自定义按钮初始化方法
- (id)initWithFrame:(CGRect)frame
              Image:(UIImage *)image
      SelectedImage:(UIImage *)selectedImage
              Title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        //创建按钮子视图
        [self _createSubviews];
        
        _buttonImageView.image = image;
        _selectedImageView.image = selectedImage;
        _buttonLabel.text = title;
    }
    return self;
}

- (void) relayoutviews {
    
    CGFloat width = SCREEN_WIDTH / 5;
    CGFloat height = 49;
    //创建selectedImageView，选中状态图片
    _selectedImageView.frame = CGRectMake(0, height/6, width, height/2);
    
    //创建buttonImageView，未选中状态图片
    _buttonImageView.frame  = CGRectMake(0,height/6, width, height/2);
    
    //创建buttonLabel，按钮图片下方文字
    _buttonLabel.frame = CGRectMake(0, height*4/6, width, height*2/6);

}

//创建按钮子视图
- (void)_createSubviews {
    CGFloat width = SCREEN_WIDTH / 5;
    CGFloat height = 49;
    //创建selectedImageView，选中状态图片
    _selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height/6, width, height/2)];
    _selectedImageView.contentMode = UIViewContentModeScaleAspectFit; //防止图片变形
    [self addSubview:_selectedImageView];
    _selectedImageView.hidden = YES;
    
    //创建buttonImageView，未选中状态图片
    _buttonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,height/6, width, height/2)];
    _buttonImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_buttonImageView];
    
    //创建buttonLabel，按钮图片下方文字
    _buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height*4/6, width, height*2/6)];
    _buttonLabel.textColor = [UIColor grayColor];
    _buttonLabel.textAlignment = NSTextAlignmentCenter;
    _buttonLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_buttonLabel];
}


//按钮是否选中时改变状态
- (void)setIsSelectedButton:(BOOL)isSelectedButton {
    
    if (isSelectedButton) {
        _selectedImageView.hidden = NO;
        _buttonImageView.hidden = YES;
        _buttonLabel.textColor = [UIColor colorWithRed:37/255.0 green:154/255.0 blue:217/255.0 alpha:1]; //选中状态标题为紫色
    }
    else
    {
        _selectedImageView.hidden = YES;
        _buttonImageView.hidden = NO;
        _buttonLabel.textColor = [UIColor grayColor];
    }
}

@end
