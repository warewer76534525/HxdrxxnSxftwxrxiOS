//
//  DataStorer.h
//  HidreenSoftware
//
//  Created by Hidreen International on 8/10/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataStorer : NSObject {
}

+ (DataStorer *)GetInstance;
- (NSString *)getEmail;
- (NSString *)getSessionId;
- (NSString *)getName;
- (NSString *)getCountry;
- (NSString *)getPushToken;
- (BOOL) isTokenRegistered;
- (void)setTokenRegistered:(BOOL) registered;
- (void)setPushToken:(NSString *)token;
- (void)setNameWithName:(NSString *)name;
- (void)setCountryWithCountry:(NSString *)country;
- (void)setEmailWithEmail:(NSString *)email;
- (void)setSessionIdWithSession:(NSString *)session;
- (BOOL) isLoggedIn;
- (void) unRegister;
- (void) logout;

@end
