//
//  TwsViewTools.m
//  tenvisty
//
//  Created by Tenvis on 2017/12/14.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "TwsViewTools.h"

@implementation TwsViewTools

+(void)setButtonContentCenter:(UIButton *) btn
{
    CGSize imgViewSize,titleSize,btnSize;
    UIEdgeInsets imageViewEdge,titleEdge;
    CGFloat heightSpace = 15.0f;
    
    //设置按钮内边距
    imgViewSize = btn.imageView.bounds.size;
    titleSize = btn.titleLabel.bounds.size;
    btnSize = btn.bounds.size;
    
    imageViewEdge = UIEdgeInsetsMake(-btn.titleLabel.intrinsicContentSize.height-heightSpace,0.0,0.0,  -btn.titleLabel.intrinsicContentSize.width);
    [btn setImageEdgeInsets:imageViewEdge];
    titleEdge = UIEdgeInsetsMake(btn.currentImage.size.height+heightSpace,-btn.currentImage.size.width,0.0,0.0);
    [btn setTitleEdgeInsets:titleEdge];
}
@end
