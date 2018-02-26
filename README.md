# iPad Scroll Position Fix

[Radar 37650722](https://openradar.appspot.com/radar?id=5505691045330944) describes the following bug (as of iOS 11.2.6):

1. Create an app with a simple UITableView with enough rows to require scrolling. (I use UITableView as an easy example, but this happens with any UIScrollView.)
2. Run that app on an iPad.
3. Put the iPad in landscape orientation.
4. Scroll to the bottom of the table.
5. Press the home button to leave the app.
6. Open the app again.

*Expected Results:* I would expect the table view to remain scrolled to the bottom.

*Actual Results:* The table view is no longer scrolled to the bottom.

This project demonstrates the issue. It also includes the code I used to address this in [Unread](https://www.goldenhillsoftware.com/unread/).

To incorporate the fix in your app, do the following:

1. Copy GHSScrollPositionFix.swift into your project.

2. Add a GHSScrollPositionFix to your view controller.

````
var scrollPositionFix: GHSScrollPositionFix?
````

3. In your viewDidLoad method, create the scroll position fix:

````
self.scrollPositionFix = GHSScrollPositionFix(scrollView: self.tableView)
````

4. Call the viewWillTransition method of scrollPositionFix from the viewWillTransition method of the view controller:

````
override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    self.scrollPositionFix?.viewWillTransition(to: size, with: coordinator)
}
````

The code can be used from Swift or from Objective-C.

Pull requests welcome.