//
//  EventCustomSearchSource.m
//  tenvisty
//
//  Created by lu yi on 12/23/17.
//  Copyright © 2017 Tenvis. All rights reserved.
//

#import "EventCustomSearchSource.h"
@interface EventCustomSearchSource(){
    NSInteger originHeight;
    CGRect hideFrame;
    CGRect showFrame;
}
@property (nonatomic,weak) UITableView *tableview;
@end
@implementation EventCustomSearchSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.tableview = tableView;
    hideFrame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, 0.1);
    showFrame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableView.frame.size.height);
    self.tableview.backgroundColor = Color_Primary;
    return 5;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableviewcell_eventsearch" forIndexPath:indexPath];
    UILabel *labTitle = [cell.contentView.subviews objectAtIndex:0];
    if(self.type == 1){
        if(indexPath.row == 0){
            labTitle.text = LOCALSTR(@"Within a day");
        }
        else if(indexPath.row == 1){
            labTitle.text = LOCALSTR(@"Within 2 days");
        }
        else if(indexPath.row == 2){
            labTitle.text = LOCALSTR(@"Within 3 days");
        }
        else if(indexPath.row == 3){
            labTitle.text = LOCALSTR(@"Within a week");
        }
        else if(indexPath.row == 4){
            labTitle.text = LOCALSTR(@"Custom");
        }
    }
    else{
        if(indexPath.row == 0){
            labTitle.text = LOCALSTR(@"Within an hour");
        }
        else if(indexPath.row == 1){
            labTitle.text = LOCALSTR(@"Within half a day");
        }
        else if(indexPath.row == 2){
            labTitle.text = LOCALSTR(@"Within a day");
        }
        else if(indexPath.row == 3){
            labTitle.text = LOCALSTR(@"Within a week");
        }
        else if(indexPath.row == 4){
            labTitle.text = LOCALSTR(@"Custom");
        }
    }
    [cell setBackgroundColor:Color_Primary];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_delegate!= nil && [_delegate respondsToSelector:@selector(didSelect:)]){
        [_delegate didSelect:indexPath.row];
    }
    //[tableView setHidden:YES];
}

-(void)dismiss{
    if(self.tableview){
        self.tableview.translatesAutoresizingMaskIntoConstraints = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.tableview.frame = hideFrame;
        }  completion:^(BOOL finished){
            [self.tableview setHidden:YES];
        }];
    }
}
-(BOOL)toggleShow{
    if(self.tableview){
        if([self.tableview isHidden] || self.tableview.frame.size.height<=1){
            [self show];
            return true;
        }
        else{
            [self dismiss];
            return false;
        }
    }
    return false;
}
-(void)show{
    if(self.tableview){
        self.tableview.frame = hideFrame;
        [self.tableview setHidden:NO];
        [UIView animateWithDuration:0.3 animations:^{
           self.tableview.frame = showFrame;
        }];
    }
}

@end
