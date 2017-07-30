//
//  MPPersianDatePicker.swift
//  Pods
//
//  Created by Admin on 4/23/1396 AP.
//
//

import UIKit
import JTAppleCalendar
import PopupDialog
//import MPCalendar

extension DateFormatter{
    
    var persianMonthSymbols: [String] { get { return ["فروردين", "اردیبهشت", "خرداد", "تير", "مرداد", "شهريور", "مهر", "آبان", "آذر", "دي", "بهمن", "اسفند"]} }
}

extension UIColor{
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

public struct MPDate {
    public var persianDate : String
    public var time : String
    public var gregorianDate : String
}

// A class to select a date a time with prettier UI
public class MPPersianDatePicker: UIViewController
{
    // the popup that this picker is contained in
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    var popup: PopupDialog!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    
    // the time selection agent
    @IBOutlet var timePicker: UIDatePicker!
    
    // Handles 'saving'
    var handler: ((MPDate?)->Void)?
    
    var numberOfRows = 5
    let formatter = DateFormatter()
    var testCalendar = Calendar.current
    var generateInDates: InDateCellGeneration = .forAllMonths
    var generateOutDates: OutDateCellGeneration = .off//.tillEndOfRow
    var prePostVisibility: ((CellState, CellView?)->())?
    var hasStrictBoundaries = true
    let firstDayOfWeek: DaysOfWeek = .saturday
    let disabledColor = UIColor.lightGray
    let enabledColor = UIColor.blue
    let dateCellSize: CGFloat? = nil
    var monthSize: MonthSize? = nil
    var prepostHiddenValue = false
    
    let red = UIColor.red
    let white = UIColor.white
    let black = UIColor.black
    let gray = UIColor.gray
    
    let persianTimeZone = TimeZone(identifier: "Asia/Tehran")!
    let persianLocale = Locale(identifier: "fa_IR")
    
    let todayPersianDate = MPCalendar.getCurrentPersianDate()
    public static var defaultDate : Date?
    var selectedIndexPath : IndexPath?
    var currentCell : JTAppleCell?
    
    override public func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        if UIDevice.current.model.hasPrefix("iPad") {
            // self.calendarHeightConstraint.constant = 400
        }
        
        testCalendar = Calendar(identifier: .persian)
        
        testCalendar.timeZone = persianTimeZone
        
        testCalendar.locale = persianLocale
        
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self
        
        calendarView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        self.calendarView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        
        calendarView.minimumLineSpacing = 1
        calendarView.minimumInteritemSpacing = 1
        
        
        
        
        // todayPressed()
    }
    
    @IBAction func next(_ sender: Any) {
        self.calendarView.scrollToSegment(.next)
        //calendarView.collectionView(calendarView, didDeselectItemAt : oldSelectedIndexPath!)
        //let oldCell = calendarView.cellForItem(at: oldSelectedIndexPath!) as! CellView
        /*if currentCell != nil{
           currentCell!.layer.borderColor = UIColor.rgb(red: 183, green: 183, blue: 183).cgColor
        }
        
        
        calendarView.collectionView(calendarView, didSelectItemAt: selectedIndexPath!)
        let cell = calendarView.cellForItem(at: selectedIndexPath!) as! CellView
        cell.layer.borderColor = UIColor.rgb(red: 221, green: 46, blue: 53).cgColor*/
    }
    
    
    @IBAction func previous(_ sender: Any) {
        self.calendarView.scrollToSegment(.previous)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
    }
    /**
     Dismisses the view controller with no changes made
     */
    @IBAction func cancelPressed()
    {
        popup.dismiss(animated: true, completion: nil)
    }
    
    /**
     Simulates a clear by performing the handler with a nil date
     */
    @IBAction func clearPressed()
    {
        if let completion = handler
        {
            completion(nil)
        }
        
        popup.dismiss(animated: true, completion: nil)
    }
    
    /**
     Called when a user presses the today button. Sets the time and date to
     today.
     */
    @IBAction func todayPressed()
    {
        let today = Date()
        set(date: today)
    }
    
    /**
     Gathers the selected date and performs the handler with it
     */
    @IBAction func donePressed()
    {
        if let completion = handler
        {
            let date = selectedDate()
            popup.dismiss(animated: true, completion: nil)
            completion(date)
        }
        else
        {
            popup.dismiss(animated: true, completion: nil)
        }
    }
    
    /**
     Sets the date
     - to: the date to set to
     */
    func set(date to: Date)
    {
        calendarView.scrollToDate(to)
        timePicker.setDate(to, animated: true)
    }
    
    /**
     Compiles the components into a date object
     - returns:
     - a formatted date from the components
     */
    func selectedDate() -> MPDate
    {
        
        let timeFormatter = DateFormatter()
        //timeFormatter.timeZone = persianTimeZone
        //timeFormatter.locale = persianLocale
        timeFormatter.dateFormat = "h:s"
        
        let gregorianDateFormatter = DateFormatter()
        gregorianDateFormatter.dateFormat = "yyyyMMdd"
        
        let persianDateFormatter = DateFormatter()
        persianDateFormatter.timeZone = persianTimeZone
        persianDateFormatter.locale = persianLocale
        persianDateFormatter.dateFormat = "yyyyMMdd"
        
        if calendarView.selectedDates.count > 0 {
            let currentDates = calendarView.selectedDates
            let mpDate = MPDate(persianDate: persianDateFormatter.string(from: currentDates[0]) , time: timeFormatter.string(from: timePicker.date), gregorianDate: gregorianDateFormatter.string(from: currentDates[0]))
            
            return mpDate
        }
        else{
            return MPDate(persianDate: "", time: "", gregorianDate: "")
        }
    }
    
    
    
    /**
     Static function to instantiate the ViewController on top of an existing
     - parameters:
     - viewController: the view controller to present on top of
     - date: the date to display
     - handler: the function to handle completion
     */
    
    @IBAction func btnTodayDate(_ sender: Any) {
        scrollToTodayDate()
    }
    open class func show(on viewController: UIViewController,
                         with date: Date? = nil,
                         handledBy handler: ((MPDate?)->Void)? = nil) -> MPPersianDatePicker
    {
        
        let urlString = Bundle.main.path(forResource: "MPPersianDatePicker", ofType: "framework", inDirectory: "Frameworks")
        
        let frameworkBundle = Bundle(url: URL(fileURLWithPath: urlString!))
        
        let bundleURL = frameworkBundle?.resourceURL?.appendingPathComponent("MPPersianDatePicker.bundle")
        
        let resourceBundle = Bundle(url: bundleURL!)
        
        
        
        let storyboard: UIStoryboard = UIStoryboard(name: "MPPersianDatePicker", bundle: resourceBundle)
        let mpPersianDatePicker = storyboard.instantiateViewController(withIdentifier: "MPPersianDatePicker") as! MPPersianDatePicker
        
        let popup = PopupDialog.init(viewController: mpPersianDatePicker, gestureDismissal: false)
        mpPersianDatePicker.popup = popup
        
        viewController.present(popup, animated: true, completion: nil)
        
        mpPersianDatePicker.handler = handler
        if date != nil
        {
            mpPersianDatePicker.set(date: date!)
        }
        
        
        
        return mpPersianDatePicker
        
    }
    
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first?.date else {
            return
        }
        let month = testCalendar.dateComponents([.month], from: startDate).month!
        let monthName = DateFormatter().persianMonthSymbols[(month-1) % 12]
        // 0 indexed array
        let year = testCalendar.component(.year, from: startDate)
        monthLabel.text = monthName + " " + convertEngNumToPersianNum(num: String(year))
    }
    
    func handleCellConfiguration(cell: JTAppleCell?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        prePostVisibility?(cellState, cell as? CellView)
    }
    
    // Function to handle the text color of the calendar
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = view as? CellView  else {
            return
        }
        
        if cellState.isSelected {
            //myCustomCell.dayLabel.textColor = white
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                if cellState.day == .friday{
                    myCustomCell.dayLabel.textColor = red
                }else{
                    myCustomCell.dayLabel.textColor = black
                }
                
            } else {
                myCustomCell.dayLabel.textColor = gray
            }
        }
    }
    
    // Function to handle the calendar selection
    func handleCellSelection(view: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = view as? CellView else {return }
        //        switch cellState.selectedPosition() {
        //        case .full:
        //            myCustomCell.backgroundColor = .green
        //        case .left:
        //            myCustomCell.backgroundColor = .yellow
        //        case .right:
        //            myCustomCell.backgroundColor = .red
        //        case .middle:
        //            myCustomCell.backgroundColor = .blue
        //        case .none:
        //            myCustomCell.backgroundColor = nil
        //        }
        //
        
        
        if cellState.isSelected {
            myCustomCell.layer.borderColor = UIColor.rgb(red: 221, green: 46, blue: 53).cgColor
        } else {
            myCustomCell.layer.borderColor = UIColor.rgb(red: 183, green: 183, blue: 183).cgColor
        }
        
    }
    
    func convertEngNumToPersianNum(num: String)->String{
        let number = NSNumber(value: Int(num)!)
        let format = NumberFormatter()
        format.locale = Locale(identifier: "fa_IR")
        let faNumber = format.string(from: number)
        
        return faNumber!
    }
    
    
    func scrollToTodayDate()  {
        
        let dateCurrent = self.formatter.date(from: "\(self.todayPersianDate.year) \(self.todayPersianDate.month) \(self.todayPersianDate.day)")!
        self.calendarView.scrollToDate(dateCurrent)
    }
    
    
}



// MARK : JTAppleCalendarDelegate
extension MPPersianDatePicker: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    public func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = testCalendar.timeZone
        formatter.locale = testCalendar.locale
        
        
        let startDate = formatter.date(from: "1300 01 01")!
        let endDate = formatter.date(from: "\(todayPersianDate.year + 2) 12 29")!
        
        
        scrollToTodayDate()
        
        
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: numberOfRows,
                                                 calendar: testCalendar,
                                                 generateInDates: generateInDates,
                                                 generateOutDates: generateOutDates,
                                                 firstDayOfWeek: firstDayOfWeek,
                                                 hasStrictBoundaries: hasStrictBoundaries)
        return parameters
    }
    
    public func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let myCustomCell = calendar.dequeueReusableCell(withReuseIdentifier: "CellView", for: indexPath) as! CellView
        
        myCustomCell.dayLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        myCustomCell.dayLabel.text = convertEngNumToPersianNum(num: cellState.text)
        if testCalendar.isDateInToday(date) {
            myCustomCell.backgroundColor = UIColor.rgb(red: 194, green: 224, blue: 217)
        } else {
            myCustomCell.backgroundColor = white
        }
        
        myCustomCell.layer.borderWidth = 1.0
        myCustomCell.layer.borderColor = UIColor.rgb(red: 183, green: 183, blue: 183).cgColor
        handleCellConfiguration(cell: myCustomCell, cellState: cellState)
        
        if MPPersianDatePicker.defaultDate != nil{
            let compareDefaultResult = testCalendar.compare(date, to: MPPersianDatePicker.defaultDate!, toGranularity: .day)
            
            if compareDefaultResult.rawValue == 0 {
                
                let stateCompare = testCalendar.compare(cellState.date, to: MPPersianDatePicker.defaultDate!, toGranularity: .day)
                if stateCompare.rawValue == 0 /*&& cellState.isSelected*/ {
                   // myCustomCell.layer.borderColor = UIColor.rgb(red: 221, green: 46, blue: 53).cgColor
                    selectedIndexPath = indexPath
                    //calendarView.collectionView(calendarView, didSelectItemAt: indexPath)
                    //calendarView.collectionView(calendarView, shouldSelectItemAt : indexPath)
                }
                
            }
        }
        
        let compareResult = testCalendar.compare(date, to: Date(), toGranularity: .day)
        if compareResult.rawValue < 0 {
            myCustomCell.isUserInteractionEnabled = false
            myCustomCell.backgroundColor = UIColor.rgb(red: 194, green: 194, blue: 194)
            //myCustomCell.dayLabel.textColor = white
        }else{
            myCustomCell.isUserInteractionEnabled = true
        }
        
        return myCustomCell
    }
    
    
    
    public func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellConfiguration(cell: cell, cellState: cellState)
    }
    
       
    public func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        currentCell = cell
        handleCellConfiguration(cell: cell, cellState: cellState)
    }
    
    public func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setupViewsOfCalendar(from: visibleDates)
    }
    
    public func scrollDidEndDecelerating(for calendar: JTAppleCalendarView) {
        let visibleDates = calendarView.visibleDates()
        //        let dateWeShouldNotCross = formatter.date(from: "2017 08 07")!
        //        let dateToScrollBackTo = formatter.date(from: "2017 07 03")!
        //        if visibleDates.monthDates.contains (where: {$0.date >= dateWeShouldNotCross}) {
        //            calendarView.scrollToDate(dateToScrollBackTo)
        //            return
        //        }
        self.setupViewsOfCalendar(from: visibleDates)
    }
    
    /*func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
     let date = range.start
     let month = testCalendar.component(.month, from: date)
     
     let header: JTAppleCollectionReusableView
     if month % 2 > 0 {
     header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "WhiteSectionHeaderView", for: indexPath)
     (header as! WhiteSectionHeaderView).title.text = formatter.string(from: date)
     } else {
     header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "PinkSectionHeaderView", for: indexPath)
     (header as! PinkSectionHeaderView).title.text = formatter.string(from: date)
     }
     return header
     }*/
    
    public func sizeOfDecorationView(indexPath: IndexPath) -> CGRect {
        let stride = calendarView.frame.width * CGFloat(indexPath.section)
        return CGRect(x: stride + 5, y: 5, width: calendarView.frame.width - 10, height: calendarView.frame.height - 10)
    }
    
    public func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return monthSize
    }
}

