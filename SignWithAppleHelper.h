//
//  SignWithAppleHelper.h
//  lky4CustIntegClient
//
//  Created by Kevin on 2020/1/14.
//  Copyright © 2019 Jonson
//

#import <Foundation/Foundation.h>
#import <AuthenticationServices/AuthenticationServices.h>
NS_ASSUME_NONNULL_BEGIN

@interface SignWithAppleHelper : NSObject
+ (SignWithAppleHelper *)defaultSignInWithAppleModel;
+ (void)attempDealloc;
+ (void)signInWithAppleWithButtonRect:(CGRect)rect
        withSupView:(UIView *)superView                    withType:(ASAuthorizationAppleIDButtonType)type withStyle:(ASAuthorizationAppleIDButtonStyle)style success:(void(^)(ASAuthorization *authorization,NSString *user))success
    failure:(void (^)(NSError *err))failure;
+ (void)signInWithAppleWithButtonRect:(CGRect)rect
                  withType:(ASAuthorizationAppleIDButtonType)type withStyle:(ASAuthorizationAppleIDButtonStyle)style success:(void(^)(ASAuthorization *authorization,NSString *user))success
failure:(void (^)(NSError *err))failure;
@end

NS_ASSUME_NONNULL_END
