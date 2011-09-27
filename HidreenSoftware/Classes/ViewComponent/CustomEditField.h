//
//  CustomEditField.h
//  HidreenSoftware
//
//  Created by Hidreen International on 8/13/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomEditField : UIView <UITextFieldDelegate>{
	NSString *name;
	UITextField *tf;
}

@property (nonatomic, retain) NSString *name;

- (id)initWithFrame:(CGRect)frame withId:(NSString *)idField andLabel:(NSString *)labeltext;
- (NSString *)getValue;
- (void)setText: (NSString *)text;
	
@end
