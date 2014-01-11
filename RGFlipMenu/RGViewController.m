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
    
    self.menu = [[RGFlipMenuView alloc] initWithText:@"Main Menu"
                                         actionBlock:^{
                                             NSLog(@"selected main menu");
                                         }
                                            subMenus:@[ [RGFlipMenuView subMenuWithText:@"Sub Menu 1" actionBlock:^{ NSLog(@"selected sub menu 1"); }],
                                                        [RGFlipMenuView subMenuWithText:@"Sub Menu 2" actionBlock:^{ NSLog(@"selected sub menu 2"); }],
                                                        [RGFlipMenuView subMenuWithText:@"Sub Menu 3" actionBlock:^{ NSLog(@"selected sub menu 3"); }]]
                 ];
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
