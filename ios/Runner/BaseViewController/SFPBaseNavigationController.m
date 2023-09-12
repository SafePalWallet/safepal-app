
#import "SFPBaseNavigationController.h"


@interface SFPBaseNavigationController ()<UINavigationControllerDelegate>

@property (strong, nonatomic)  UIPanGestureRecognizer *pan;

@end

@implementation SFPBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.enabled = NO;
    id target = self.interactivePopGestureRecognizer.delegate;
    SEL backGestureSelector = NSSelectorFromString(@"handleNavigationTransition:");
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:backGestureSelector];
    
    [self.view addGestureRecognizer:self.pan];
    self.delegate = self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        UIImage * backImage = [UIImage imageNamed:@"navi_back_arrow_black"];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(popViewControllerAnimated:)];
        viewController.navigationItem.leftBarButtonItem = item;
    }
    [super pushViewController:viewController animated:animated];
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (navigationController.viewControllers.count>1) {
        self.pan.enabled = YES;
    }else{
        self.pan.enabled = NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
