//
//  DataStorer.m
//  HidreenSoftware
//
//  Created by Hidreen International on 8/10/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import "DataStorer.h"

static NSUserDefaults *pref;
static DataStorer *instance;

@implementation DataStorer

+ (DataStorer *)GetInstance {
	@synchronized(self) {
		if (!instance) {
			instance = [[DataStorer alloc] init];
			pref = [NSUserDefaults standardUserDefaults];
		}
		return instance;
	}
}

- (NSString *)getEmail {
	return [pref stringForKey:@"email"];
}

- (NSString *)getName {
	return [pref stringForKey:@"name"];
}
- (NSString *)getCountry {
	return [pref stringForKey:@"country"];
}

- (NSString *)getSessionId {
	return [pref stringForKey:@"session_id"];
}

- (BOOL) isTokenRegistered {
    NSString *str = [pref stringForKey:@"tokenregistered"];
    return [str isEqualToString:@"YES"];
}

- (NSString *)getPushToken {
    return [pref stringForKey:@"pushtoken"];
}

- (void)setPushToken:(NSString *)token {
    [pref setObject:token forKey:@"pushtoken"];
}

- (void)setTokenRegistered:(BOOL) registered {
    if (registered) {
        [pref setObject:@"YES" forKey:@"tokenregistered"];
    } else {
        [pref setObject:@"NO" forKey:@"tokenregistered"];
    }
}

- (void)setEmailWithEmail:(NSString *)email {
	[pref setObject:email forKey:@"email"];
}

- (void)setNameWithName:(NSString *)name {
	[pref setObject:name forKey:@"name"];
}

- (void)setCountryWithCountry:(NSString *)country {
	[pref setObject:country forKey:@"country"];
}

- (void)setSessionIdWithSession:(NSString *)session {
	[pref setObject:session forKey:@"session_id"];
}

- (BOOL) isLoggedIn {
	NSString *sessid = [NSString stringWithFormat:@"%@", [pref stringForKey:@"session_id"]];
	NSLog(@"session: %@", sessid);
	return ([sessid isEqualToString:@"(null)"] == NO);
}

- (void) unRegister {
	[pref setObject:nil forKey:@"email"];
	[pref setObject:nil forKey:@"name"];
	[pref setObject:nil forKey:@"country"];
	[self logout];
}

- (void) logout {
	[pref setObject:nil forKey:@"session_id"];
    [self setTokenRegistered:NO];
}

@end
