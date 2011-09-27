//
//  RegisterScreen.h
//  HidreenSoftware
//
//  Created by Hidreen International on 8/13/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "KeyValuePair.h"
#import "CustomEditField.h"

@protocol TimezoneSelectDelegate
- (void)onTimezoneSelected:(KeyValuePair *)kvpTimeZone;
@end


@interface RegisterScreen : BaseViewController <TimezoneSelectDelegate> {
	NSArray *listFormFields;
	IBOutlet UIView *loadingView;
	BOOL isSubmitting;
	UIButton *btnRegister;
	CustomEditField *timezoneField;
	NSString *keyTimezone;
}

@end
