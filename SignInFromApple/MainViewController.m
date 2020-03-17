//
//  MainViewController.m
//  SignInFromApple
//
//  Created by grx on 2020/3/17.
//  Copyright © 2020 ruixiao. All rights reserved.
//

#import "MainViewController.h"
#import <AuthenticationServices/AuthenticationServices.h>

@interface MainViewController ()<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>
@property (nonatomic, copy) NSString *userID;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    ASAuthorizationAppleIDButton *appleIDBtn = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeSignIn style:ASAuthorizationAppleIDButtonStyleWhiteOutline];
    appleIDBtn.frame = CGRectMake(50, 150, 200, 50);
    [appleIDBtn addTarget:self action:@selector(userAppIDLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:appleIDBtn];
}
- (void)userAppIDLogin:(ASAuthorizationAppleIDButton *)button {
    //基于用户的Apple ID授权用户，生成用户授权请求的一种机制
    ASAuthorizationAppleIDProvider *appleIdProvider = [[ASAuthorizationAppleIDProvider alloc] init];
    [appleIdProvider getCredentialStateForUserID:self.userID completion:^(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError * _Nullable error) {
        
    }];
    //创建新的Appid授权请求
    ASAuthorizationAppleIDRequest *request = appleIdProvider.createRequest;
    request.requestedScopes = @[ASAuthorizationScopeEmail,ASAuthorizationScopeFullName];
    ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];;
    //设置授权从之气通知授权请的成功和失败代理
    controller.delegate = self;
    //设置提供展示上下文的代理，系统可以展示授权界面给用户
    controller.presentationContextProvider = self;
    //启动
    [controller performRequests];
}
#pragma mark - ASAuthorizationControllerDelegate
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization {
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        ASAuthorizationAppleIDCredential *credential = authorization.credential;
        NSString *user = credential.user;
        NSPersonNameComponents *fullName = credential.fullName;
        NSString *email = credential.email;
        NSData *identityToken = credential.identityToken;
        NSString *token = [[NSString alloc] initWithData:identityToken encoding:NSUTF8StringEncoding];
        //授权成功后，你可以拿到苹果返回的全部数据，根据需要和后台交互
        self.userID = user;
        NSLog(@"user - %@ %@",user, token);
    }else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        ASPasswordCredential *psdCredential = authorization.credential;
        NSString *user = psdCredential.user;
        NSString *psd = psdCredential.password;
        NSLog(@"psduser - %@ %@",psd,user);
    }else{
        NSLog(@"授权信息不符");
    }
}
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error {
    NSLog(@"错误信息：%@",error);
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"取消授权";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权失败未知";
            break;
        default:
            break;
    }
    NSLog(@"%@",errorMsg);
}

@end
