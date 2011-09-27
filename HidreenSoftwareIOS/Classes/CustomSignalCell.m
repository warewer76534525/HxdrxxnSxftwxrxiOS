//
//  CustomSignalCell.m
//  HidreenSoftware
//
//  Created by Hidreen International on 8/3/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import "CustomSignalCell.h"


@implementation CustomSignalCell
@synthesize lblSymbol, lblProbability, imgDirection, lblDirection, imgNew;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	[lblDirection release];
	[lblSymbol release];
	[lblProbability release];
	[imgDirection release];
    [super dealloc];
}


@end
