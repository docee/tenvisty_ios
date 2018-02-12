//
//  NSLayoutConstraint+Add.m
//  tenvisty
//
//  Created by Tenvis on 2018/2/12.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "NSLayoutConstraint+Add.h"

@implementation NSLayoutConstraint (Add)

-(void)setMultiplier:(CGFloat)multiplier{
    [NSLayoutConstraint deactivateConstraints:@[self]];
    
    //if(existConstraint == nil){
    NSLayoutConstraint *myConstraint =[NSLayoutConstraint
                                       constraintWithItem:self.firstItem //子试图
                                       attribute:self.firstAttribute //子试图的约束属性
                                       relatedBy:self.relation //属性间的关系
                                       toItem:self.secondItem//相对于父试图
                                       attribute:self.secondAttribute//父试图的约束属性
                                       multiplier:multiplier
                                       constant:self.constant];// 固定距离
    myConstraint.identifier = self.identifier;
    myConstraint.shouldBeArchived = self.shouldBeArchived;
    myConstraint.priority = self.priority;
    [NSLayoutConstraint activateConstraints:@[myConstraint]];
}

@end
