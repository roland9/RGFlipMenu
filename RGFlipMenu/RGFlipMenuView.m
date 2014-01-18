//
//  RGFlipMenuView.m
//  RGFlipMenuView
//
//  Created by RolandG on 17/11/2013.
//  Copyright (c) 2013 FM. All rights reserved.
//

#import "RGFlipMenuView.h"

@interface RGFlipMenuView ()
@property (copy) void (^actionBlock) (void);
@property (nonatomic, strong) UIView *mainMenuView;
@property (nonatomic, strong) UIView *subMenusView;

@property (nonatomic, strong) UILabel *menuLabel;
@property (nonatomic, strong) UILabel *menuLabelBack;
@property (nonatomic, strong) NSArray *subMenus;
@property (nonatomic, assign) BOOL isFrontsideShown;
@end


@implementation RGFlipMenuView {
    BOOL isSubMenu;
    CGPoint originalCenter;
    CGFloat mainMenuOffset;
}

#define kRGMainMenuWidth  180
#define kRGMainMenuHeight 180
#define kRGSubMenuWidth   120
#define kRGSubMenuHeight  120
#define kRGAnimationDuration 0.4f

////////////////////////////////////////////////////////////////////
# pragma mark - Public methods

-(void)popToRoot {
    NSAssert(!isSubMenu, @"switch to root only allowed for main/root menu, not the sub menus");
    if (!self.isFrontsideShown) {
        [self didTapMenu];
    }
}

- (NSString *)menuText {
    return self.menuLabel.text;
}


////////////////////////////////////////////////////////////////////
# pragma mark - public initializers and factories

+ (id)subMenuWithText:(NSString *)theMenuText actionBlock:(void (^)(void))theActionBlock {
    NSAssert(theMenuText, @"menuText is mandatory");
    NSAssert(theActionBlock, @"actionBlock block is mandatory");
    
    RGFlipMenuView *menu = [[RGFlipMenuView alloc] initWithFrame:CGRectMake(0, 0, kRGSubMenuWidth, kRGSubMenuHeight) text:theMenuText actionBlock:theActionBlock subMenus:NULL isSubMenu:YES];
    return menu;
}


- (id)initWithText:(NSString *)menuText actionBlock:(void (^)(void))theActionBlock subMenus:(NSArray *)theSubMenus {
    CGRect frame = CGRectMake(0, 0, kRGMainMenuWidth, kRGMainMenuHeight);
    self = [self initWithFrame:frame text:menuText actionBlock:theActionBlock subMenus:theSubMenus isSubMenu:NO];
    return self;
}


////////////////////////////////////////////////////////////////////
# pragma mark - designated initializer

- (id)initWithFrame:(CGRect)theFrame text:(NSString *)theMenuText actionBlock:(void (^)(void))theActionBlock subMenus:(NSArray *)theSubMenus isSubMenu:(BOOL)theSubMenuFlag {
    self = [super initWithFrame:theFrame];
    if (self) {
        
        isSubMenu = theSubMenuFlag;
        self.subMenus = theSubMenus;
        self.isFrontsideShown = YES;
        self.actionBlock = theActionBlock;
        
        self.menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(theFrame), CGRectGetHeight(theFrame))];
        [self.menuLabel setText:theMenuText];
        [self.menuLabel setFont:[UIFont preferredFontForTextStyle:isSubMenu ? UIFontTextStyleSubheadline : UIFontTextStyleHeadline]];
        [self.menuLabel setTextAlignment:NSTextAlignmentCenter];
        [self.menuLabel setTextColor:[UIColor darkGrayColor]];
        [self.menuLabel setNumberOfLines:3];

        self.mainMenuView = [[UIView alloc] initWithFrame:theFrame];
        [self.mainMenuView setBackgroundColor:[UIColor yellowColor]];
        [self addSubview:self.mainMenuView];
        [self.mainMenuView addSubview:self.menuLabel];
        
        if (!isSubMenu) {
            self.menuLabelBack = [[UILabel alloc] initWithFrame:self.menuLabel.frame];
            [self.menuLabelBack setText:@"Back"];
            [self.menuLabelBack setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
            [self.menuLabelBack setTextAlignment:NSTextAlignmentCenter];
            [self.menuLabelBack setTextColor:[UIColor darkGrayColor]];
            [self.menuLabelBack setNumberOfLines:3];
            [self.menuLabelBack setHidden:YES];
            [self.mainMenuView addSubview:self.menuLabelBack];
        }
        
        // for main menu: create submenu view with the menu items
        if (!isSubMenu) {
            self.subMenusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(theFrame), CGRectGetHeight(theFrame))];
            [self.subMenusView setHidden:YES];
            [self addSubview:self.subMenusView];
            
            NSUInteger subMenuIndex = 0;
            for (RGFlipMenuView *subMenuView in theSubMenus) {
                NSAssert([subMenuView isKindOfClass:[RGFlipMenuView class]], @"expected instance RGMenuView class in backsideMenu array");
                
                CGRect frame = [self subMenuFrameWithIndex:subMenuIndex];
                [subMenuView setFrame:frame];
                [self.subMenusView addSubview:subMenuView];
                subMenuIndex ++;
            }
        }
        
        [self setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapMenu)];
        [self.mainMenuView addGestureRecognizer:tap];

        mainMenuOffset = CGRectGetHeight(self.mainMenuView.frame);
    }
    return self;
}


////////////////////////////////////////////////////////////////////
# pragma mark - Private

- (void)didTapMenu {
    
    if (isSubMenu) {
        self.actionBlock();
        
    } else {
        
        BOOL isLandscape = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);

        // move the main menu over; duration twice the 90º rotations
        [UIView animateWithDuration:kRGAnimationDuration*2 delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            originalCenter = self.center;

            CGFloat factor = self.isFrontsideShown ? -1.f : +1.f;
            if (isLandscape)
                [self.mainMenuView setCenter:CGPointMake(self.mainMenuView.center.x + factor * mainMenuOffset, self.mainMenuView.center.y)];
            else
                [self.mainMenuView setCenter:CGPointMake(self.mainMenuView.center.x, self.mainMenuView.center.y + factor * mainMenuOffset)];
            
        } completion:^(BOOL finished) {

        }];
        
        
        // rotate main menu
        [UIView animateWithDuration:kRGAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            // rotate 90º; axis depends on device orientation
//            [self.mainMenuView.layer setAnchorPoint:CGPointMake(0, 0.5)];
            [self.mainMenuView.layer setTransform:CATransform3DConcat(CATransform3DMakeScale(0.8f, 0.8f, 1.0f), CATransform3DMakeRotation(M_PI_2, isLandscape ? 0.f : 1.f, isLandscape ? 1.f : 0.f, 0.f))];

        } completion:^(BOOL finished) {
            
            // then rotate 90º again, but also show sub menus
            [self toggleStatus];
            
            BOOL isIPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
            
            [UIView animateWithDuration:kRGAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut  animations:^{

                // finish rotation of main menu
                [self.mainMenuView.layer setTransform:CATransform3DConcat(CATransform3DMakeScale(0.6f, 0.6f, 1.0f), CATransform3DMakeRotation(self.isFrontsideShown ? 0 : M_PI, isLandscape ? 0. : 1., isLandscape ? 1. : 0., 0.))];
                // for the back menu label: set rotation to 180
                [self.menuLabelBack.layer setTransform:CATransform3DMakeRotation(M_PI, isLandscape ? 0. : 1., isLandscape ? 1. : 0., 0.)];
    

                if (self.isFrontsideShown) {
                    [self.layer setTransform:CATransform3DIdentity];
                    [self.mainMenuView.layer setTransform:CATransform3DIdentity];
                    
                    [self setCenter:originalCenter];
                    
                    // move back submenus
                    NSUInteger subMenuIndex = 0;
                    for (RGFlipMenuView *subMenuView in self.subMenus) {
                        NSAssert([subMenuView isKindOfClass:[RGFlipMenuView class]], @"inconsistent");
                        if (isLandscape)
                            [subMenuView setCenter:CGPointMake(subMenuView.center.x - subMenuIndex*CGRectGetWidth(self.frame), subMenuView.center.y)];
                        else
                            [subMenuView setCenter:CGPointMake(subMenuView.center.x, subMenuView.center.y - subMenuIndex*CGRectGetHeight(self.frame))];
                        subMenuIndex++;
                    }
                    
                } else {
                    
                    // pop out submenus
                    NSUInteger subMenuIndex = 0;
                    for (RGFlipMenuView *subMenuView in self.subMenus) {
                        if (isLandscape)
                            [subMenuView setCenter:CGPointMake(subMenuView.center.x + subMenuIndex*CGRectGetWidth(self.frame), subMenuView.center.y)];
                        else
                            [subMenuView setCenter:CGPointMake(subMenuView.center.x, subMenuView.center.y + subMenuIndex*CGRectGetHeight(self.frame))];
                        
                        subMenuIndex++;
                    }
                    
                }

            } completion:^(BOOL finished) {
                self.isFrontsideShown ? self.actionBlock() : nil; // todoRG pending - call block of background menu
            }];
            
        }];
    }
}


- (void)toggleStatus {
    self.isFrontsideShown = !self.isFrontsideShown;
    [self.menuLabel setHidden:!self.isFrontsideShown];
    [self.subMenusView setHidden:self.isFrontsideShown];
    [self.menuLabelBack setHidden:self.isFrontsideShown];
}


- (CGRect)subMenuFrameWithIndex:(NSUInteger)index {
    CGFloat width = 90;
    CGFloat height = width;
    CGFloat xPadding = 10;
    CGFloat yPadding = xPadding;

    return CGRectMake(xPadding, yPadding, kRGSubMenuWidth, kRGSubMenuHeight);

//    switch (index) {
//        case 0:
//            return CGRectMake(xPadding, yPadding, width, height);
//            break;
//            
//        case 1:
//            return CGRectMake(width+2.*xPadding, yPadding, width, height);
//            break;
//
//        case 2:
//            return CGRectMake(xPadding, height+2.*yPadding, width, height);
//            break;
//
//        case 3:
//            return CGRectMake(width+xPadding, height+2.*yPadding, width, height);
//            break;
//
//        default:
//            NSAssert(NO, @"inconsistent - expected 0 <= index <= 3");
//            return CGRectMake(0, 0, 10, 10);
//            break;
//    }
}


@end
