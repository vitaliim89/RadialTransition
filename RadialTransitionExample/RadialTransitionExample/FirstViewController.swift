import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.enableRadialSwipe()
        self.title="First ViewController"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func simplePush(sender: UIButton) {
        
        self.navigationController?.radialPushViewController(viewController: SecondViewController(nibName: "SecondViewController", bundle: nil),transitionCompletion: { () -> Void in
            
            
            
            })
        
    }
    
    @IBAction func customFrame1(sender: UIButton) {
        self.navigationController?.radialPushViewController(viewController: SecondViewController(nibName: "SecondViewController", bundle: nil), duration: 0.9, startFrame: sender.frame, transitionCompletion: {
            
        })
    }

    @IBAction func customFrame2(sender: UIButton) {
        self.navigationController?.radialPushViewController(viewController: SecondViewController(nibName: "SecondViewController", bundle: nil), duration: 0.9, startFrame: CGRect(x: self.view.frame.size.width, y: 0, width: 0, height: 0), transitionCompletion: {
            
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
