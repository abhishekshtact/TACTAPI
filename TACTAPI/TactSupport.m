//
//  TactSupport.m
//  TACTAPI
//
//  Created by admin on 09/09/16.
//  Copyright © 2016 TACT. All rights reserved.
//

#import "TactSupport.h"

@implementation TactSupport


-(id)initWithDelegate:(id)deleg url:(NSString *)url parameters:(id)parameters reqCode:(int) reqCode andsetHTTPMethod:(NSString *)setHTTPMethod{
    self = [self init];
    self.delegate = deleg;
    self.url = url;
    self.parameters = parameters;
    self.reqCode = reqCode;
    self.setHTTPMethod =setHTTPMethod;
    return self;
}
-(void) execute{
    
    
    
    
    NSDictionary *headers; [[NSUserDefaults standardUserDefaults] objectForKey:@"headerValue"];

  
    
    
    NSData *postData;
    if([self.setHTTPMethod isEqualToString:@"POST"]){
    postData = [NSJSONSerialization dataWithJSONObject:self.parameters options:0 error:nil];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPMethod:self.setHTTPMethod];
    
    [request setHTTPBody:postData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                        if(self.delegate!=NULL){
                                                            [self.delegate onDone:0 andData:nil andReqCode:self.reqCode];
                                                        }
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                        if(self.delegate!=NULL){
                                                            int statusCode = (int)httpResponse.statusCode;
                                                            [self.delegate onDone:statusCode andData:data andReqCode:self.reqCode];
                                                        }
                                                    }
                                                }];
    [dataTask resume];
}

+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


+(NSString *) getCurrentDate{
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *stringDate = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"%@", stringDate);
    
    stringDate = [stringDate stringByReplacingOccurrencesOfString:@" "
                                                       withString:@"T"];
    stringDate = [NSString stringWithFormat:@"%@Z",stringDate];
    
    return stringDate;
}


+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize {
    CGSize actSize = image.size;
    float scale = actSize.width/actSize.height;
    
    if (scale < 1) {
        newSize.height = newSize.width/scale;
    } else {
        newSize.width = newSize.height*scale;
    }
    
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}



+(NSString *) convertDateFormate:(NSString *) date{
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"dd-MM-yyyy"]; // Date formater
    date = [dateformate stringFromDate:[NSDate date]]; // Convert date to string
    NSLog(@"date :%@",date);
    
    return date;
}
+(NSString *) convertDateFormateWithTime:(NSString *) dateString{
    NSString *str = dateString;
    NSArray *Array = [str componentsSeparatedByString:@"T"];
    dateString= [Array objectAtIndex:0];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSDate *dateFromString = [[NSDate alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-DD"];
    dateFromString = [dateFormatter dateFromString:dateString];
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *stringDate = [dateFormatter stringFromDate:dateFromString];
    NSLog(@"%@", stringDate);
    
    
    return stringDate;
}

+(void) showAlert:(NSString *)msg{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^
     {
         UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [alertView show];
     }];
}
+(void) showAlertInternetErrorWithTag503AndDelegateSelf:(id)delegate{
    //    [[NSOperationQueue mainQueue] addOperationWithBlock:^
    //     {
    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"" message:@"Please check Internet Connection./इंटरनेट कनेक्शन की जांच करें।" delegate:delegate cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alertView.tag = 503;
    [alertView show];
    //     }];
}

+(void) showAlertWithDelegate:(id)delegate Msg:(NSString *)msg Tag:(int)tag PositiveButton:(NSString *)pButton{
    
    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:delegate cancelButtonTitle:pButton otherButtonTitles:nil];
    alertView.tag=tag;
    [alertView show];
    
}

+(void) showAlertWithDelegate:(id)delegate Msg:(NSString *)msg Tag:(int)tag PositiveButton:(NSString *)pButton NegativeButton:(NSString *)nButton{
    
    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:delegate cancelButtonTitle:nButton otherButtonTitles:pButton, nil];
    alertView.tag=tag;
    [alertView show];
    
}

+(void) showErrorFromResult:(NSData *) data{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^
     {
         @try{
             NSMutableDictionary *object = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             if ([object objectForKey:@"Message" ] !=[NSNull null]) {
                 [TactSupport showAlert:object[@"Message"]];
             }else{
                 [TactSupport showAlert:@"Please check internet"];
             }
         }@catch(NSException *ex){
             [TactSupport showAlert:@"Please check internet"];
         }
     }];
}

+(NSString *)md5 :(NSString *)input{
    
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}

+ (NSString *)base64String:(UIImage *)image{
   
   NSString* base64String =[UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
   return base64String;

}
+(BOOL) validatedUserInput:(NSString *)StringValue andFieldType:(int )fieldTypeIndex{
    // For Email 1
    // For Mobile 2
    // For Name  3
    // For DOB age not less then 18 : 4
    // NSString *day = @"Wed";
    
    switch (fieldTypeIndex) {
        case 1:
            NSLog(@"Email Validation...");
            if(fieldTypeIndex ==1){
                
                BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
                NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
                NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
                NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
                NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
                return [emailTest evaluateWithObject:StringValue];
            }
            break;
            
        case 2:
            if(fieldTypeIndex ==2){
                
                
                NSLog(@"Mobile Validation...");
                
                NSString *phoneRegex = @"^((\\+)|(00))[0-9]{6,14}$";
                NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
                
                return [phoneTest evaluateWithObject:StringValue];
            }
            break;
            
        case 3:
            NSLog(@"Somthing else...");
            if(fieldTypeIndex == 3){
                
                NSString *emailRegex = @"[a-zA-z]+([ '-][a-zA-Z]+)*$";
                NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
                BOOL isValid = [emailTest evaluateWithObject:StringValue];
                return isValid;
            }
            break;
            
        case 4:
            NSLog(@"Somthing else...");
            break;
            
        default:
            break;
    }
    return false;
}

@end