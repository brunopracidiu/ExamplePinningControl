//
//  ViewController.m
//  ExamplePinningControl
//
//  Created by Bruno Ferreira De Oliveira on 30/8/18.
//  Copyright © 2018 Bruno Ferreira De Oliveira. All rights reserved.
//

#import "ViewController.h"
#import "ServiceBase.h"
#import "Session.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)FirstStep:(id)sender {
    [[[ServiceBase alloc] init] execute:@"https://api.hitbtc.com/api/2/public/ticker" parameters:nil result:^(BOOL sucesso, id result){
        if (sucesso) {
            [Session setSession:[[Session alloc] initWithDictionary:@{@"KEYCERTIFICATESERVER" : @"Mp01DT29cODNDpNxPkKksKdKiqfruN8DsX3FUfMDwZE=" }]];
        }
    }];
}

- (IBAction)SecondStep:(id)sender {
    [[[ServiceBase alloc] init] execute:@"https://api.hitbtc.com/api/2/public/ticker" parameters:nil result:^(BOOL sucesso, id result){
        if (sucesso) {
            NSLog(@"Certificates Ok");
        }else{
            NSLog(@"Certificates diferentes");
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
