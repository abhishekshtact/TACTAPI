//
//  TactSupport.h
//  TACTAPI
//
//  Created by admin on 09/09/16.
//  Copyright © 2016 TACT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <CommonCrypto/CommonDigest.h>
#import "UIView+Toast.h"
@protocol ApiDoneDelegate <NSObject>
@required
- (void) onDone:(int)statusCode andData:(NSData*) data andReqCode:(int) reqCode;
@end


@interface TactSupport : NSObject{
    id <ApiDoneDelegate> _delegate;


}
@property (nonatomic,strong) id delegate;
@property (nonatomic,strong) NSString* url;
@property (nonatomic,strong) NSString* data;
@property (nonatomic,strong) NSString* setHTTPMethod;
@property (nonatomic, strong) NSMutableData *myData;
@property (nonatomic, strong) id parameters;
@property  int reqCode;

-(id) initWithDelegate:(id) delegate url:(NSString *) url parameters:(id) parameters reqCode:(int) reqCode andsetHTTPMethod:(NSString *)setHTTPMethod;
-(void) execute;
-(void) executeWithUserToken;
-(void) executeWithArrayData;


+(NSString *) getCurrentDate;
+(UIColor*)colorWithHexString:(NSString*)hex;
+(NSString *) convertDateFormate:(NSString *) date;
+(NSString *) convertDateFormateWithTime:(NSString *) date;
+(void) showAlert:(NSString *)msg;
+(void) showAlertWithDelegate:(id)delegate Msg:(NSString *)msg Tag:(int)tag PositiveButton:(NSString *)pButton NegativeButton:(NSString *)nButton;
+(void) showErrorFromResult:(NSData *) data;
+(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
+(void) showAlertWithDelegate:(id)delegate Msg:(NSString *)msg Tag:(int)tag PositiveButton:(NSString *)pButton;
+(void) showAlertInternetErrorWithTag503AndDelegateSelf:(id)delegate;
+(NSString *)md5 :(NSString *)input;
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize;
+ (NSString *)base64String:(UIImage *)image;
+(BOOL) validatedUserInput:(NSString *)StringValue andFieldType:(int )fieldTypeIndex;
// For Email 1
// For Mobile 2
// For Name  3
// For DOB age not less then 18 : 4
// NSString *day = @"Wed";





@end


// //Set These 4 in AppDelegate
//NSDictionary *headers = @{ @"content-type": ContentTypeValue,
//                           @"auth-token": AuthTokenValue,
//                           @"user-token" :UserTokenValue
//                           };
//[[NSUserDefaults standardUserDefaults] setObject:headers forKey:@"headersValue"];
