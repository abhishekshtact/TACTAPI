//
//  InterNetTesting.h
//  MavenfyPad
//
//  Created by APPLE on 15/12/15.
//  Copyright © 2015 TACT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccessApi.h"
#import "DBManager.h"
#import "Support.h"
#import "Reachability.h"
#import <Foundation/Foundation.h>
#import "AddSurvayViewController.h"
@interface InterNetTesting : NSObject
{ NSDictionary *Sync_Dict;
    
    int REQUEST_SYNC_WITHOUTIMAGE;
}


-(void)reachabilityChanged:(NSNotification*)note;
- (void)loadViewDidLoad;
-(void)getDataFromDBwithoutimage;
//- (void)loadViewDidLoad;
-(void)getDataFromDBwithimage;

@property(strong) Reachability * googleReach;
@property(strong) Reachability * localWiFiReach;
@property(strong) Reachability * internetConnectionReach;

@end
