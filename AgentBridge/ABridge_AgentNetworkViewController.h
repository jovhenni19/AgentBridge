//
//  ABridge_AgentNetworkViewController.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/19/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_ParentViewController.h"

@interface ABridge_AgentNetworkViewController : ABridge_ParentViewController<UIPageViewControllerDataSource, NSURLConnectionDelegate>
    
    @property (strong, nonatomic) UIPageViewController *pageController;

@end
