//
//  CoustomView.m
//  buyer
//
//  Created by Jonson on 2020/1/14.
//  Copyright © 2020 Jonson
//

#import "CoustomView.h"
#import "SignWithAppleHelper.h"
#import "SignHandleKeyChain.h"
//在Keychain中的标识，这里取bundleIdentifier + UUID / OpenUDID
#define KEYCHAIN_IDENTIFIER(a) ([NSString stringWithFormat:@"%@_%@",[[NSBundle mainBundle] bundleIdentifier],a])
static SignWithAppleHelper  *_instance;
static dispatch_once_t onceToken;

API_AVAILABLE(ios(13.0))
typedef void(^Success)(ASAuthorization *authorization,NSString *user);
typedef void (^Failure)(NSError *err);
API_AVAILABLE(ios(13.0))
@interface CoustomView()<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>
@property(nonatomic,strong)Success success;
@property(nonatomic,strong)Failure failure;
@end

@implementation CoustomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
  self = [super initWithFrame:frame];
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAuthorizationAppleIDButtonPress)];
  [self addGestureRecognizer:tap];
  
  return self;
}

- (void)setImageUrl:(NSString *)imageUrl{
  
}


- (void)handleAuthorizationAppleIDButtonPress{
    if (@available(iOS 13.0, *)) {
        // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        // 创建新的AppleID 授权请求
        ASAuthorizationAppleIDRequest *appleIDRequest = [appleIDProvider createRequest];
        // 在用户授权期间请求的联系信息
        appleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        
        //需要考虑已经登录过的用户，可以直接使用keychain密码来进行登录
        ASAuthorizationPasswordProvider *appleIDPasswordProvider = [ASAuthorizationPasswordProvider new];
        ASAuthorizationPasswordRequest *passwordRequest = appleIDPasswordProvider.createRequest;
        
        // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[appleIDRequest]];
        // 设置授权控制器通知授权请求的成功与失败的代理
        authorizationController.delegate = self;
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        authorizationController.presentationContextProvider = self;
        // 在控制器初始化期间启动授权流
        [authorizationController performRequests];
    }
}

#pragma mark - delegate
//@optional 授权成功地回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization{
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        // 用户登录使用ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *credential = authorization.credential;
        NSString *user = credential.user;
//        NSString *familyName = appleIDCredential.fullName.familyName;
//        NSString *givenName = appleIDCredential.fullName.givenName;
//        NSString *email = appleIDCredential.email;
      NSString *state = credential.state;
             NSString *userID = credential.user;
             NSPersonNameComponents *fullName = credential.fullName;
             NSString *email = credential.email;
             NSString *authorizationCode = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding]; // refresh token
             NSString *identityToken = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding]; // access token
             ASUserDetectionStatus realUserStatus = credential.realUserStatus;
        NSLog(@"state: %@", state);
              NSLog(@"userID: %@", userID);
              NSLog(@"fullName: %@", fullName);
              NSLog(@"email: %@", email);
              NSLog(@"authorizationCode: %@", authorizationCode);
              NSLog(@"identityToken: %@", identityToken);
              NSLog(@"realUserStatus: %@", @(realUserStatus));
      //用于后台像苹果服务器验证身份信息
//      NSData *identityToken = apple.identityToken;
//        NSData *identityToken = appleIDCredential.identityToken;
//        NSData *authorizationCode = appleIDCredential.authorizationCode;
        // Create an account in your system.
        // For the purpose of this demo app, store the userIdentifier in the keychain.
        //  需要使用钥匙串的方式保存用户的唯一信息
        [SignHandleKeyChain save:KEYCHAIN_IDENTIFIER(@"SignInWithApple") data:user];
        
//        self.success(authorization, user);
      self.onClick(@{@"success":userID,@"error":@""});
    }else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]){
        // Sign in using an existing iCloud Keychain credential.
        // 用户登录使用现有的密码凭证
        ASPasswordCredential *passwordCredential = authorization.credential;
        // 密码凭证对象的用户标识 用户的唯一标识
        NSString *user = passwordCredential.user;
        // 密码凭证对象的密码
        NSString *password = passwordCredential.password;
        self.onClick(@{@"success":user,@"error":@""});
    }else{
        NSLog(@"授权信息均不符");
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"授权信息均不符"};
        NSError* error = [[NSError alloc]  initWithDomain:@"error" code:105 userInfo:userInfo];
//        self.failure(error);
      self.onClick(@{@"success":@"",@"error":error});
    }
}

// 授权失败的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)){
    // Handle error.
    NSLog(@"Handle error：%@", error);
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
            
        default:
            break;
    }
//    self.failure(error);
  self.onClick(@{@"success":@"",@"error":errorMsg});
}

// 告诉代理应该在哪个window 展示内容给用户
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)){
    NSLog(@"88888888888");
    // 返回window
  if (@available(iOS 13.0, *)) {
    for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes){
      if (windowScene.activationState == UISceneActivationStateForegroundActive)
      {
        UIWindow *window = windowScene.windows.firstObject;
        return window;
      }
    }
  } else {
    // Fallback on earlier versions
  }
    return nil;
}



@end
