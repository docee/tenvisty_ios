//
//  SearchLanAsync.h
//  tenvisty
//
//  Created by Tenvis on 17/12/8.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol SearchLanDelegate <NSObject>
@optional
- (void)onReceiveSearchResult:(LANSearchDevice *)device status:(NSInteger)status;

@end

@interface SearchLanAsync : NSObject

@property (nonatomic, assign) id<SearchLanDelegate> delegate;

-(void) beginSearch;

-(void) stopSearch;

-(NSInteger) getState;

@end
