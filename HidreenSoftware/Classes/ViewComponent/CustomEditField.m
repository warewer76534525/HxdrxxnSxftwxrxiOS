//
//  CustomEditField.m
//  HidreenSoftware
//
//  Created by Hidreen International on 8/13/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import "CustomEditField.h"


@implementation CustomEditField
@synthesize name;

- (id)initWithFrame:(CGRect)frame withId:(NSString *)idField andLabel:(NSString *)labeltext
{
	if(self = [super initWithFrame:frame])
	{
		self.name = idField;
		CGFloat labelHeight = (frame.size.height * 40 / 100) - 1;
		CGFloat textFieldHeight = (frame.size.height * 60 / 100) - 1;
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, frame.size.width - 20, labelHeight)];
		label.text = labeltext;
		label.font = [UIFont boldSystemFontOfSize:14.0];
		
		tf = [[UITextField alloc] initWithFrame:CGRectMake(10, labelHeight + 2, frame.size.width - 20, textFieldHeight)];
		tf.borderStyle = UITextBorderStyleRoundedRect;
		tf.autocorrectionType = UITextAutocorrectionTypeNo;
		tf.clearButtonMode = UITextFieldViewModeWhileEditing;
		tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		tf.font = [UIFont systemFontOfSize:14.0];
		tf.delegate = self;
		if ([idField rangeOfString:@"password"].location != NSNotFound) {
			tf.secureTextEntry = YES;
		}
		
		[self addSubview:label];
		[self addSubview:tf];
		[label release];
	}
	
	return self;
}

- (void)setText: (NSString *)text {
	tf.text = text;
}

- (NSString *)getValue {
	return tf.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void) dealloc {
	[tf release];
	[name release];
	[super dealloc];
}


@end
