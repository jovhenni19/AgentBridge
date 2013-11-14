//
//  ABridge_BuyerViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/14/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_BuyerViewController.h"
#import "ABridge_BuyerPagesViewController.h"

@interface ABridge_BuyerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelNumberOfBuyers;
@property (weak, nonatomic) IBOutlet UIView *viewForPages;
@property (weak, nonatomic) IBOutlet UILabel *labelNumberOfSaved;
@property (weak, nonatomic) IBOutlet UILabel *labelNumberOfNew;

@property (assign, nonatomic) NSInteger numberOfBuyer;
@property (strong, nonatomic) NSURLConnection *urlConnectionBuyer;
@property (strong, nonatomic) NSMutableData *dataReceived;
@end

@implementation ABridge_BuyerViewController
@synthesize numberOfBuyer;
@synthesize urlConnectionBuyer;
@synthesize dataReceived;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSString *parameters = [NSString stringWithFormat:@"?user_id=%li",(long) 1];
    
    self.urlConnectionBuyer = [self urlConnectionWithURLString:@"http://keydiscoveryinc.com/agent_bridge/webservice/getbuyers.php" andParameters:parameters];
    
    if (self.urlConnectionBuyer) {
        NSLog(@"Connection Successful");
        [self addURLConnection:self.urlConnectionBuyer];
    }
    else {
        NSLog(@"Connection Failed");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (ABridge_BuyerPagesViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    ABridge_BuyerPagesViewController *pagesViewController = [[ABridge_BuyerPagesViewController alloc] initWithNibName:@"ABridge_BuyerPagesViewController" bundle:nil];
    pagesViewController.index = index;
    
    return pagesViewController;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(ABridge_BuyerPagesViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(ABridge_BuyerPagesViewController *)viewController index];
    
    index++;
    
    if (index == self.numberOfBuyer) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return self.numberOfBuyer;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}


- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    self.dataReceived = nil;
    self.dataReceived = [[NSMutableData alloc]init];
}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    //NSLog(@"Did Receive Data %@", data);
    [self.dataReceived appendData:data];
}
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    NSLog(@"Did Fail");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"You have no Internet Connection available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.dataReceived options:NSJSONReadingAllowFragments error:&error];
    
    NSLog(@"Did Finish:%@", json);
    
//    if ([[json objectForKey:@"data"] count]) {
    
        self.numberOfBuyer = [[json objectForKey:@"data"] count];
        
        self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
        self.pageController.dataSource = self;
        self.pageController.view.frame = self.viewForPages.frame;
        
        self.labelNumberOfBuyers.text = [NSString stringWithFormat:@"My Buyers (%li)",(long)self.numberOfBuyer];
        
        ABridge_BuyerPagesViewController *initialViewController = [self viewControllerAtIndex:0];
        
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        
        [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
        [self addChildViewController:self.pageController];
        [[self view] addSubview:[self.pageController view]];
        [self.pageController didMoveToParentViewController:self];
        
//    }
    
    
    // Do something with responseData
}

@end
