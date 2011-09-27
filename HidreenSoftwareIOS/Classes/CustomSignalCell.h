//
//  CustomSignalCell.h
//  HidreenSoftware
//
//  Created by Hidreen International on 8/3/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomSignalCell : UITableViewCell {
	IBOutlet UILabel *lblSymbol;
	IBOutlet UILabel *lblDirection;
	IBOutlet UILabel *lblProbability;
	IBOutlet UIImageView *imgDirection;
    IBOutlet UIImageView *imgNew;
}

@property (nonatomic, retain) IBOutlet UILabel *lblSymbol;
@property (nonatomic, retain) IBOutlet UILabel *lblDirection;
@property (nonatomic, retain) IBOutlet UILabel *lblProbability;
@property (nonatomic, retain) IBOutlet UIImageView *imgDirection;
@property (nonatomic, retain) IBOutlet UIImageView *imgNew;

@end
