//
//  EventCustomSearchSource.h
//  tenvisty
//
//  Created by lu yi on 12/23/17.
//  Copyright © 2017 Tenvis. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol EventCustomSearchDelegate<NSObject>

@optional
-(void)didSelect:(NSInteger)index;
@end

@interface EventCustomSearchSource : NSObject<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) id<EventCustomSearchDelegate> delegate;

-(void)show;
-(void)toggleShow;
-(void)dismiss;
@end
