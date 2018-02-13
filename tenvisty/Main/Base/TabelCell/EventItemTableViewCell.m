//
//  EventItemTableViewCell.m
//  tenvisty
//
//  Created by Tenvis on 17/12/6.
//  Copyright © 2017年 Tenvis. All rights reserved.
//
#import "EventItemTableViewCell.h"

@interface EventItemTableViewCell(){
    NSInteger btnSelectWidth;
}
@property (nonatomic, assign) Event *model;
@end
@implementation EventItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    btnSelectWidth = self.constraint_width_btnSelect.constant;
    [self setEditMode:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setEditMode:(BOOL)edit{
    if(edit){
        self.constraint_width_btnSelect.constant = btnSelectWidth;
    }
    else{
         self.constraint_width_btnSelect.constant = 0;
    }
}
- (IBAction)clickSelect:(UIButton*)sender {
    if(sender.isEnabled){
        sender.selected = !sender.selected;
        _model.isSelected = sender.selected;
    }
}
-(void)setDisableMode:(BOOL)disable{
    [self.btnSelect setEnabled:!disable];
}
-(void)setModel:(Event*)model{
    _model = model;
    if(model.downloadState == 1){
        [self.btnSelect setEnabled:NO];
        self.btnSelect.selected = NO;
        model.isSelected = NO;
    }
    else{
        self.btnSelect.selected = model.isSelected;
        [self.btnSelect setEnabled:YES];
    }
}
-(void)toggleSelect{
    [self clickSelect:self.btnSelect];
}

@end
