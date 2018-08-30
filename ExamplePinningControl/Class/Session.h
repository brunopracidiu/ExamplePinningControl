//
//  Session.h
//  ExamplePinningControl
//
//  Created by Bruno Ferreira De Oliveira on 30/8/18.
//  Copyright © 2018 Bruno Ferreira De Oliveira. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY @"gntec727-fc96-483f-913d-ffbdc76f72f3"

@interface Session : NSObject

@property (nonatomic, strong) NSArray *ListKeysCertificateHTTPSServer;

-(id)initWithDictionary:(NSDictionary*) dict;
+(Session*)getSession;
+(void)setSession:(id)value;

@end
