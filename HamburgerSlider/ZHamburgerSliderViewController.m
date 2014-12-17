//
//  ViewController.m
//  ZHanmburgerSlider
//
//  Created by Allen Lee I on 12/16/14.
//  Copyright (c) 2014 Allen Lee I. All rights reserved.
//

#import "ZHamburgerSliderViewController.h"

#define kSTANDINGVIEWTAG 1000
#define kMOVINGVIEWTAG 1001
#define KSCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define KSLIDEANIMATIONSPEED 0.15
#define kTOPSLIDEMENUTHRESHOLD [UIScreen mainScreen].bounds.size.width - 64

@interface ZHamburgerSliderViewController ()
{
    BOOL movingSliderToRight;
    BOOL beganMovingSliderToRight;
}

@property(nonatomic,strong) UIView * menuBaseView;
@property(nonatomic,strong) UIView * moduleBaseView;
@property(nonatomic,strong) id menuViewController;
@property(nonatomic,strong) id moduleViewController;

@property(nonatomic)enum ZHamburgerMode slideMode;
@property(nonatomic)UIPanGestureRecognizer *gestureRecogniser;

@end

@implementation ZHamburgerSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

-(void)configureViewWithSlideMode:(enum ZHamburgerMode)mode menuView:(id)menuViewController moduleView:(id)moduleViewController
{
    // This is required to add view controllers as child viewcontrollers to the superview
    
    self.menuViewController = menuViewController;
    self.moduleViewController = moduleViewController;
    self.slideMode = mode;
    
    
    if([menuViewController isKindOfClass:[UINavigationController class]])
    {
        self.menuBaseView = [(UINavigationController*)menuViewController view];
    }
    else{
        self.menuBaseView = [(UINavigationController*)menuViewController view];
    }
    
    if([moduleViewController isKindOfClass:[UINavigationController class]])
    {
        self.moduleBaseView = [(UINavigationController*)moduleViewController view];
    }
    else{
        self.moduleBaseView = [(UINavigationController*)moduleViewController view];
    }
    
    if(mode == SLIDEBOTTOM)
    {
        [self addMenuView];
        [self addModuleView];
        [self addShadowBeneathView:self.moduleBaseView];
        self.menuBaseView.tag = kSTANDINGVIEWTAG;
        self.moduleBaseView.tag = kMOVINGVIEWTAG;
    }
    else if(mode == SLIDETOP)
    {
        [self addModuleView];
        [self addMenuView];
        [self.view bringSubviewToFront:self.menuBaseView];
        [self addShadowBeneathView:self.menuBaseView];
        self.menuBaseView.tag = kMOVINGVIEWTAG;
        self.moduleBaseView.tag = kSTANDINGVIEWTAG;
    }
    
    
    [self addGestureRecogniser];
    
}

-(void)addMenuView
{
    UIView *parentView =nil;
    [self addChildViewController:self.menuViewController];
    [self.view addSubview:self.menuBaseView];
    [self.menuViewController didMoveToParentViewController:self];
    parentView = self.view;
    
    self.menuBaseView.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *childView = self.menuBaseView;
    
    [parentView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [parentView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    
    if(self.slideMode == SLIDEBOTTOM)
    {
        [parentView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    }
    else if(self.slideMode == SLIDETOP){
        
        [parentView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kTOPSLIDEMENUTHRESHOLD]];
    }
    
    
    [parentView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
    
}

-(void)addModuleView
{
    UIView *parentView =nil;
    
    [self addChildViewController:self.moduleViewController];
    [self.view addSubview:self.moduleBaseView];
    [self.moduleViewController didMoveToParentViewController:self];
    parentView = self.view;
    
    self.moduleBaseView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *childView = self.moduleBaseView;
    
    [parentView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [parentView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [parentView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [parentView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
}

-(void)addGestureRecogniser
{
    if(!_gestureRecogniser)
    {
        _gestureRecogniser = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture)];
        [self.view addGestureRecognizer:_gestureRecogniser];
    }
}


-(void)handlePanGesture
{
    UIView *movingView = [self.view viewWithTag:kMOVINGVIEWTAG];
    CGFloat xTranslation = [_gestureRecogniser translationInView:self.view].x;
    
    CGPoint velocity = [_gestureRecogniser velocityInView:self.view];
    
    if(velocity.x > 0)
    {
        movingSliderToRight =YES;
    }
    else
    {
        movingSliderToRight = NO;
    }
    
    if(self.gestureRecogniser.state == UIGestureRecognizerStateBegan)
    {
        if(xTranslation > 0)
        {
            beganMovingSliderToRight = YES;
        }
        else{
            
            beganMovingSliderToRight = NO;
        }
    }
    else if(self.gestureRecogniser.state == UIGestureRecognizerStateChanged)
    {
        CGFloat positionalTranslationOffset = 0;
        
        if(!beganMovingSliderToRight)
        {
            if(self.slideMode == SLIDEBOTTOM)
            {
                if(movingView.frame.origin.x <= 0)
                {
                    positionalTranslationOffset = 0;
                }
                else{
                    positionalTranslationOffset = KSCREENWIDTH + xTranslation ;
                }
                
            }
            else{
                
                
                if(movingView.frame.origin.x <= -kTOPSLIDEMENUTHRESHOLD)
                {
                    positionalTranslationOffset = -kTOPSLIDEMENUTHRESHOLD;
                }
                else{
                    positionalTranslationOffset = xTranslation ;
                }
                
                
            }
        }
        else{
            
            if(self.slideMode == SLIDEBOTTOM)
            {
                if(movingView.frame.origin.x >= KSCREENWIDTH)
                {
                    positionalTranslationOffset = KSCREENWIDTH;
                }
                else{
                    positionalTranslationOffset = xTranslation;
                }
                
            }
            else{
                
                
                if(movingView.frame.origin.x >= 0)
                {
                    positionalTranslationOffset = 0;
                }
                else{
                    positionalTranslationOffset = -kTOPSLIDEMENUTHRESHOLD + xTranslation;
                }
                
            }
        }
        
        if(self.slideMode == SLIDEBOTTOM)
        {
            if(positionalTranslationOffset < 0 )
            {
                positionalTranslationOffset = 0;
            }
            else if(positionalTranslationOffset > KSCREENWIDTH)
            {
                positionalTranslationOffset = KSCREENWIDTH;
            }
            
        }
        else{
            
            if(positionalTranslationOffset > 0 )
            {
                positionalTranslationOffset = 0;
            }
            else if(positionalTranslationOffset < -kTOPSLIDEMENUTHRESHOLD)
            {
                positionalTranslationOffset = -kTOPSLIDEMENUTHRESHOLD;
            }
            
            
        }
        
        
        [self changePositionOfView:movingView attribute:NSLayoutAttributeLeft byConstant:positionalTranslationOffset];
        
        
    }
    else if(self.gestureRecogniser.state == UIGestureRecognizerStateCancelled || self.gestureRecogniser.state == UIGestureRecognizerStateFailed || self.gestureRecogniser.state == UIGestureRecognizerStateEnded)
    {
        
        if(self.slideMode == SLIDEBOTTOM)
        {
            
            if(!movingSliderToRight)
            {
                [self changePositionOfView:movingView attribute:NSLayoutAttributeLeft byConstant:0];
            }
            else{
                
                [self changePositionOfView:movingView attribute:NSLayoutAttributeLeft byConstant:KSCREENWIDTH];
            }
            
        }
        else{
            
            if(!movingSliderToRight)
            {
                [self changePositionOfView:movingView attribute:NSLayoutAttributeLeft byConstant:-kTOPSLIDEMENUTHRESHOLD];
            }
            else{
                
                [self changePositionOfView:movingView attribute:NSLayoutAttributeLeft byConstant:0];
            }
            
        }
        
        
        [UIView animateWithDuration:KSLIDEANIMATIONSPEED delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            [self.view layoutIfNeeded];
            
        }completion:^(BOOL completion)
         {
             
         }];
    }
}

-(void)changePositionOfView:(UIView*)view attribute:(NSLayoutAttribute)attribute byConstant:(CGFloat)constant
{
    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        
        if ((constraint.firstItem == view) && (constraint.firstAttribute == attribute))
        {
            constraint.constant =  constant;
            return;
        }
        
    }];
    
}

-(void)moveSliderToLeft
{
    UIView *movingView = [self.view viewWithTag:kMOVINGVIEWTAG];
    
    if(self.slideMode == SLIDEBOTTOM)
    {
        
        [self changePositionOfView:movingView attribute:NSLayoutAttributeLeft byConstant:0];
    }
    else{
        
        
        [self changePositionOfView:movingView attribute:NSLayoutAttributeLeft byConstant:-kTOPSLIDEMENUTHRESHOLD];
    }
    
    [UIView animateWithDuration:KSLIDEANIMATIONSPEED delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        [self.view layoutIfNeeded];
        
    }completion:^(BOOL completion)
     {
         
     }];
    
    
}

-(void)moveSliderToRight
{
    UIView *movingView = [self.view viewWithTag:kMOVINGVIEWTAG];
    
    if(self.slideMode == SLIDEBOTTOM)
    {
        
        [self changePositionOfView:movingView attribute:NSLayoutAttributeLeft byConstant:KSCREENWIDTH];
    }
    else{
        
        
        [self changePositionOfView:movingView attribute:NSLayoutAttributeLeft byConstant:0];
    }
    
    [UIView animateWithDuration:KSLIDEANIMATIONSPEED delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        [self.view layoutIfNeeded];
        
    }completion:^(BOOL completion)
     {
         
     }];
}

-(void)addShadowBeneathView:(UIView*)view
{
    if(self.slideMode == SLIDEBOTTOM)
    {
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:view.bounds];
        view.layer.masksToBounds = NO;
        view.layer.shadowColor = [UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
        view.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
        view.layer.shadowOpacity = 0.5f;
        view.layer.shadowPath = shadowPath.CGPath;
        
    }
    else{
        view.layer.borderColor =  [UIColor colorWithWhite:0.7 alpha:1.0].CGColor;
        view.layer.borderWidth =0.3;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
