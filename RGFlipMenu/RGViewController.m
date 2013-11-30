//
//  RGViewController.m
//  RGFlipMenu
//
//  Created by RolandG on 30/11/2013.
//  Copyright (c) 2013 mapps. All rights reserved.
//

#import "RGViewController.h"
#import "RGFlipMenuView.h"
#import <FrameAccessor.h>


@interface RGViewController ()
@property (nonatomic, strong) RGFlipMenuView *menu;
@end

@implementation RGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menu = [[RGFlipMenuView alloc] initWithSize:CGSizeMake(200., 200.)
                                             text:@"Menu Help"
                                            block:^{
                                                NSLog(@"front side selected");
                                            }
                                    backsideMenus:@[ [RGFlipMenuView menuWithText:@"Solo Play" block:^{ NSLog(@"selected solo"); }],
                                                     [RGFlipMenuView menuWithText:@"Two Player (local)" block:^{ NSLog(@"selected two player (local)"); }],
                                                     [RGFlipMenuView menuWithText:@"Login with Game Center" block:^{ NSLog(@"selected Game Center"); }]]
                  ];
    
    self.menu.center = self.view.middlePoint;
    [self.menu setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    [self.view addSubview:self.menu];
    
    UITapGestureRecognizer *tapOutsideMenu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOutsideMenu:)];
    [self.view addGestureRecognizer:tapOutsideMenu];
}


- (void)didTapOutsideMenu:(UITapGestureRecognizer *)tap {
    NSAssert([tap isKindOfClass:[UITapGestureRecognizer class]], @"inconsistent");
    
    [self.menu popToRoot];
}

@end
