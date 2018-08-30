//
//  ServiceBase.h
//  ExamplePinningControl
//
//  Created by Bruno Ferreira De Oliveira on 19/6/18.
//  Copyright © 2018 Bruno Ferreira De Oliveira. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HandlerResult)(BOOL,id);

@interface ServiceBase : NSObject <NSURLConnectionDelegate>

-(void)execute:(NSString*)serviceURL parameters:(NSDictionary*)parameters result:(HandlerResult)result;

@end
