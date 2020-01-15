//
//  SignHandleKeyChain.h
//  lky4CustIntegClient
//
//  Created by Kevin on 2020/1/14.
//  Copyright © 2019 Jonson
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignHandleKeyChain : NSObject
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;
@end

NS_ASSUME_NONNULL_END
