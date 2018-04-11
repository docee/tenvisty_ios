//
//  TextFieldDisableTableViewCell.m
//  tenvisty
//
//  Created by Tenvis on 17/12/1.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "TextFieldDisableTableViewCell.h"

@interface TextFieldDisableTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_width_leftImg;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UITextField *rightTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_left_rightTextField;

@end



@implementation TextFieldDisableTableViewCell

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
    return _leftLabel.text;
}

-(NSString*)value{
    return _rightTextField.text;
}

-(void)resignFirstResponder{
    [_rightTextField resignFirstResponder];
}
-(void)setCellModel:(ListImgTableViewCellModel *)cellModel{
    [super setCellModel:cellModel];
    [self refreshCell];
}

-(void)refreshCell{
    [super refreshCell];
    if(self.cellModel){
        if(self.cellModel.showValue && self.cellModel.titleValue == nil){
            _rightTextField.text = LOCALSTR(@"Loading...");
        }
        else{
            _rightTextField.text = self.cellModel.titleValue;
        }
        _leftLabel.text = self.cellModel.titleText;
        _rightTextField.placeholder = self.cellModel.textPlaceHolder;
        _rightTextField.textAlignment = self.cellModel.textAlignment;
        [self setLeftImage:self.cellModel.titleImgName];
        _constraint_left_rightTextField.constant  = self.cellModel.valueMarginLeft;
    }
}
@end
