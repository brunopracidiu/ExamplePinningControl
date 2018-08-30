//
//  Keychain.h
//  ExamplePinningControl
//
//  Created by Bruno Ferreira De Oliveira on 19/6/18.
//  Copyright © 2018 Bruno Ferreira De Oliveira. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Keychain : NSObject

/**
 @abstract Saves a given value to the Keychain
 @param value The value to store.
 @param key The key identifying the value you want to save.
 @return YES if saved successfully, NO otherwise.
 */
+ (BOOL)saveValue:(id)value forKey:(NSString*)key;

/**
 @abstract Deletes a given value from the Keychain
 @param key The key identifying the value you want to delete.
 @return YES if deletion was successful, NO if the value was not found or some other error ocurred.
 */
+ (BOOL)deleteValueForKey:(NSString *)key;

/**
 @abstract Loads a given value from the Keychain
 @param key The key identifying the value you want to load.
 @return The value identified by key or nil if it doesn't exist.
 */
+ (id)loadValueForKey:(NSString*)key;

@end
