//
//  CustomNewsCell.h
//  HidreenSoftware
//
//  Created by Hidreen International on 8/9/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomNewsCell : UITableViewCell {
	IBOutlet UILabel *lblNewsTitle;
	IBOutlet UILabel *lblNewsTime;
}

@property (nonatomic, retain) IBOutlet UILabel *lblNewsTitle;
@property (nonatomic, retain) IBOutlet UILabel *lblNewsTime;

@end
