//
//  RGViewController.m
//  RGFlipMenu
//
//  Created by RolandG on 30/11/2013.
//  Copyright (c) 2013 mapps. All rights reserved.
//

#import "RGViewController.h"
#import "RGFlipMenuView.h"
#import "RGFlipMenu.h"
#import <FrameAccessor.h>


@interface RGViewController ()
@property (nonatomic, strong) RGFlipMenuView *menu;
@end

@implementation RGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RGFlipMenu *flipMenu = [[RGFlipMenu alloc] initWithText:@"Main Menu" actionBlock:^{
        NSLog(@"selected main menu");
    } subMenus:@[
                 [[RGFlipMenu alloc] initWithText:@"Sub Menu 1" actionBlock:^{
        NSLog(@"selected sub menu 1");
                }],
                 [[RGFlipMenu alloc] initWithText:@"Sub Menu 2" actionBlock:^{
        NSLog(@"selected sub menu 2");
    }],
                 [[RGFlipMenu alloc] initWithText:@"Sub Menu 3" actionBlock:^{
        NSLog(@"selected sub menu 3");
    }],
                 ]];
    
//    RGFlipMenuView *subMenuWithChangingText = [RGFlipMenuView subMenuWithText:@"Sub Menu 3" actionBlock:^{ NSLog(@"selected sub menu 3"); }];
    
#define kRGFMInset 0

    self.menu = [[RGFlipMenuView alloc] initWithFrame:CGRectMake(kRGFMInset, kRGFMInset, self.view.width-2*kRGFMInset, self.view.height-2*kRGFMInset)
                                            mainMenus:@[flipMenu]];

    self.menu.center = self.view.middlePoint;
    [self.view addSubview:self.menu];
    
    UITapGestureRecognizer *tapOutsideMenu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOutsideMenu:)];
    [self.view addGestureRecognizer:tapOutsideMenu];
    
    // after delay, change the text of one submenu
//    double delayInSeconds = 3.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [subMenuWithChangingText changeText:@"Tap me!"];
//    });
}


- (void)didTapOutsideMenu:(UITapGestureRecognizer *)tap {
    NSAssert([tap isKindOfClass:[UITapGestureRecognizer class]], @"inconsistent - another gesture recognizer?");
    
#warning need to verify here that no menu animation is in progress
    [self.menu popToRoot];
}

@end
