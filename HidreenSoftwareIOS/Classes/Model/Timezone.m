//
//  Timezone.m
//  HidreenSoftware
//
//  Created by Hidreen International on 9/2/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import "Timezone.h"
#import "KeyValuePair.h"

@implementation Timezone

- (id) init {
	if (self == [super init]) {
		arrKeyValueTimezone = [[NSMutableArray alloc] init];
		NSArray *arrTimezone = [NSArray arrayWithObjects:@"(UTC-12:00) Enitwetok, Kwajalien",
								@"(UTC-11:00) Nome, Midway Island, Samoa",
								@"(UTC-10:00) Hawaii",
								@"(UTC-9:00) Alaska",
								@"(UTC-8:00) Pacific Time",
								@"(UTC-7:00) Mountain Time",
								@"(UTC-6:00) Central Time, Mexico City",
								@"(UTC-5:00) Eastern Time, Bogota, Lima, Quito",
								@"(UTC-4:00) Atlantic time, Caracas, La Paz",
								@"(UTC-3:30) Newfoundland",
								@"(UTC-3:00) Brazil, Buenos Aires, Geogetown, Faikland Is.",
								@"(UTC-2:00) Mid-Atlantic, Ascention Is., St Helena",
								@"(UTC-1:00) Azores, Cape Verde Islands",
								@"(UTC) Casablanca, Dublin, Edinburg, London, Lisbon, Monrovia",
								@"(UTC+1:00) Berlin, Brussels, Copenhagen, Madrid, Paris, Rome",
								@"(UTC+2:00) Kaliningrad, South Africa, Warsaw",
								@"(UTC+3:00) Baghdad, Riyadh, Moscow, Nairobi",
								@"(UTC+3:30) Tehran",
								@"(UTC+4:00) Abu Dhabi, Baku, Muscat, Tbilisi",
								@"(UTC+4:30) Kabul",
								@"(UTC+5:00) Islamabad, Karachi, Tashkent",
								@"(UTC+5:30) Bombay, Calcutta, Madras, New Delhi",
								@"(UTC+6:00) Almaty, Colomba, Dhaka",
								@"(UTC+7:00) Bangkok, Hanoi, Jakarta",
								@"(UTC+8:00) Beijing, Hong Kong, Perth, Singapore, Taipei",
								@"(UTC+9:00) Osaka, Sapporo, Seoul, Tokyo, Yakutsk",
								@"(UTC+9:30) Adelaide, Darwin",
								@"(UTC+10:00) Melbourne, Papua New Guinea, Sydney, Vladivostok",
								@"(UTC+11:00) Magadan, New Caledonia, Solomon Islands",
								@"(UTC+12:00) Auckland, Wellington, Fiji, Marshall Island",
								nil];
		NSArray *arrTimezoneKey = [NSArray arrayWithObjects:@"UM12",
								   @"UM11",
								   @"UM10",
								   @"UM9",
								   @"UM8",
								   @"UM7",
								   @"UM6",
								   @"UM5",
								   @"UM4",
								   @"UM25",
								   @"UM3",
								   @"UM2",
								   @"UM1",
								   @"UTC",
								   @"UP1",
								   @"UP2",
								   @"UP3",
								   @"UP25",
								   @"UP4",
								   @"UP35",
								   @"UP5",
								   @"UP45",
								   @"UP6",
								   @"UP7",
								   @"UP8",
								   @"UP9",
								   @"UP85",
								   @"UP10",
								   @"UP11",
								   @"UP12",
								   nil];
		
		for (int i = 0; i < 30; i++) {
			KeyValuePair *kvp = [[KeyValuePair alloc] init];
			kvp.key = [arrTimezoneKey objectAtIndex:i];
			kvp.value = [arrTimezone objectAtIndex:i];
			[arrKeyValueTimezone addObject:kvp];
			[kvp release];
		}
	}
	return self;
}

- (KeyValuePair *) getTimezoneAtIndex:(NSInteger)index {
	return [arrKeyValueTimezone objectAtIndex:index];
}

- (NSArray *) getAllTimezones {
	return arrKeyValueTimezone;
}

- (void)dealloc {
	[arrKeyValueTimezone release];
	[super dealloc];
}

@end
