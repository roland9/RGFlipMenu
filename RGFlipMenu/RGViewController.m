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

@implementation RGViewController {
    NSUInteger selectedSubMenu1Index;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RGFlipMenu *subMenu1_1 = [[RGFlipMenu alloc] initWithText:@"Sub Menu 1" actionBlock:^(RGFlipMenu *parentMenu) {
        NSLog(@"selected sub menu 1");
        parentMenu.selectedSubMenuIndex = 0;
    }];
    RGFlipMenu *subMenu1_2 = [[RGFlipMenu alloc] initWithText:@"Old Sub Menu 2" actionBlock:^(RGFlipMenu *parentMenu) {
        NSLog(@"selected sub menu 2");
        parentMenu.selectedSubMenuIndex = 1;
    }];
    
    RGFlipMenu *flipMenu1 = [[RGFlipMenu alloc] initWithText:@"Main Menu 1" actionBlock:^(id me) {
        NSLog(@"selected main menu");
    } subMenus:@[
                 subMenu1_1,
                 subMenu1_2,
                 ]];
    // pre-select the second submenu item
    flipMenu1.selectedSubMenuIndex = 1;
    
    // after delay, change the text of one submenu
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [subMenu1_2 changeMenuText:@"Tap me!"];
    });

    RGFlipMenu *flipMenu2 = [[RGFlipMenu alloc] initWithText:@"Main Menu 2" actionBlock:^(id me) {
        NSLog(@"selected main menu");
    } subMenus:@[
                 [[RGFlipMenu alloc] initWithText:@"Sub Menu 1" actionBlock:^(RGFlipMenu *parentMenu) {
        NSLog(@"selected sub menu 1");
        parentMenu.selectedSubMenuIndex = 0;
    }],
                 [[RGFlipMenu alloc] initWithText:@"Sub Menu 2" actionBlock:^(RGFlipMenu *parentMenu) {
        NSLog(@"selected sub menu 2");
        parentMenu.selectedSubMenuIndex = 1;
    }],
                 [[RGFlipMenu alloc] initWithText:@"Sub Menu 3" actionBlock:^(RGFlipMenu *parentMenu) {
        NSLog(@"selected sub menu 3");
        parentMenu.selectedSubMenuIndex = 2;
    }],
                 ]];

    RGFlipMenu *flipMenu3 = [[RGFlipMenu alloc] initWithText:@"Main Menu 3" actionBlock:^(id me) {
        NSLog(@"selected main menu");
    } subMenus:@[
                 [[RGFlipMenu alloc] initWithText:@"Sub Menu 1" actionBlock:^(RGFlipMenu *parentMenu) {
        NSLog(@"selected sub menu 1");
    }],
                 [[RGFlipMenu alloc] initWithText:@"Sub Menu 2" actionBlock:^(RGFlipMenu *parentMenu) {
        NSLog(@"selected sub menu 2");
    }],
                 [[RGFlipMenu alloc] initWithText:@"Sub Menu 3" actionBlock:^(RGFlipMenu *parentMenu) {
        NSLog(@"selected sub menu 3");
    }],
                 [[RGFlipMenu alloc] initWithText:@"Sub Menu 4" actionBlock:^(RGFlipMenu *parentMenu) {
        NSLog(@"selected sub menu 4");
    }],
                 ]];

    RGFlipMenu *flipMenu4 = [[RGFlipMenu alloc] initWithText:@"Main Menu 4" actionBlock:^(id me) {
        NSLog(@"selected main menu");
    } subMenus:@[
                 [[RGFlipMenu alloc] initWithText:@"Sub Menu 1" actionBlock:^(RGFlipMenu *parentMenu) {
        NSLog(@"selected sub menu 1");
    }],
                 [[RGFlipMenu alloc] initWithText:@"Sub Menu 2" actionBlock:^(RGFlipMenu *parentMenu) {
        NSLog(@"selected sub menu 2");
    }],
                 [[RGFlipMenu alloc] initWithText:@"Sub Menu 3" actionBlock:^(RGFlipMenu *parentMenu) {
        NSLog(@"selected sub menu 3");
    }],
                 [[RGFlipMenu alloc] initWithText:@"Sub Menu 4" actionBlock:^(RGFlipMenu *parentMenu) {
        NSLog(@"selected sub menu 4");
    }],
                 [[RGFlipMenu alloc] initWithText:@"Sub Menu 5" actionBlock:^(RGFlipMenu *parentMenu) {
        NSLog(@"selected sub menu 5");
    }],
                 [[RGFlipMenu alloc] initWithText:@"Sub Menu 6" actionBlock:^(RGFlipMenu *parentMenu) {
        NSLog(@"selected sub menu 6");
    }],
                 [[RGFlipMenu alloc] initWithText:@"Sub Menu 7" actionBlock:^(RGFlipMenu *parentMenu) {
        NSLog(@"selected sub menu 7");
    }],
                 ]];
    
    RGFlipMenu *flipMenu5 = [[RGFlipMenu alloc] initWithText:@"Main Menu 5" actionBlock:^(id me) {
        NSLog(@"selected main menu");
    } subMenus:@[
                 [[RGFlipMenu alloc] initWithText:@"Sub Menu 1" actionBlock:^(RGFlipMenu *parentMenu) {
        NSLog(@"selected sub menu 1");
    }],
                 [[RGFlipMenu alloc] initWithText:@"Sub Menu 2" actionBlock:^(RGFlipMenu *parentMenu) {
        NSLog(@"selected sub menu 2");
    }],
                 [[RGFlipMenu alloc] initWithText:@"Sub Menu 3" actionBlock:^(RGFlipMenu *parentMenu) {
        NSLog(@"selected sub menu 3");
    }],
                 [[RGFlipMenu alloc] initWithText:@"Sub Menu 4" actionBlock:^(RGFlipMenu *parentMenu) {
        NSLog(@"selected sub menu 4");
    }],
                 [[RGFlipMenu alloc] initWithText:@"Sub Menu 5" actionBlock:^(RGFlipMenu *parentMenu) {
        NSLog(@"selected sub menu 5");
    }],
                 [[RGFlipMenu alloc] initWithText:@"Sub Menu 6" actionBlock:^(RGFlipMenu *parentMenu) {
        NSLog(@"selected sub menu 6");
    }],
                 [[RGFlipMenu alloc] initWithText:@"Sub Menu 7" actionBlock:^(RGFlipMenu *parentMenu) {
        NSLog(@"selected sub menu 7");
    }],
                 [[RGFlipMenu alloc] initWithText:@"Sub Menu 8" actionBlock:^(RGFlipMenu *parentMenu) {
        NSLog(@"selected sub menu 8");
    }],
                 ]];

#define kRGFMInset 0

    self.menu = [[RGFlipMenuView alloc] initWithFrame:CGRectMake(kRGFMInset, kRGFMInset, self.view.width-2*kRGFMInset, self.view.height-2*kRGFMInset)
                                            mainMenus:@[flipMenu1, flipMenu2,
                                                        flipMenu3, flipMenu4, flipMenu5
                                                        ]];

    self.menu.center = self.view.middlePoint;
    [self.view addSubview:self.menu];
    
    UITapGestureRecognizer *tapOutsideMenu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOutsideMenu:)];
    [self.view addGestureRecognizer:tapOutsideMenu];
}


- (void)didTapOutsideMenu:(UITapGestureRecognizer *)tap {
    NSAssert([tap isKindOfClass:[UITapGestureRecognizer class]], @"inconsistent - another gesture recognizer?");
    
#warning need to verify here that no menu animation is in progress
    [self.menu popToRoot];
}

@end
