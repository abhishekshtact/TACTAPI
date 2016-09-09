//
//  InterNetTesting.m
//  MavenfyPad
//
//  Created by APPLE on 15/12/15.
//  Copyright © 2015 TACT. All rights reserved.
//

#import "InterNetTesting.h"
@implementation InterNetTesting

- (void)loadViewDidLoad
{
    //    [super viewDidLoad];
    //    // Do any additional setup after loading the view, typically from a nib.
    //
    //    self.blockLabel.text = @"Not Fired Yet";
    //    self.notificationLabel.text = @"Not Fired Yet";
    //    self.localWifiblockLabel.text = @"Not Fired Yet";
    //    self.localWifinotificationLabel.text = @"Not Fired Yet";
    //    self.internetConnectionblockLabel.text = @"Not Fired Yet";
    //    self.internetConnectionnotificationLabel.text = @"Not Fired Yet";
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    
    // __weak __block typeof(self) weakself = self;
    
    //////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////
    //
    // create a Reachability object for www.google.com
    
    self.googleReach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    self.googleReach.reachableBlock = ^(Reachability * reachability)
    {
        NSString * temp = [NSString stringWithFormat:@"GOOGLE Block Says Reachable(%@)", reachability.currentReachabilityString];
        NSLog(@"Internet Testing%@", temp);
        
        
        
        
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"%@",temp);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            //  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:1 forKey:@"internetConnected"];
            [defaults synchronize];
            
            
            
            
            
        }];
    };
    
    self.googleReach.unreachableBlock = ^(Reachability * reachability)
    {
        NSString * temp = [NSString stringWithFormat:@"GOOGLE Block Says Unreachable(%@)", reachability.currentReachabilityString];
        NSLog(@"Internet Testing%@", temp);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",temp);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:0 forKey:@"internetConnected"];
            [defaults synchronize];
            
            // Abhishek's Code Internet connected
        });
    };
    
    [self.googleReach startNotifier];
    
    
    
    //////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////
    //
    // create a reachability for the local WiFi
    
    self.localWiFiReach = [Reachability reachabilityForLocalWiFi];
    
    // we ONLY want to be reachable on WIFI - cellular is NOT an acceptable connectivity
    self.localWiFiReach.reachableOnWWAN = NO;
    
    self.localWiFiReach.reachableBlock = ^(Reachability * reachability)
    {
        NSString * temp = [NSString stringWithFormat:@"LocalWIFI Block Says Reachable(%@)", reachability.currentReachabilityString];
        NSLog(@"Internet Testing%@", temp);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",temp);
        });
    };
    
    self.localWiFiReach.unreachableBlock = ^(Reachability * reachability)
    {
        NSString * temp = [NSString stringWithFormat:@"LocalWIFI Block Says Unreachable(%@)", reachability.currentReachabilityString];
        
        NSLog(@"Internet Testing%@", temp);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",temp);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:0 forKey:@"internetConnected"];
            [defaults synchronize];
            
            
        });
    };
    
    [self.localWiFiReach startNotifier];
    
    
    
    //////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////
    //
    // create a Reachability object for the internet
    
    self.internetConnectionReach = [Reachability reachabilityForInternetConnection];
    
    self.internetConnectionReach.reachableBlock = ^(Reachability * reachability)
    {
        NSString * temp = [NSString stringWithFormat:@" InternetConnection Says Reachable(%@)", reachability.currentReachabilityString];
        NSLog(@"Internet Testing%@", temp);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",temp);
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            int internetCheckConnectionStatus = [defaults integerForKey:@"internetConnected"];
            if(internetCheckConnectionStatus !=1){
                [defaults setInteger:1 forKey:@"internetConnected"]; // Abhishek's Code for breaking internet
                [self getDataFromDBwithoutimage];
                [defaults synchronize];
            }
        });
    };
    
    self.internetConnectionReach.unreachableBlock = ^(Reachability * reachability)
    {
        NSString * temp = [NSString stringWithFormat:@"InternetConnection Block Says Unreachable(%@)", reachability.currentReachabilityString];
        
        NSLog(@"Internet Testing%@", temp);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",temp);
        });
    };
    
    [self.internetConnectionReach startNotifier];
    
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if(reach == self.googleReach)
    {
        if([reach isReachable])
        {
            NSString * temp = [NSString stringWithFormat:@"GOOGLE Notification Says Reachable(%@)", reach.currentReachabilityString];
            NSLog(@"Internet Testing%@", temp);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:1 forKey:@"internetConnected"];
            [defaults synchronize];
            
            
        }
        else
        {
            NSString * temp = [NSString stringWithFormat:@"GOOGLE Notification Says Unreachable(%@)", reach.currentReachabilityString];
            NSLog(@"Internet Testing%@", temp);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:0 forKey:@"internetConnected"];
            [defaults synchronize];
            
            NSLog(@"%@",temp);
        }
    }
    else if (reach == self.localWiFiReach)
    {
        if([reach isReachable])
        {
            NSString * temp = [NSString stringWithFormat:@"LocalWIFI Notification Says Reachable(%@)", reach.currentReachabilityString];
            NSLog(@"Internet Testing%@", temp);
            
            NSLog(@"%@",temp);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:0 forKey:@"internetConnected"];
            [defaults synchronize];
        }
        else
        {
            NSString * temp = [NSString stringWithFormat:@"LocalWIFI Notification Says Unreachable(%@)", reach.currentReachabilityString];
            NSLog(@"Internet Testing%@", temp);    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:0 forKey:@"internetConnected"];
            [defaults synchronize];
            NSLog(@"%@",temp);
        }
    }
    else if (reach == self.internetConnectionReach)
    {
        if([reach isReachable])
        {
            NSString * temp = [NSString stringWithFormat:@"InternetConnection Notification Says Reachable(%@)", reach.currentReachabilityString];
            NSLog(@"Internet Testing%@", temp);
            
            NSLog(@"%@",temp);
        }
        else
        {
            NSString * temp = [NSString stringWithFormat:@"InternetConnection Notification Says Unreachable(%@)", reach.currentReachabilityString];
            NSLog(@"Internet Testing%@", temp);
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:0 forKey:@"internetConnected"];
            [defaults synchronize];
            NSLog(@"%@",temp);
        }
    }
    
}

-(void)getDataFromDBwithoutimage{

//    Abhishek
    
    REQUEST_SYNC_WITHOUTIMAGE =4;
//    REQUEST_SYNC_WITHIMAGE = 5;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int internetConnected = [defaults integerForKey:@"internetConnected"];
    if(internetConnected != 0){
        
        NSArray *listOFData = [[DBManager getSharedInstance] getAllPlacesForSyncWithoutImage];
        NSLog(@"%@",listOFData);
        if(listOFData.count!=0){
            
            
            
            
            
            NSDictionary *parameters = @{ @"arrayListOfPlaces": listOFData};
            
            
            [[[AccessApi alloc] initWithDelegate:self url:[NSString stringWithFormat:@"http://up100.azurewebsites.net/api/user/SyncData"] parameters:parameters reqCode:REQUEST_SYNC_WITHOUTIMAGE] executeWithArrayData];
            
            
            
            
        }else{
            AddSurvayViewController *addSVC = [[AddSurvayViewController alloc] init];
            [addSVC getDataFromDBwithimage];
            // Abhishek Sharma
        }
        
    }
    
}




-(void)getDataFromDBwithimage{
    
    REQUEST_SYNC_WITHOUTIMAGE =4;
//    REQUEST_SYNC_WITHIMAGE = 5;
//    REQUEST_SYNC_IMAGE=1;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int internetConnected = [defaults integerForKey:@"internetConnected"];
    if(internetConnected != 0){
        
        NSArray *listOFData = [[DBManager getSharedInstance] getAllPlacesForSyncWithImage];
        NSLog(@"%@",listOFData);
        if(listOFData.count!=0){
            
            
            //            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
            //            NSString *documentsDirectory = [paths objectAtIndex:0];
            //            NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
            //            UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
            
            
            NSDictionary *parameters = @{ @"arrayListOfPlaces": listOFData};
            
            
            [[[AccessApi alloc] initWithDelegate:self url:[NSString stringWithFormat:@"http://up100.azurewebsites.net/api/user/SyncData"] parameters:parameters reqCode:REQUEST_SYNC_WITHOUTIMAGE] executeWithArrayData];
            
            
            
            
        }
        
    }
    
}





// Protocol Delegate of AccessAPI
-(void) onDone:(int)statusCode andData:(NSData *)data andReqCode:(int)reqCode{
    
    
    if (data == nil)
    {
        
        NSLog(@"Unable To Update");
        //        if(isResponseNil){
        //
        //            [Support showAlert:NSLocalizedString(@"Please check Internet Connection.", nil)];
        //            isResponseNil =false;
        //            //connection unavailable
        //
        //        }
        
    }else
    {
        
        switch (reqCode) {
                
            case 4://REQUEST_SYNC_WITHOUTIMAGE
                
                Sync_Dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                NSLog(@"%@",Sync_Dict);
                if(reqCode==4){
                    
                    if ([Sync_Dict[@"Status"] intValue] == 200) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^
                         {
                             //                        [self hideLoadingMode];
                             
                             
                             if([Sync_Dict[@"data"] count]!=0){
                                 // Abhishek
                                 
                                 NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
                                 
                                 bool isErrorInInsertion=false;
//                                 NSArray *Sync_idList = [userdefault objectForKey:@"Sync_id"];
                                 for (int i=0;i< [Sync_Dict[@"data"] count]; i++) {
//                                     NSLog(@"%d = ID  - %d",i,[Sync_idList[i] intValue]);
                                     
                                     
                                     
                                     BOOL success = [[DBManager getSharedInstance] updatePlacesSyncedStatus:[Sync_Dict[@"data"][i][@"Id"] intValue] andGuId:Sync_Dict[@"data"][i][@"GuId"]];
                                     //
                                     if(success==YES){
                                         NSLog(@"Updated Sucessfully");
                                         NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                                         [userDefault setObject:[Support getCurrentDate] forKey:@"LastSynced"];
                                     }else{
                                         isErrorInInsertion=true;
                                         break;
                                     }
                                 }
                                 if(isErrorInInsertion){
                                     //                                     [Support showAlert:@"Some error in insertion, try again"];
                                     //                                     [self hideLoadingMode];
                                     NSLog(@"Unable to Update Sucessfully");
                                 }
                                 
                                 
                             }else{
                                 //                                 [Support showAlert:@"Please check Internet Connection."];
                                 NSLog(@"Unable to Update Sucessfully");
                             }
                             
                             
                         }];
                        
                    }
                }
                break;
                
        }
    }
}



@end
