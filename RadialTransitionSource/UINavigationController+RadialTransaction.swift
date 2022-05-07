import UIKit
let abc=AAPTransactionDirector();

var defaultRadialDuration:CGFloat = 0.5

extension UINavigationController {
    func getLeftRect()->CGRect{
        return .zero
    }
    //MARK: PUSH
    /**
    * radial pushing view controller
    *
    * @param startFrame where circle start
    */
    func radialPushViewController(viewController: UIViewController, duration: CGFloat = 0.33 ,startFrame:CGRect = CGRect.null, transitionCompletion: (() -> Void)? = nil) {
        
        var rect = startFrame
        if(rect == CGRect.null){
            if let visibleViewController = self.visibleViewController {
                rect = CGRect(x: visibleViewController.view.frame.size.width, y: visibleViewController.view.frame.size.height/2, width: 0, height: 0)
            }
        }
        
      
        let animatorDirector:AAPTransactionDirector?=AAPTransactionDirector();
        animatorDirector?.duration=duration
            
        self.delegate=animatorDirector
        
        animatorDirector?.animationBlock = { (transactionContext:UIViewControllerContextTransitioning, animationTime: CGFloat, completion:@escaping()->Void) in
            let toViewController = transactionContext.viewController(forKey: .to)
            let fromViewController = transactionContext.viewController(forKey: .from)
            let containerView = transactionContext.containerView
            
            if let fromViewController = fromViewController, let toViewController = toViewController {
                containerView.insertSubview(toViewController.view, aboveSubview: fromViewController.view)

                toViewController.view.radialDissmisWithStartFrame(startFrame: rect, duration: animationTime) {
                    completion()
                    transitionCompletion?()
               }
            }
        }
        
        self.pushViewController(viewController, animated: true)
        
        self.delegate = nil;
    }
    
    //MARK: POP
    /**
    * radial pop view controller
    *
    * @param startFrame where circle start
    */
    func radialPopViewController( duration: CGFloat = 0.33 ,startFrame:CGRect = CGRect.null, transitionCompletion: (() -> Void)? = nil) {
        
        var rect = startFrame
        if(rect == CGRect.null){
            if let visibleViewController = self.visibleViewController {
                rect = CGRect(x: 0, y: visibleViewController.view.frame.size.height/2, width: 0, height: 0)
            }
        }
        
        let animatorDirector=AAPTransactionDirector();
        animatorDirector.duration=duration
        self.delegate=animatorDirector;
        animatorDirector.animationBlock={(transactionContext:UIViewControllerContextTransitioning, animationTime: CGFloat, completion:@escaping()->Void) in
            
            let toViewController = transactionContext.viewController(forKey: .to)
            let fromViewController = transactionContext.viewController(forKey: .from)
            let containerView = transactionContext.containerView
            
            if let fromViewController = fromViewController, let toViewController = toViewController {
                containerView.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
                
                toViewController.view .radialAppireanceWithStartFrame(startFrame: rect, duration: animationTime, complitBlock: { () -> Void in
                    completion()
                    transitionCompletion?()
                })
            }
            
        }
        
        self.popViewController(animated: true)
        self.delegate = nil
    }
    
    
    //MARK: Swipe
    func enableRadialSwipe(){
        self.enableGesture(enabled: true)
    }
        
    func disableRadialSwipe(){
        self.enableGesture(enabled: false)
    }
    
    /**
    * enabling swipe back gesture. NOTE interactivePopGestureRecognizer will be disabled
    *
    */
    private func enableGesture(enabled:Bool){
        
        struct StaticStruct {
        
            static var recognizerData = Dictionary<String,UIGestureRecognizer>()
            
        }
        
        if enabled == true {
            if self.responds(to: #selector(getter: interactivePopGestureRecognizer)) {
                self.interactivePopGestureRecognizer?.isEnabled = false
            }
            
            let panGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenPan(_:)))
            panGesture.edges = UIRectEdge.left
            
            self.view.addGestureRecognizer(panGesture)
            
            StaticStruct.recognizerData[self.description] = panGesture
            
        } else {
            self.view.removeGestureRecognizer(StaticStruct.recognizerData[self.description]!)
            StaticStruct.recognizerData[self.description] = nil
        }
    }
    
    @objc func screenPan(_ sender: AnyObject){
        guard let pan: UIPanGestureRecognizer = sender as? UIPanGestureRecognizer else {
            return
        }
    
        let state: UIGestureRecognizer.State = pan.state
        
        let location:CGPoint = pan.location(in: self.view)
        
        struct StaticStruct {
            static var firstTouch:CGPoint = .zero
            static var d:CGFloat = 0
            static var animDirector:AAPTransactionDirector? = nil
            
            static func clean(){
                d = 0
                firstTouch = .zero
                animDirector = nil
            }
        }
        
        switch state {
        case .began:
            if (self.viewControllers.count<2) {
                StaticStruct.clean()
                return;
            }
            
            StaticStruct.animDirector = AAPTransactionDirector()
            StaticStruct.animDirector?.isInteractive=true
            StaticStruct.animDirector?.duration = defaultRadialDuration
            self.delegate=StaticStruct.animDirector
            
            self.popViewController(animated: true)
            
            self.delegate=nil
            
            
            StaticStruct.d =  sqrt(pow(self.visibleViewController?.view.frame.size.width ?? 0, 2)+pow(self.visibleViewController?.view.frame.size.height ?? 0, 2) )*2
            
            StaticStruct.firstTouch = location
       
             StaticStruct.animDirector?.animationBlock={(transactionContext:UIViewControllerContextTransitioning, animationTime: CGFloat, completion:()->Void)->Void in
                
                 let toViewController = transactionContext.viewController(forKey: .to)
                 let fromViewController = transactionContext.viewController(forKey: .from)
                 let containerView = transactionContext.containerView
                 if let fromViewController = fromViewController, let toViewController = toViewController {
                     containerView.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
                     
                     let maskLayer = CAShapeLayer()
                     let maskRect = CGRect(x: location.x-location.x/2, y: location.y-location.x/2, width: 0, height: 0)
                     let path = CGPath(ellipseIn: maskRect, transform: nil)
                     maskLayer.path=path
                     toViewController.view.layer.mask = maskLayer
                 }
            }
            
        case .changed:
            StaticStruct.animDirector?.interactiveUpdateBlock={(transactionContext:UIViewControllerContextTransitioning, percent: CGFloat)->Void in
                
                if let maskLayer:CAShapeLayer = transactionContext.viewController(forKey: .to)?.view.layer.mask as? CAShapeLayer {
                    let mainD = percent * StaticStruct.d
                    
                    let maskRect : CGRect = CGRect(x: -mainD/2, y: location.y-mainD/2, width: mainD, height: mainD)
                    let path = CGPath(ellipseIn: maskRect, transform: nil)
                    maskLayer.path=path
                }
            }
            
            let mainD = location.x*StaticStruct.d/self.view.frame.size.width
            
            StaticStruct.animDirector?.precent=mainD/StaticStruct.d
         
        default:
            
            let mainD  =  location.x*StaticStruct.d/self.view.frame.size.width;
            
            let canceled = mainD>StaticStruct.d*0.5 ? false : true;
            
            StaticStruct.animDirector?.endInteractiveTranscation(canceled: canceled, endBlock: { () -> Void in
                StaticStruct.clean()
            })
        }
    }
}






