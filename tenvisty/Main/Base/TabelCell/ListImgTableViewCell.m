//
//  ListImgTableViewCell.m
//  tenvisty
//
//  Created by Tenvis on 17/12/5.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "ListImgTableViewCell.h"
@interface ListImgTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_width_leftImg;

@property (weak, nonatomic) IBOutlet UILabel *leftLabTitle;
@property (weak, nonatomic) IBOutlet UILabel *rightLabValue;
@end

@implementation ListImgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.constraint_width_leftImg.constant = 0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setLeftImage:(NSString*)imageName{
    if(imageName != nil){
        [self.leftImg setHidden:NO];
        [self.leftImg setImage:[UIImage imageNamed:imageName]];
        self.constraint_width_leftImg.constant = 30;
    }
    else{
        [self.leftImg setHidden:YES];
        self.constraint_width_leftImg.constant = 0;
    }
}

-(NSString*)title{
    return _leftLabTitle.text;
}
-(void)setTitle:(NSString *)title{
    _leftLabTitle.text = title;
}

-(NSString*)value{
    return _rightLabValue.text;
}

-(void)setValue:(NSString *)value{
    if(value == nil && _showValue){
        value = LOCALSTR(@"loading...");
    }
    _rightLabValue.text = value;
}

@end
