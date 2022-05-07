import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(popAction))
      self.title="Second ViewController"
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func popAction() {
        
    }
    
    @IBAction func simplePop(sender: UIButton) {
        self.navigationController?.radialPopViewController()
    }

    @IBAction func cutimFrame1(sender: UIButton) {
        self.navigationController?.radialPopViewController(duration: 0.9, startFrame: .zero)
    }
    
    @IBAction func customFrame2(sender: UIButton) {
        self.navigationController?.radialPopViewController(duration: 0.9, startFrame: CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height, width: 0, height: 0))
    }

}
