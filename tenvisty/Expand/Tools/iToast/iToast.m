//
//  iToast.m
//  iToast
//
//  Created by Diallo Mamadou Bobo on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iToast.h"
#import <QuartzCore/QuartzCore.h>

static iToastSettings *sharedSettings = nil;

@interface iToast(private)

- (iToast *) settings;

@end


@implementation iToast


- (id) initWithText:(NSString *) tex{
	if (self = [super init]) {
		text = [tex copy];
	}
	
	return self;
}


#pragma mark -
//label的默认font.pointSize = 17.0
- (CGRect)rectOfText:(NSString *)t_text WithFont:(UIFont *)font {
    
    UIFont *attributesFont = nil;
    if (font == nil) {
        attributesFont = [UIFont systemFontOfSize:17];
    }
    else {
        attributesFont = font;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributesDic = @{NSFontAttributeName:attributesFont,
                                    NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGSize size = CGSizeMake(w-20, CGFLOAT_MAX);
    CGRect rect = [t_text boundingRectWithSize:size
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributesDic
                                     context:nil];
    
    return rect;
}


- (void) showUnRota {
    iToastSettings *theSettings = _settings;
    
    if (!theSettings) {
        theSettings = [iToastSettings getSharedSettings];
    }
    
    UIFont *font = [UIFont systemFontOfSize:16];
    //CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(280, 60)];
    CGRect textSize = [self rectOfText:text WithFont:nil];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.size.width + 5, textSize.size.height + 5)];
    //label.backgroundColor = LightBlueColor;
    label.textColor = [UIColor whiteColor];
    label.font = font;
    label.text = text;
    label.numberOfLines = 0;
//    label.shadowColor = LightBlueColor;
//    label.shadowOffset = CGSizeMake(1, 1);
    
    UIButton *v = [UIButton buttonWithType:UIButtonTypeCustom];
    v.frame = CGRectMake(0, 0, textSize.size.width + 10, textSize.size.height + 10);
    label.center = CGPointMake(v.frame.size.width / 2, v.frame.size.height / 2);
    [v addSubview:label];
    
    v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];

    v.layer.cornerRadius = 5;
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    
    CGPoint point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
    
    if (theSettings.gravity == iToastGravityTop) {
        point = CGPointMake(window.frame.size.width / 2, 45);
    }else if (theSettings.gravity == iToastGravityBottom) {
        point = CGPointMake(window.frame.size.width / 2, window.frame.size.height - 45);
    }else if (theSettings.gravity == iToastGravityCenter) {
        point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
    }else{
        point = theSettings.postition;
    }
    
    point = CGPointMake(point.x + offsetLeft, point.y + offsetTop);
    v.center = point;
    [v setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
    
    
//    NSTimer *timer1 = [NSTimer timerWithTimeInterval:((float)theSettings.duration)/1000
//                                              target:self selector:@selector(hideToast:)
//                                            userInfo:nil repeats:NO];
//    [[NSRunLoop mainRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
    
    [window addSubview:v];
    if(theSettings.duration <= 0 || theSettings.duration>5){
        theSettings.duration = 1;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(theSettings.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [v removeFromSuperview];
    });

//    [v addTarget:self action:@selector(hideToast:) forControlEvents:UIControlEventTouchDown];
    
}


- (void) showRota {
    iToastSettings *theSettings = _settings;
    
    if (!theSettings) {
        theSettings = [iToastSettings getSharedSettings];
    }
    
    UIFont *font = [UIFont systemFontOfSize:16];
    //CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(280, 60)];
    CGRect textSize = [self rectOfText:text WithFont:nil];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.size.width + 5, textSize.size.height + 5)];
    //label.backgroundColor = LightBlueColor;
    label.textColor = [UIColor whiteColor];
    label.font = font;
    label.text = text;
    label.numberOfLines = 0;
    //    label.shadowColor = LightBlueColor;
    //    label.shadowOffset = CGSizeMake(1, 1);
    
    UIButton *v = [UIButton buttonWithType:UIButtonTypeCustom];
    v.frame = CGRectMake(0, 0, textSize.size.width + 10, textSize.size.height + 10);
    label.center = CGPointMake(v.frame.size.width / 2, v.frame.size.height / 2);
    [v addSubview:label];
    
    v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    v.layer.cornerRadius = 5;
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    
    CGPoint point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
    
    if (theSettings.gravity == iToastGravityTop) {
        point = CGPointMake(window.frame.size.width / 2, 45);
    }else if (theSettings.gravity == iToastGravityBottom) {
        point = CGPointMake(window.frame.size.width / 2, window.frame.size.height - 45);
    }else if (theSettings.gravity == iToastGravityCenter) {
        point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
    }else{
        point = theSettings.postition;
    }
    
    point = CGPointMake(point.x + offsetLeft, point.y + offsetTop);
    v.center = point;
    [v setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
    
    
    //    NSTimer *timer1 = [NSTimer timerWithTimeInterval:((float)theSettings.duration)/1000
    //                                              target:self selector:@selector(hideToast:)
    //                                            userInfo:nil repeats:NO];
    //    [[NSRunLoop mainRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
    
    [window addSubview:v];
       if(theSettings.duration <= 0 || theSettings.duration>5){
        theSettings.duration = 1;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(theSettings.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [v removeFromSuperview];
    });
    
    //    [v addTarget:self action:@selector(hideToast:) forControlEvents:UIControlEventTouchDown];

}

- (void) show{
    iToastSettings *theSettings = _settings;
    
    if (!theSettings) {
        theSettings = [iToastSettings getSharedSettings];
    }
    UIFont *font = [UIFont systemFontOfSize:16];
    //CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(280, 60)];
    CGRect textSize = [self rectOfText:text WithFont:nil];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.size.width + 5, textSize.size.height + 5)];
    //label.backgroundColor = LightBlueColor;
    label.textColor = [UIColor whiteColor];
    label.font = font;
    label.text = text;
    label.numberOfLines = 0;
    //多行
    if(textSize.size.height > 30){
        [label setTextAlignment:NSTextAlignmentLeft];
    }
    else{
        [label setTextAlignment:NSTextAlignmentCenter];
    }
    //    label.shadowColor = LightBlueColor;
    //    label.shadowOffset = CGSizeMake(1, 1);
    
    UIButton *v = [UIButton buttonWithType:UIButtonTypeCustom];
    v.frame = CGRectMake(0, 0, textSize.size.width + 10, textSize.size.height + 10);
    label.center = CGPointMake(v.frame.size.width / 2, v.frame.size.height / 2);
    [v addSubview:label];
    
    v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    v.layer.cornerRadius = 5;
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    
    CGPoint point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
    
    if (theSettings.gravity == iToastGravityTop) {
        point = CGPointMake(window.frame.size.width / 2, 45);
    }else if (theSettings.gravity == iToastGravityBottom) {
        point = CGPointMake(window.frame.size.width / 2, window.frame.size.height - 45);
    }else if (theSettings.gravity == iToastGravityCenter) {
        point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
    }else{
        point = theSettings.postition;
    }
    
    point = CGPointMake(point.x + offsetLeft, point.y + offsetTop);
    v.center = point;
    //[v setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
    
    
    //    NSTimer *timer1 = [NSTimer timerWithTimeInterval:((float)theSettings.duration)/1000
    //                                              target:self selector:@selector(hideToast:)
    //                                            userInfo:nil repeats:NO];
    //    [[NSRunLoop mainRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
    
    [window addSubview:v];
    if(theSettings.duration <= 0 || theSettings.duration>5){
        theSettings.duration = 1;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(theSettings.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [v removeFromSuperview];
    });
    
    //    [v addTarget:self action:@selector(hideToast:) forControlEvents:UIControlEventTouchDown];
}

- (void) hideToast:(NSTimer*)theTimer{
	[UIView beginAnimations:nil context:NULL];
	view.alpha = 0;
	[UIView commitAnimations];
	
//	NSTimer *timer2 = [NSTimer timerWithTimeInterval:500 
//											 target:self selector:@selector(hideToast:) 
//										   userInfo:nil repeats:NO];
    NSTimer *timer2 = [NSTimer timerWithTimeInterval:500
                                              target:self selector:@selector(removeToast:)
                                            userInfo:nil repeats:NO];

	[[NSRunLoop mainRunLoop] addTimer:timer2 forMode:NSDefaultRunLoopMode];
}

- (void) removeToast:(NSTimer*)theTimer{
	[view removeFromSuperview];
}


+ (iToast *) makeText:(NSString *) _text{
	iToast *toast = [[iToast alloc] initWithText:_text];
	
	return toast;
}


- (iToast *) setDuration:(NSInteger ) duration{
	[self theSettings].duration = duration;
	return self;
}

- (iToast *) setGravity:(iToastGravity) gravity 
			 offsetLeft:(NSInteger) left
			  offsetTop:(NSInteger) top{
	[self theSettings].gravity = gravity;
	offsetLeft = left;
	offsetTop = top;
	return self;
}

- (iToast *) setGravity:(iToastGravity) gravity{
	[self theSettings].gravity = gravity;
	return self;
}

- (iToast *) setPostion:(CGPoint) _position{
	[self theSettings].postition = CGPointMake(_position.x, _position.y);
	
	return self;
}

-(iToastSettings *) theSettings{
	if (!_settings) {
		_settings = [[iToastSettings getSharedSettings] copy];
	}
	
	return _settings;
}

@end


@implementation iToastSettings
@synthesize duration;
@synthesize gravity;
@synthesize postition;
@synthesize images;

- (void) setImage:(UIImage *) img forType:(iToastType) type{
	if (!images) {
		images = [[NSMutableDictionary alloc] initWithCapacity:4];
	}
	
	if (img) {
		NSString *key = [NSString stringWithFormat:@"%i", type];
		[images setValue:img forKey:key];
	}
}


+ (iToastSettings *) getSharedSettings{
	if (!sharedSettings) {
		sharedSettings = [iToastSettings new];
		sharedSettings.gravity = iToastGravityCenter;
		sharedSettings.duration = iToastDurationShort;
	}
	
	return sharedSettings;
	
}

- (id) copyWithZone:(NSZone *)zone{
	iToastSettings *copy = [iToastSettings new];
	copy.gravity = self.gravity;
	copy.duration = self.duration;
	copy.postition = self.postition;
	
	NSArray *keys = [self.images allKeys];
	
	for (NSString *key in keys){
		[copy setImage:[images valueForKey:key] forType:[key intValue]];
	}
	
	return copy;
}

@end
