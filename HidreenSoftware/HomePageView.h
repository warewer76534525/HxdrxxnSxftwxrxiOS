//
//  HomePageView.h
//  HidreenSoftware
//
//  Created by Hidreen International on 8/3/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HomePageView : UIViewController <UITabBarDelegate, UITextFieldDelegate> {
	IBOutlet UITabBarController *tbc;
	NSMutableData *receivedData;
	
	IBOutlet UIButton *btnLogin;
    IBOutlet UIButton *btnRegister;
	IBOutlet UITextField *txtEmail;
	IBOutlet UITextField *txtPassword;
	IBOutlet UIView *loadingView;
}

@property (nonatomic, retain) IBOutlet UITabBarController *tbc;
@property (nonatomic, retain) IBOutlet UIButton *btnLogin;
@property (nonatomic, retain) IBOutlet UIButton *btnRegister;
@property (nonatomic, retain) IBOutlet UITextField *txtEmail;
@property (nonatomic, retain) IBOutlet UITextField *txtPassword;
@property (nonatomic, retain) IBOutlet UIView *loadingView;

- (IBAction)doLogin;
- (IBAction)goToRegisterPage;
- (void)goToHomePage;

@end
