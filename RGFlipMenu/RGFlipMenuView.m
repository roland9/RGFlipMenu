//
//  RGFlipMenuView.m
//  RGFlipMenuView
//
//  Created by RolandG on 17/11/2013.
//  Copyright (c) 2013 FM. All rights reserved.
//

#import "RGFlipMenuView.h"
#import "RGFlipMainMenuView.h"
#import "RGFlipSubMenuView.h"
#import "RGFlipMenu.h"
#import <FrameAccessor.h>


CGRect mainMenuRect() {
    return CGRectMake(0, 0, UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 180 : 120, UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 180 : 120);
}

CGRect subMenuRect() {
    return CGRectMake(0, 0, UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 160 : 110, UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 160 : 110);
}


@interface RGFlipMenuView ()

@property (nonatomic, strong) NSArray *mainMenus;

@end


@implementation RGFlipMenuView

////////////////////////////////////////////////////////////////////
# pragma mark - Public methods

////////////////////////////////////////////////////////////////////
# pragma mark - designated initializer

- (id)initWithFrame:(CGRect)theFrame mainMenus:(NSArray *)theMainMenus {
    self = [super initWithFrame:theFrame];
    if (self) {
        _mainMenus = theMainMenus;
        
                self.backgroundColor = [UIColor lightGrayColor];    // troubleshooting only
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        self.autoresizesSubviews = YES;
        
        [theMainMenus enumerateObjectsUsingBlock:^(RGFlipMenu *mainMenu, NSUInteger idx, BOOL *stop) {
            NSAssert([mainMenu isKindOfClass:[RGFlipMenu class]], @"expected RGFlipMenu classes");
            
            RGFlipMainMenuView *mainMenuView = [[RGFlipMainMenuView alloc] initWithFrame:mainMenuRect() text:mainMenu.menuText subMenus:mainMenu.subMenus delegate:self];
            mainMenu.menuView = mainMenuView;
            [self addSubview:mainMenuView];
        }];
    }
    return self;
}


////////////////////////////////////////////////////////////////////
# pragma mark - Private

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self positionSubviews];
}


- (void)positionSubviews {

    NSUInteger indexOfOpenMenu = 0;
    BOOL isAnyMenuOpen = [[self.mainMenus filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isMenuClosed=NO"]] count];
    if (isAnyMenuOpen) {
        indexOfOpenMenu = [self.mainMenus indexOfObject:[self.mainMenus filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isMenuClosed=NO"]][0]];
    }
    
    
    [self.mainMenus enumerateObjectsUsingBlock:^(RGFlipMenu *mainMenu, NSUInteger idx, BOOL *stop) {

        RGFlipMainMenuView *mainMenuView = mainMenu.menuView;
        NSAssert([mainMenuView isKindOfClass:[RGFlipMainMenuView class]], @"inconsistent");

        if (mainMenu.isMenuClosed && isAnyMenuOpen) {
            // another main menu is open -> move this one out of the way
            mainMenuView.center = [RGFlipMenuView mainMenuCenterOffWithIndex:idx maxMenus:[self.mainMenus count] indexOfOpenMenu:indexOfOpenMenu parentView:self];
            
        } else if (mainMenu.isMenuClosed) {
            
            // close menu: center main menu & restore size ...
            mainMenuView.bounds = mainMenuView.mainMenuView.bounds;
            mainMenuView.center = [RGFlipMenuView mainMenuCenterWithIndex:idx maxMenus:[self.mainMenus count] parentView:self];
            mainMenuView.mainMenuWrapperView.center = mainMenuView.middlePoint;
            [mainMenuView.mainMenuWrapperView.layer setTransform:CATransform3DIdentity];
            
            // ... and move back submenus
            mainMenuView.subMenusView.bounds = mainMenuView.bounds;
            mainMenuView.subMenusView.center = mainMenuView.middlePoint;
            
            [mainMenu.subMenus enumerateObjectsUsingBlock:^(RGFlipMenu *subMenu, NSUInteger idx, BOOL *stop) {
                NSAssert([subMenu isKindOfClass:[RGFlipMenu class]], @"inconsistent");
                RGFlipSubMenuView *subMenuView = subMenu.menuView;
                NSAssert([subMenuView isKindOfClass:[RGFlipSubMenuView class]], @"inconsistent");
                subMenuView.center = mainMenuView.subMenusView.middlePoint;
                subMenuView.layer.transform = CATransform3DMakeScale(0.2, 0.2, 1);
            }];
            
        } else {

            // open menu: center it
            mainMenuView.bounds = self.bounds;
            mainMenuView.center = self.middlePoint;
            
            // de-center main menu & shrink it ...
            if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
                mainMenuView.mainMenuWrapperView.center = CGPointMake(mainMenuView.centerX - [RGFlipMenuView mainMenuOffset], mainMenuView.centerY);
            else
                mainMenuView.mainMenuWrapperView.center = CGPointMake(mainMenuView.centerX, mainMenuView.centerY - [RGFlipMenuView mainMenuOffset]);
            
            [mainMenuView.mainMenuWrapperView.layer setTransform:CATransform3DMakeScale(0.8, 0.8, 1)];
            
            // ... and pop out submenus
            mainMenuView.subMenusView.bounds = self.bounds;
            mainMenuView.subMenusView.center = mainMenuView.middlePoint;
            
            [mainMenu.subMenus enumerateObjectsUsingBlock:^(RGFlipMenu *subMenu, NSUInteger idx, BOOL *stop) {
                NSAssert([subMenu isKindOfClass:[RGFlipMenu class]], @"inconsistent");
                RGFlipSubMenuView *subMenuView = subMenu.menuView;
                NSAssert([subMenuView isKindOfClass:[RGFlipSubMenuView class]], @"inconsistent");
                subMenuView.center = [RGFlipMenuView subMenuCenterWithIndex:idx maxSubMenus:[mainMenu.subMenus count] parentView:mainMenuView.subMenusView];
                subMenuView.layer.transform = CATransform3DIdentity;
            }];
        }
        
    }];
}

#define kRGAnimationDuration 0.4f


////////////////////////////////////////////////////////////////////
# pragma mark - RGFlipMenuDelegate

- (void)didTapMenu:(RGFlipMainMenuView *)mainMenuView {
    NSLog(@"didTapMenu=%@", mainMenuView);
    NSAssert([mainMenuView isKindOfClass:[RGFlipMainMenuView class]], @"inconsistent");
    RGFlipMenu *mainMenu = [self.mainMenus filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"menuView=%@", mainMenuView]][0];
    NSAssert(mainMenu, @"expected to find mainMenu");
    mainMenu.actionBlock();
    
    mainMenu.isMenuClosed = !mainMenu.isMenuClosed;
    [mainMenuView.menuLabel setHidden:!mainMenu.isMenuClosed];
    [mainMenuView.menuLabelBack setHidden:mainMenu.isMenuClosed];

    [UIView animateWithDuration:kRGAnimationDuration animations:^{
        [self positionSubviews];
    }];
    
    BOOL isLandscape = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
    
    // ... and flip
    [UIView transitionWithView:mainMenu.menuView
                      duration:kRGAnimationDuration
                       options:(isLandscape ?
                                (mainMenu.isMenuClosed ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight) :
                                (mainMenu.isMenuClosed ? UIViewAnimationOptionTransitionFlipFromBottom : UIViewAnimationOptionTransitionFlipFromTop)
                                ) | UIViewAnimationOptionAllowAnimatedContent
                    animations:^{
                    } completion:NULL];
}



+ (CGFloat)subMenuAllOffset {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 50;
    else
        return 60;
}

+ (CGFloat)subMenuOffset {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 180;
    else
        return 120;
}


+ (CGFloat)mainMenuOffset {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 250;
    else
        return 200;
}


+ (CGPoint)subMenuCenterWithIndex:(NSUInteger)theIndex maxSubMenus:(NSUInteger)theMaxSubMenus parentView:(UIView *)theParentView {
    BOOL isLandscape = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);

    if (isLandscape) {
        return CGPointMake(theParentView.width*0.3 + subMenuRect().size.width/2.f + ( (theParentView.width*0.7f)  / (theMaxSubMenus) * theIndex ), theParentView.middleY);

    } else
        return CGPointMake(theParentView.middleX, theParentView.height*0.3 + subMenuRect().size.height/2.f + ( (theParentView.height*0.7f)  / (theMaxSubMenus) * theIndex ));
}


+ (CGPoint)mainMenuCenterWithIndex:(NSUInteger)theIndex maxMenus:(NSUInteger)theMaxMenus parentView:(UIView *)theParentView {
    BOOL isLandscape = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
    
    if (isLandscape) {
        return CGPointMake(theParentView.width / theMaxMenus * 0.5f + ( theParentView.width / theMaxMenus * theIndex ), theParentView.middleY);
        
    } else
        return CGPointMake(theParentView.middleX, theParentView.height / theMaxMenus * 0.5f  + ( theParentView.height / theMaxMenus * theIndex ));
}


+ (CGPoint)mainMenuCenterOffWithIndex:(NSUInteger)theIndex maxMenus:(NSUInteger)theMaxMenus indexOfOpenMenu:(NSUInteger)theIndexOfOpenMenu parentView:(UIView *)theParentView {
    
    BOOL isLandscape = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
    
    if (isLandscape) {
        if (theIndex<theIndexOfOpenMenu) {
            return CGPointMake(-mainMenuRect().size.width*2.f, theParentView.middleY);
        } else {
            return CGPointMake(theParentView.width + mainMenuRect().size.width*2.f, theParentView.middleY);
        }
        
    } else {
        if (theIndex<theIndexOfOpenMenu) {
            return CGPointMake(theParentView.middleX, -mainMenuRect().size.height*2.f);
        } else {
            return CGPointMake(theParentView.middleX, theParentView.height + mainMenuRect().size.height*2.f);
        }
    }
}

@end
