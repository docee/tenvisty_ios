//
//  LinkButtonTableViewCell.m
//  tenvisty
//
//  Created by Tenvis on 2018/2/5.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "LinkButtonTableViewCell.h"

@interface LinkButtonTableViewCell(){
    
}

@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_width_leftImg;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@end

@implementation LinkButtonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.rightButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
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

-(void)setCellModel:(ListImgTableViewCellModel *)cellModel{
    [super setCellModel:cellModel];
    [self refreshCell];
}

-(void)refreshCell{
    [super refreshCell];
    if(self.cellModel){
        _leftLabel.text = self.cellModel.titleText;
        if(self.cellModel.showValue && self.cellModel.titleValue == nil){
            [_rightButton setEnabled:NO];
        }
        else{
            [_rightButton setEnabled:YES];
        }
        [_rightButton setTitle:@"loading..." forState:UIControlStateDisabled];
        [_rightButton setTitle:self.cellModel.titleValue forState:UIControlStateNormal];
        [self setLeftImage:self.cellModel.titleImgName];
    }
}

-(void)clickButton:(UIButton*)sender{
    if(self.cellModel && self.cellModel.delegate && [self.cellModel.delegate respondsToSelector:@selector(ListImgTableViewCellModel:didClickButton:)]){
        [self.cellModel.delegate ListImgTableViewCellModel:self.cellModel didClickButton:sender];
    }
}
@end
