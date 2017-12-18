//
//  AppDelegate.h
//  tenvisty
//
//  Created by Tenvis on 17/11/2.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,assign)BOOL allowRotation;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

