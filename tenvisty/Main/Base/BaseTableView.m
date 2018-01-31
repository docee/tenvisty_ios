//
//  BaseTableView.m
//  tenvisty
//
//  Created by lu yi on 12/4/17.
//  Copyright © 2017 Tenvis. All rights reserved.
//

#import "BaseTableView.h"

@implementation BaseTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return YES;
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.delaysContentTouches = NO;
        for (id view in self.subviews)
        {
            // looking for a UITableViewWrapperView
            if ([NSStringFromClass([view class]) isEqualToString:@"UITableViewWrapperView"])
            {
                if([view isKindOfClass:[UIScrollView class]])
                {
                    // turn OFF delaysContentTouches in the hidden subview
                    UIScrollView *scroll = (UIScrollView *) view;
                    scroll.delaysContentTouches = NO;
                }
                break;
            }
        }
        
        [self registerNib:[UINib nibWithNibName:@"TextFieldTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewCell_TextField_Normal];
        [self registerNib:[UINib nibWithNibName:@"TextFieldImgTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewCell_TextField_Img];
        [self registerNib:[UINib nibWithNibName:@"PasswordFieldTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewCell_TextField_Password];
        [self registerNib:[UINib nibWithNibName:@"TextFieldDisableTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewCell_TextField_Disable];
        [self registerNib:[UINib nibWithNibName:@"DetailTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewCell_Detail];
        [self registerNib:[UINib nibWithNibName:@"ListImgTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewCell_ListImg];
        [self registerNib:[UINib nibWithNibName:@"SwitchTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewCell_Switch];
        [self registerNib:[UINib nibWithNibName:@"SelectItemTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewCell_SelectItem];
        [self registerNib:[UINib nibWithNibName:@"MultiTextFieldTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewCell_TextField_Multi];
        
    }
    return self;
}
//
//- (BOOL)touchesShouldCancelInContentView:(UIView *)view
//{
//    if ([view isKindOfClass:[UIButton class]])
//    {
//        return YES;
//    }
//    return [self.tableview touchesShouldCancelInContentView:view];
//}
@end
