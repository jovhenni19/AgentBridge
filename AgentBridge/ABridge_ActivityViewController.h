//
//  ABridge_ActivityViewController.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/14/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_ParentViewController.h"
#import "ASIHTTPRequest.h"

@interface ABridge_ActivityViewController : ABridge_ParentViewController <UIPageViewControllerDataSource, NSURLConnectionDelegate>

@property (strong, nonatomic) UIPageViewController *pageController;

@end
