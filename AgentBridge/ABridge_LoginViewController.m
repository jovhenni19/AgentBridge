//
//  ABridge_LoginViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/13/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_LoginViewController.h"
#import "Constants.h"
#import "LoginDetails.h"
#import "ABridge_AppDelegate.h"

@interface ABridge_LoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;
@property (weak, nonatomic) IBOutlet UIView *viewBox;
@property (weak, nonatomic) IBOutlet UITextField *textEmail;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) IBOutlet UIButton *buttonSignIn;
@property (weak, nonatomic) IBOutlet UIButton *buttonForgot;
@property (weak, nonatomic) IBOutlet UIView *viewOverlay;


@property (strong, nonatomic) NSURLConnection *urlConnectionLogin;
@property (strong, nonatomic) NSMutableData *dataReceived;
@property (strong, nonatomic) NSTimer* timer;
@property (assign, nonatomic) NSInteger count;


-(IBAction)signIn:(id)sender;
-(IBAction)forgotPassword:(id)sender;
@end

@implementation ABridge_LoginViewController

@synthesize urlConnectionLogin;
@synthesize dataReceived;
@synthesize timer;
@synthesize count;

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
    
    self.viewBox.center = self.view.center;
    self.viewOverlay.center = self.view.center;
    
//    self.viewBox.layer.cornerRadius = 5;
//    self.viewBox.layer.masksToBounds = YES;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateImage) userInfo:nil repeats:YES];
    count = 2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)updateImage{
    
    self.imageViewBackground.image = [UIImage imageNamed:[NSString stringWithFormat:@"slide_%li.png",(long)count]];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    
    [self.imageViewBackground.layer addAnimation:transition forKey:nil];
    
    if (count==4) {
        count = 0;
    }
    
    count++;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(IBAction)signIn:(id)sender {
    
    [self.textEmail resignFirstResponder];
    [self.textPassword resignFirstResponder];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelay:0.2f];
    
    self.viewBox.center = self.view.center;
    
    
    [UIView commitAnimations];
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0f];
    
    self.viewOverlay.alpha = 1.0f;
    
    [UIView commitAnimations];
    
    [self login];
}

-(IBAction)forgotPassword:(id)sender {
    
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (void)login {
    
    if (self.textEmail.text != nil && self.textPassword.text != nil) {
        if ([self NSStringIsValidEmail:self.textEmail.text]) {
            NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/login.php"];
            NSString *parameters = [NSString stringWithFormat:@"?email=%@&password=%@",self.textEmail.text,self.textPassword.text];
            [urlString appendString:parameters];
//            NSLog(@"url:%@",urlString);
            NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
            
            urlConnectionLogin = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
            
            
//            if (urlConnectionLogin) {
//                NSLog(@"Connection Successful");
//            }
//            else {
//                NSLog(@"Connection Failed");
//            }
            
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Input a valid Email Address" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Input your Email and Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelay:0.2f];
    
    CGRect frame = self.viewBox.frame;
    frame.origin.y = (isiPhone5)?100.0f:60.0f;
    self.viewBox.frame = frame;
    
    [UIView commitAnimations];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self signIn:nil];
    return NO;
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
//    NSLog(@"Did Fail");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"You have no Internet Connection available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.dataReceived options:NSJSONReadingAllowFragments error:&error];
    
//    NSLog(@"Did Finish:%@", json);
    
    NSDictionary *dataJson = [[json objectForKey:@"data"] firstObject];
    
    NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    LoginDetails *item = [NSEntityDescription
                          insertNewObjectForEntityForName:@"LoginDetails"
                          inManagedObjectContext:context];
    item.user_id = [NSNumber numberWithInt:[[dataJson objectForKey:@"id"] integerValue]];
    item.name = [dataJson objectForKey:@"name"];
    item.username = [dataJson objectForKey:@"username"];
    item.email = [dataJson objectForKey:@"email"];
    
    NSError *errorSave = nil;
    if (![context save:&errorSave]) {
        NSLog(@"Error occurred in saving Login Details:%@",[errorSave localizedDescription]);
    }
    else {
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            NSLog(@"Successfully saved Login Details");
        }];
    }
    
    
    // Do something with responseData
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5f];
    
    self.viewOverlay.alpha = 0.0f;
    
    [UIView commitAnimations];
}
@end
