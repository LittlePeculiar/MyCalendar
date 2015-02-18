import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var calendarCollView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var monthImage: UIImageView!
    
    var daysArray: [String] = []
    var monthsArray: [String] = []
    var monthIndex: Int = 0
    var lastImageNbr = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components( .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitWeekday, fromDate: date)
        let month = components.month
        
        monthLabel.text = getMonthAtIndex(month-1)
        monthIndex = month-1    // components start at index 1
        loadCalendayDays()      // for current month
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func getMonthAtIndex(index: Int) -> String {
        
        if monthsArray.count == 0 {
            
            monthsArray = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        }
        return self.monthsArray[index]
    }
    
    func loadCalendayDays() {
        
        // Setup the calendar object
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        
        // Create an NSDate for the first and last day of the month
        var components2 = calendar.components(NSCalendarUnit.CalendarUnitYear |
            NSCalendarUnit.CalendarUnitMonth |
            NSCalendarUnit.CalendarUnitWeekday |
            NSCalendarUnit.CalendarUnitDay,
            fromDate: date)
        
        // Get First and Last date of the month
        components2.month = monthIndex + 1
        components2.day = 1
        let firstDateOfMonth: NSDate = calendar.dateFromComponents(components2)!
        components2.month  += 1
        let lastDateOfMonth: NSDate = calendar.dateFromComponents(components2)!
        println("first of month: \(firstDateOfMonth)")
        println("last of month: \(lastDateOfMonth)")
        
        // get number of days in month
        let unit:NSCalendarUnit = .DayCalendarUnit
        let components3 = calendar.components(unit, fromDate: firstDateOfMonth, toDate: lastDateOfMonth, options: nil)
        println("number of days in month \(components3.day)")
        
        // get the day for the first of the month
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var firstDayString = dateFormatter.stringFromDate(firstDateOfMonth)
        var weekDay = 0
        if let firstDate = dateFormatter.dateFromString(firstDayString) {
            let myComponents = calendar.components(.WeekdayCalendarUnit, fromDate: firstDate)
            weekDay = myComponents.weekday
            println("first was on a: \(weekDay)")
        }
        else {
            println("first day is nil")
        }
        
        var firstWeekDay = weekDay
        var numberOfDaysInMonth = components3.day
        var totalDays = numberOfDaysInMonth + firstWeekDay
        
        daysArray.removeAll(keepCapacity: true)
        var index = 1
        for var i = 1; i < totalDays; i++ {
            if i < weekDay {
                daysArray.append("0")
            }
            else {
                daysArray.append("\(index++)")
            }
        }
        
        self.calendarCollView.reloadData()
        
        // and add a random image
        loadRandomImage()
    }
    
    func loadRandomImage() {
        
        let randomImageNbr = Int(arc4random_uniform(22)+1)
        if randomImageNbr == lastImageNbr {
            
            println("duplicate randomImageNbr: \(randomImageNbr)")
            loadRandomImage()
        }
        
        if randomImageNbr > 0 && randomImageNbr <= 22 {
            
            var imageName = "\(randomImageNbr).jpg"
            let image = UIImage(named: imageName)
            self.monthImage.image = image
            lastImageNbr = randomImageNbr
        }
        else {
            let image = UIImage(named: "1.jpg")
            self.monthImage.image = image
        }
    }
    
    
    @IBAction func showPrevMonth(sender: UIButton) {
        if monthIndex > 0 {
            monthLabel.text = getMonthAtIndex(monthIndex-1)
            monthIndex--
            
            loadCalendayDays()
        }
    }
    
    @IBAction func showNextMonth(sender: UIButton) {
        if monthIndex < monthsArray.count-1 {
            monthLabel.text = getMonthAtIndex(monthIndex+1)
            monthIndex++
            
            loadCalendayDays()
        }
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CalendarCell", forIndexPath: indexPath) as CalendarCell
        
        var day = daysArray[indexPath.row] as NSString
        if day == "0"
        {
            cell.dayLabel.hidden = true
        }
        else {
            cell.dayLabel.hidden = false
            cell.dayLabel.text = day
        }
        
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CalendarCell {
            
        }
        
    }
    
}