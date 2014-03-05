//
//  RGFlipMenuView.m
//  RGFlipMenuView
//
//  Created by RolandG on 17/11/2013.
//  Copyright (c) 2013 FM. All rights reserved.
//

#import "RGFlipMenuView.h"
#import "RGFlipSubMenuView.h"
#import "RGFlipMenu.h"
#import <FrameAccessor.h>


@interface RGFlipMenuView ()
@property (nonatomic, strong) UIView *mainMenuWrapperView;
@property (nonatomic, strong) UIView *mainMenuView;
@property (nonatomic, strong) UIView *subMenusView;

@property (nonatomic, strong) UILabel *menuLabel;
@property (nonatomic, strong) UILabel *menuLabelBack;

@property (nonatomic, strong) NSArray *mainMenus;
@property (nonatomic, strong) NSArray *subMenus;
@property (nonatomic, strong) NSMutableArray *subMenuViews;


@property (nonatomic, assign) BOOL isMenuClosed;
@end

@implementation RGFlipMenuView

////////////////////////////////////////////////////////////////////
# pragma mark - Public methods

-(void)popToRoot {
    if (!self.isMenuClosed) {
        [self didTapMenu:self];
    }
}


- (void)changeText:(NSString *)theText {
    self.menuLabel.text = theText;
}


- (NSString *)menuText {
    return self.menuLabel.text;
}


////////////////////////////////////////////////////////////////////
# pragma mark - designated initializer

- (id)initWithFrame:(CGRect)theFrame mainMenus:(NSArray *)theMainMenus {
    self = [super initWithFrame:theFrame];
    if (self) {
        _mainMenus = theMainMenus;
        _isMenuClosed = YES;
        
                self.backgroundColor = [UIColor lightGrayColor];    // troubleshooting only
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        self.autoresizesSubviews = YES;
        
        [theMainMenus enumerateObjectsUsingBlock:^(RGFlipMenu *flipMainMenu, NSUInteger idx, BOOL *stop) {
            NSAssert([flipMainMenu isKindOfClass:[RGFlipMenu class]], @"expected RGFlipMenu classes");
            
            _menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [RGFlipMenuView mainMenuWidth], [RGFlipMenuView mainMenuHeight])];
            [_menuLabel setText:flipMainMenu.menuText];
            [_menuLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
            [_menuLabel setTextAlignment:NSTextAlignmentCenter];
            [_menuLabel setTextColor:[UIColor darkGrayColor]];
            [_menuLabel setNumberOfLines:3];
            
            // the mainMenuWrapperView is required so that the main Menu move animation is consistent
            _mainMenuWrapperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [RGFlipMenuView mainMenuWidth], [RGFlipMenuView mainMenuHeight])];
//                 [_mainMenuWrapperView setBackgroundColor:[UIColor greenColor]];    // troubleshooting only
            [_mainMenuWrapperView setCenter:self.middlePoint];
            
            [self addSubview:_mainMenuWrapperView];
            
            _mainMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [RGFlipMenuView mainMenuWidth], [RGFlipMenuView mainMenuHeight])];
            _mainMenuView.center = _mainMenuWrapperView.middlePoint;
            [_mainMenuView setBackgroundColor:kRGMainMenuColor];
            [_mainMenuView addSubview:_menuLabel];
            [_mainMenuWrapperView addSubview:_mainMenuView];
            
            // create backside view & submenu view with the menu items
            _menuLabelBack = [[UILabel alloc] initWithFrame:_menuLabel.frame];
            [_menuLabelBack setText:@"Back"];
            [_menuLabelBack setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
            [_menuLabelBack setTextAlignment:NSTextAlignmentCenter];
            [_menuLabelBack setTextColor:[UIColor darkGrayColor]];
            [_menuLabelBack setNumberOfLines:3];
            [_menuLabelBack setHidden:YES];
            [_mainMenuView addSubview:_menuLabelBack];
            
            _subMenusView = [[UIView alloc] initWithFrame:self.frame];
//            [_subMenusView setBackgroundColor:[UIColor orangeColor]];
            [_subMenusView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
            [self insertSubview:_subMenusView belowSubview:_mainMenuWrapperView];

            _subMenuViews = [NSMutableArray arrayWithCapacity:[flipMainMenu.subMenus count]];
            for (RGFlipMenu *subMenu in flipMainMenu.subMenus) {
                NSAssert([subMenu isKindOfClass:[RGFlipMenu class]], @"expected instance RGFlipMenu class in subMenu array");
                
                RGFlipSubMenuView *subMenuView = [[RGFlipSubMenuView alloc] initWithFrame:CGRectMake(0, 0, [RGFlipMenuView subMenuWidth], [RGFlipMenuView subMenuHeight]) text:subMenu.menuText actionBlock:subMenu.actionBlock];
                [_subMenusView addSubview:subMenuView];
                [_subMenuViews addObject:subMenuView];
            }
            if (flipMainMenu.subMenus) {
                _subMenus = flipMainMenu.subMenus;
            }
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapMenu:)];
            [_mainMenuView addGestureRecognizer:tap];
            
            [self bringSubviewToFront:_mainMenuView];
        }];
    }
    return self;
}


////////////////////////////////////////////////////////////////////
# pragma mark - Private

- (void)layoutSubviews {
    NSLog(@"layoutSubviews");
    [super layoutSubviews];
    
    [self positionSubviews];
}


- (void)positionSubviews {

    if (self.isMenuClosed) {
        
        // close menu: center main menu & restore size ...
        self.mainMenuWrapperView.center = self.middlePoint;
        [self.mainMenuView.layer setTransform:CATransform3DIdentity];
        
        // ... and move back submenus
        self.subMenusView.frame = self.mainMenuWrapperView.frame;
        self.subMenusView.center = self.middlePoint;
        
        [self.subMenuViews enumerateObjectsUsingBlock:^(RGFlipSubMenuView *subMenuView, NSUInteger idx, BOOL *stop) {
            NSAssert([subMenuView isKindOfClass:[RGFlipSubMenuView class]], @"inconsistent");
            subMenuView.center = self.subMenusView.middlePoint;
            subMenuView.layer.transform = CATransform3DMakeScale(0.2, 0.2, 1);
        }];

    } else {
        
        // open menu: de-center main menu & shrink it ...
        if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
            [self.mainMenuWrapperView setCenter:CGPointMake(self.center.x - [RGFlipMenuView mainMenuOffset], self.center.y)];
        else
            [self.mainMenuWrapperView setCenter:CGPointMake(self.center.x, self.center.y - [RGFlipMenuView mainMenuOffset]) ];
        
        [self.mainMenuView.layer setTransform:CATransform3DMakeScale(0.8, 0.8, 1)];

        // ... and pop out submenus
        self.subMenusView.frame = self.frame;
        self.subMenusView.center = self.middlePoint;

        [self.subMenuViews enumerateObjectsUsingBlock:^(RGFlipSubMenuView *subMenuView, NSUInteger idx, BOOL *stop) {
            NSAssert([subMenuView isKindOfClass:[RGFlipSubMenuView class]], @"inconsistent");
            subMenuView.center = [RGFlipMenuView subMenuCenterWithIndex:idx maxSubMenus:[self.subMenus count] parentView:self.subMenusView];
            subMenuView.layer.transform = CATransform3DIdentity;
        }];
    }
}

#define kRGAnimationDuration 0.4f


- (void)didTapMenu:(id)sender {

    [self toggleStatus];
    [UIView animateWithDuration:kRGAnimationDuration animations:^{
        [self positionSubviews];
    }];
    
    BOOL isLandscape = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
    
    // ... and flip
    [UIView transitionWithView:self.mainMenuView
                      duration:kRGAnimationDuration
                       options:(isLandscape ?
                                (self.isMenuClosed ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight) :
                                (self.isMenuClosed ? UIViewAnimationOptionTransitionFlipFromBottom : UIViewAnimationOptionTransitionFlipFromTop)
                                ) | UIViewAnimationOptionAllowAnimatedContent
                    animations:^{
                    } completion:NULL];
}


- (void)toggleStatus {
    self.isMenuClosed = !self.isMenuClosed;
    [self.menuLabel setHidden:!self.isMenuClosed];
    [self.menuLabelBack setHidden:self.isMenuClosed];
}


+ (CGFloat)subMenuWidth {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 160;
    else
        return 110;
}

+ (CGFloat)subMenuHeight {
    return [RGFlipMenuView subMenuWidth];
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

+ (CGFloat)mainMenuWidth {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 180;
    else
        return 120;
}

+ (CGFloat)mainMenuHeight {
    return [RGFlipMenuView mainMenuWidth];
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
        return CGPointMake(theParentView.width*0.3 + [self subMenuWidth]/2.f + ( (theParentView.width*0.7f)  / (theMaxSubMenus) * theIndex ), theParentView.middleY);

    } else
        return CGPointMake(theParentView.middleX, theParentView.height*0.3 + [self subMenuHeight]/2.f + ( (theParentView.height*0.7f)  / (theMaxSubMenus) * theIndex ));
}


@end
