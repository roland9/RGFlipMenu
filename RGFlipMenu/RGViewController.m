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
    
    self.menu = [[RGFlipMenuView alloc] initWithText:@"Menu Help"
                                         actionBlock:^{
                                             NSLog(@"selected main menu");
                                         }
                                            subMenus:@[ [RGFlipMenuView subMenuWithText:@"Solo Play" actionBlock:^{ NSLog(@"selected solo"); }],
                                                        [RGFlipMenuView subMenuWithText:@"Two Player (local)" actionBlock:^{ NSLog(@"selected two player (local)"); }],
                                                        [RGFlipMenuView subMenuWithText:@"Login with Game Center" actionBlock:^{ NSLog(@"selected Game Center"); }]]
                 ];
    self.menu.center = self.view.middlePoint;
    [self.view addSubview:self.menu];
    
    UITapGestureRecognizer *tapOutsideMenu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOutsideMenu:)];
    [self.view addGestureRecognizer:tapOutsideMenu];
}


- (void)didTapOutsideMenu:(UITapGestureRecognizer *)tap {
    NSAssert([tap isKindOfClass:[UITapGestureRecognizer class]], @"inconsistent");
    
#warning need to verify here that no menu animation is in progress
    [self.menu popToRoot];
}

@end
