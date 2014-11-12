
import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource
{
    var pageViewController : UIPageViewController?
    var pageTitles : Array<String> = ["God vs Man", "Cool Breeze"]
    var currentIndex : Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageViewController!.dataSource = self
        
        let startingViewController: SlashViewController = viewControllerAtIndex(0)!
        let viewControllers: NSArray = [startingViewController]
        pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
        pageViewController!.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        
        addChildViewController(pageViewController!)
        view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as SlashViewController).pageIndex
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as SlashViewController).pageIndex
        
        if index == NSNotFound {
            return nil
        }
        
        index++
        
        if (index == self.pageTitles.count) {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> SlashViewController?
    {
        if self.pageTitles.count == 0 || index >= self.pageTitles.count
        {
            return nil
        }
        
        var pageContentViewController:SlashViewController;
        if(index == 0){
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            pageContentViewController = storyboard.instantiateViewControllerWithIdentifier("form-table") as FormViewController;
        }
        else if(index==1){
            //println("la")
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            pageContentViewController = storyboard.instantiateViewControllerWithIdentifier("address-table") as TableViewController;
            //pageContentViewController = TableViewController()
        }else{
            pageContentViewController = SlashViewController()
        }
        // Create a new view controller and pass suitable data.
        
        pageContentViewController.titleText = pageTitles[index]
        pageContentViewController.pageIndex = index
        currentIndex = index
        
        return pageContentViewController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
}
