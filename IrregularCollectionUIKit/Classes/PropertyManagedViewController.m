//
//  PropertyManagedViewController.m
//  IrregularCollectionUIKit
//
//  Created by pisces on 9/20/16.
//
//

#import "PropertyManagedViewController.h"

@interface PropertyManagedViewController ()

@end

@implementation PropertyManagedViewController

#pragma mark - Overridden: UIViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initProperties];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initProperties];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _isViewAppeared = YES;
    
    [self invalidateProperties];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    _isFirstViewAppearence = NO;
    _isViewAppeared = NO;
}

#pragma mark - Public methods

- (void)commitProperties {
}

- (void)initProperties {
    _isFirstViewAppearence = YES;
}

- (void)invalidateProperties {
    if (self.isViewLoaded) {
        [self commitProperties];
    }
}

@end
