//
//  AppointmentsViewController.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/9/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//


import UIKit
import EventKit
import EventKitUI
import JTAppleCalendar
import BEMCheckBox

class AppointmentsViewController: UIViewController {
    var userAuth: UserAuth
    init(dataModel: DoctorSearchRowViewModel, userAuth: UserAuth) {
        self.userAuth = userAuth
        self.doctorDataModel = dataModel
        super.init(nibName: "AppointmentsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var doctorNameLabel: UILabel! {
        didSet {
            doctorNameLabel.text = doctorName
        }
    }
    
    @IBOutlet weak var calendarAndDaysEmbeddedView: UIView!
    @IBOutlet weak var calendarAndDaysHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarShade: UIView!
    @IBOutlet var calendarView: JTAppleCalendarView! {
        didSet {
            calendarView.backgroundColor = ibCollectionViewBackgroundColor
            setupCalendarView()
            
            calendarView.allowsMultipleSelection = false
        }
    }
    @IBOutlet weak var lengthOfTimeTextField: UITextField! {
        didSet {
            lengthOfTimeTextField.backgroundColor = .aetniaLightBlue
        }
    }
    @IBOutlet weak var servicePicker: UIPickerView! {
        didSet {
            servicePicker.setupShadow(opacity: 0.5, radius: 2, offset: CGSize(width: 0, height: 1), color: .aetniaBlue)
        }
    }
    @IBOutlet weak var calendarDaysStackView: UIStackView! {
           didSet {
            calendarDaysStackView.arrangedSubviews.forEach({
                if $0 is UILabel, let label = $0 as? UILabel {
                    label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
                }
            })
           }
       }
    
    @IBOutlet weak var timeSlotsShade: UIView!
    @IBOutlet weak var timeSlotsCollectionView: UICollectionView! {
        willSet {
            ibCollectionViewBackgroundColor = newValue.backgroundColor
        }
    }
    @IBOutlet weak var continueButton: UIButton! {
        didSet {
            continueButton.backgroundColor = UIColor.aetniaBlue.withAlphaComponent(0.3)
            continueButton.isEnabled = false
        }
    }
    @IBOutlet weak var timeSlotsTextView: UITextView!
    @IBOutlet weak var addEventCBLabel: UILabel!
    @IBOutlet weak var addEventToCalendarCheckBox: BEMCheckBox! {
        didSet {
            addEventToCalendarCheckBox.boxType = .square
            addEventToCalendarCheckBox.onCheckColor = .white
            addEventToCalendarCheckBox.onAnimationType = .bounce
            addEventToCalendarCheckBox.offAnimationType = .fade
            addEventToCalendarCheckBox.offFillColor = .clear
            addEventToCalendarCheckBox.onFillColor = .aetniaBlue
            addEventToCalendarCheckBox.onTintColor = .aetniaBlue
            addEventToCalendarCheckBox.tintColor = .aetniaBlue
            
        }
    }
    let store = EKEventStore()
    var eventsCalendarManager: EventsCalendarManager!
    
    var calendarCellsAreHidden = true
    var calendarHeader: AppointmentsCalendarHeader?
    var currentlySelectedDate: Date?
    var doctorName: String {
        get {
            "Dr. \(doctorDataModel!.doctorLastName)"
        }
    }
    var doctorDataModel: DoctorSearchRowViewModel!
    var serviceType: DoctorService {
        get {
            (doctorDataModel.docType == .physician ? (PhysicianServices.allCases[servicePicker.selectedRow(inComponent: 0)]) : (DentalServices.allCases[servicePicker.selectedRow(inComponent: 0)]))
            
        }
    }
    var timeSlotsDictionary = [Date:[String]]()
    var timeSlotsForCurrentDate = [String]() {
        willSet {
            if newValue.count > 0 {
                timeSlotsTextView.isHidden = true
            }else {
                timeSlotsTextView.isHidden = false
            }
        }
    }
    var ibCollectionViewBackgroundColor: UIColor!
    enum LeftOrRight {
        case left, right
    }
    
    @objc func arrowWasTapped(_ notification: Notification) {
        guard let leftOrRight = notification.userInfo as? [String:LeftOrRight] else { return }
        if leftOrRight.first?.value == .right {
            calendarView.scrollToSegment(.next)
        }else {
            calendarView.scrollToSegment(.previous)
        }
    }
    @IBAction func continueTapped(_ sender: Any) {
        if !(addEventToCalendarCheckBox.on) {
            
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .autoupdatingCurrent
        dateFormatter.dateFormat = "h:mm a, zzz"
        dateFormatter.timeZone = .autoupdatingCurrent
        var components = DateComponents()
        guard
            let idx = timeSlotsCollectionView.indexPathsForSelectedItems?.first,
            let cell = timeSlotsCollectionView.cellForItem(at: idx) as?  TimeSlotCollectionViewCell,
            var timeStr = cell.timeLabel.text,
            let startDate = self.currentlySelectedDate
            else { fatalError("WTF") }
        if let _ = Int(String(timeStr.prefix(2))) {
            timeStr.insert(contentsOf: " AM, PST", at: timeStr.endIndex)
        }else {
            timeStr.insert(contentsOf: " PM, PST", at: timeStr.endIndex)
        }

        print(timeStr)
        let tempDate = dateFormatter.date(from: timeStr)
        dateFormatter.dateFormat = "HH:mm a, zzz"
        let twentyFourDateStr = dateFormatter.string(from: tempDate!)
        print(twentyFourDateStr)
        
        //switch formatter to deal with calendarView cell
        dateFormatter.dateFormat = "MM-dd-yyyy"
        var strDate = dateFormatter.string(from: startDate)
        strDate.insert(contentsOf: " \(twentyFourDateStr)", at: strDate.endIndex)
        
        components.hour = Calendar.current.component(Calendar.Component.hour, from: tempDate!)
        components.minute = Calendar.current.component(.minute, from: tempDate!)
        components.day = Calendar.current.component(.day, from: startDate)
        components.month = Calendar.current.component(.month, from: startDate)
        components.year = Calendar.current.component(.year, from: startDate)
        components.timeZone = .current

        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm a, zzz"
        let finalStartDate = Calendar.current.date(from: components)
        dateFormatter.dateFormat = "h:mm a"
        let shortTime = dateFormatter.string(from: finalStartDate!)
        
        DispatchQueue.main.async {
            
            let event = EKEvent(eventStore: self.store)
            let serviceDescription: String = {
                
                if self.doctorDataModel.docType == .physician {
                    let service = self.serviceType as! PhysicianServices
                    return service.getDescriptionForService()
                }else {
                    let service = self.serviceType as! DentalServices
                    return service.getDescriptionForService()
                }
            }()
            event.title = "\(serviceDescription) w/ \(self.doctorName) at \(shortTime)"
            event.calendar = self.store.defaultCalendarForNewEvents
            event.startDate = finalStartDate
            event.endDate = finalStartDate
            event.notes = "Scheduled using the Aetnia app"
            
            let appt = Appointment(date: event.startDate, doctor: self.doctorDataModel.doctor, service: self.serviceType)
            self.userAuth.loggedInUser.appointments.append(appt)
            let eventStruct = Event(store: self.store, event: event)
            self.eventsCalendarManager.presentCalendarModalToAddEvent(event: eventStruct, presenter: self, completion: {_ in})
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsCalendarManager = EventsCalendarManager(eventStore: self.store, presenter: self)
        calendarHeader = AppointmentsCalendarHeader()
        lengthOfTimeTextField.delegate = self
//        setupCalendarView()
        setupTimeSlotsCollectionView()
        servicePicker.selectRow(0, inComponent: 0, animated: false)
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(hidePicker))
        tapGest.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGest)
    }
    
    @objc func hidePicker() {
        servicePicker.resignFirstResponder()
        servicePicker.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        NotificationCenter.default.addObserver(self, selector: #selector(arrowWasTapped(_:)), name: .calendarLeftOrRight, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        print("VendorPageAppointmentVC - deinit")
    }
}

// EKEventEditViewDelegate
extension AppointmentsViewController: EKEventEditViewDelegate {
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        
        if action == .saved {
            let lbl = UILabel(frame: CGRect(origin: controller.view.convert(CGPoint(x: controller.view.frame.width / 2, y: controller.view.frame.height / 2), to: UIScreen.main.coordinateSpace), size: CGSize(width: 400, height: 100)))
            lbl.text = "SCHEDULED!"
            lbl.font = UIFont.boldSystemFont(ofSize: 32)
            lbl.textColor = .green
            lbl.alpha = 0
            controller.view.addSubview(lbl)
            lbl.centerInSuperview()
            
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                lbl.alpha = 1
            }) { (_) in
                UIView.animate(withDuration: 0.5, animations: {
                    lbl.alpha = 0
                }){ (_) in
                    UIView.animate(withDuration: 0.5, animations: {
                        lbl.removeFromSuperview()
                    }){ _ in
                        self.presentingViewController?.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}


extension  AppointmentsViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        servicePicker.isHidden = false
        servicePicker.becomeFirstResponder()
        return false
    }
}

extension AppointmentsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (doctorDataModel.docType == .physician ? PhysicianServices.allCases.count : DentalServices.allCases.count)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (doctorDataModel.docType == .physician ? PhysicianServices.allCases[row].rawValue : DentalServices.allCases[row].rawValue)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        lengthOfTimeTextField.text = (doctorDataModel.docType == .physician ? PhysicianServices.allCases[row].rawValue : DentalServices.allCases[row].rawValue)
        timeNeededChanged()
        pickerView.resignFirstResponder()
        pickerView.isHidden = true
    }
    
    func timeNeededChanged() {
        if lengthOfTimeTextField.text == "--" {
            continueButton.isEnabled = false
            lengthOfTimeTextField.backgroundColor = .aetniaLightBlue
            calendarView.backgroundColor = ibCollectionViewBackgroundColor
            calendarShade.isHidden = false
            timeSlotsShade.isHidden = false
            continueButton.backgroundColor = UIColor.aetniaBlue.withAlphaComponent(0.3)

            addEventCBLabel.alpha = 0.3
            addEventToCalendarCheckBox.alpha = 0.3
            
        }else {
            lengthOfTimeTextField.backgroundColor = ibCollectionViewBackgroundColor
            calendarShade.isHidden = true
            timeSlotsShade.isHidden = true

            addEventCBLabel.alpha = 1
            addEventToCalendarCheckBox.alpha = 1
            if timeSlotsCollectionView.indexPathsForSelectedItems != nil && !(timeSlotsCollectionView.indexPathsForSelectedItems!.isEmpty) {
                continueButton.isEnabled = true
                continueButton.backgroundColor = UIColor.aetniaBlue
            }else{
                if timeSlotsCollectionView.numberOfItems(inSection: 0) == 0 {
                    calendarView.backgroundColor = .aetniaLightBlue
                }
            }
            
        }
    }
}

extension AppointmentsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func setupTimeSlotsCollectionView() {
        timeSlotsCollectionView.register(TimeSlotCollectionViewCell.self, forCellWithReuseIdentifier: TimeSlotCollectionViewCell.reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: layout.collectionView?.frame.width ?? 200 / 4, height: 40)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        
        timeSlotsCollectionView.contentInset = UIEdgeInsets(top: 4, left: 2, bottom: 4, right: 2)
        
        timeSlotsCollectionView.collectionViewLayout = layout
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return timeSlotsForCurrentDate.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeSlotCollectionViewCell.reuseIdentifier, for: indexPath) as! TimeSlotCollectionViewCell
        
        cell.timeLabel.text = timeSlotsForCurrentDate[indexPath.item]
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if collectionView.indexPathsForSelectedItems?.first != nil && collectionView.indexPathsForSelectedItems?.first == indexPath {
            collectionView.deselectItem(at: indexPath, animated: true)
            collectionView.backgroundColor = .aetniaLightBlue
            continueButton.backgroundColor = UIColor.aetniaBlue.withAlphaComponent(0.3)
            continueButton.isEnabled = false
            return false
        }
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.backgroundColor = ibCollectionViewBackgroundColor
        continueButton.isEnabled = true
        continueButton.backgroundColor = .aetniaBlue
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
    
    
}

extension AppointmentsViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func returnTimesForSelectedDate(_ date: Date) -> [String] {
        var times = [
            "08:00","08:15","08:30","08:45",
            "09:00","09:15","09:30","09:45",
            "10:00","10:15","10:30","10:45",
            "11:00","11:15","11:30", "11:45",
            "1:00","1:15","1:30", "1:45",
            "2:00","2:15","2:30", "2:45",
            "3:00","3:15","3:30", "3:45",
            "4:00", "4:15", "4:30",
        ].shuffled()
        
        let num = Int(arc4random_uniform(UInt32(times.count - 1)))
        
        for _ in 0..<num {
            times.removeFirst()
        }
        
        return times.sorted()
        
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM DD YYYY"
        
        let config = ConfigurationParameters(startDate: Date(), endDate: dateFormatter.date(from: "Apr 01 2060")!, numberOfRows: 6, calendar: Calendar.current, generateInDates: .forAllMonths, generateOutDates: .off, firstDayOfWeek: .sunday, hasStrictBoundaries: true)
        
        return config
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! CalendarViewCell
        
        configureCell(cell: cell, cellState: cellState)
        
    }
    
    
    private func setupCalendarView() {
        
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        
        calendarView.minimumLineSpacing = 4
        calendarView.minimumInteritemSpacing = 4
        
        calendarView.allowsMultipleSelection = false
        
//        calendarView.register(UINib(nibName: "CalendarHeaderView", bundle: .main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CalendarHeaderView")
        calendarView.register(AppointmentsCalendarHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "AppointmentsCalendarHeader")
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarHeader?.isCurrentMonth = true
        
        calendarView.register(UINib(nibName: "CalendarViewCell", bundle: .main), forCellWithReuseIdentifier: "CalendarViewCell")
        calendarView.scrollingMode = .stopAtEachSection
        //calendarView.backgroundColor = .aetniaLightBlue
        
        calendarView.showsVerticalScrollIndicator = false
        calendarView.showsHorizontalScrollIndicator = true
                
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendarView.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarViewCell", for: indexPath) as! CalendarViewCell
        configureCell(cell: cell, cellState: cellState)
        return cell
    }
    
    func configureCell(cell: JTAppleCell?, cellState: CellState) {
        guard let currentCell = cell as? CalendarViewCell else { return }
        configureSelectedStateFor(cell: cell, cellState: cellState)
        configureTextColorFor(cell: cell, cellState: cellState)
        currentCell.dateLabel.text = " " + cellState.text
        
//        if !(currentCell.dateLabel?.textColor == .white) {
//            currentCell.contentView.layer.cornerRadius = 4.0
//            currentCell.contentView.layer.borderWidth = 1.0
//            currentCell.contentView.layer.borderColor = UIColor.clear.cgColor
//            currentCell.contentView.layer.masksToBounds = true
//
//            currentCell.layer.shadowColor = UIColor.aetniaBlue.cgColor
//            currentCell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
//            currentCell.layer.shadowRadius = 1.0
//            currentCell.layer.shadowOpacity = 1.0
//            currentCell.layer.masksToBounds = false
//            currentCell.layer.shadowPath = UIBezierPath(roundedRect: currentCell.bounds, cornerRadius: currentCell.contentView.layer.cornerRadius).cgPath
//            currentCell.layer.backgroundColor = UIColor.white.cgColor
//        }
        
        currentCell.dateLabel.textAlignment = .center
        let cellHidden = cellState.dateBelongsTo != .thisMonth && calendarCellsAreHidden
        currentCell.selectedView.transform = CGAffineTransform(scaleX: 1, y: 0.70)
        currentCell.isHidden = cellHidden
        
    }
    
    func configureTextColorFor(cell: JTAppleCell?, cellState: CellState) {
        guard let currentCell = cell as? CalendarViewCell else { return }
        DispatchQueue.main.async {
            if [DaysOfWeek.sunday, DaysOfWeek.saturday].contains(cellState.day) {
                currentCell.dateLabel.textColor = .darkGray //.appColor(.bbGrey)
                currentCell.selectedView.backgroundColor = .clear
                currentCell.dateLabel.font = UIFont.systemFont(ofSize: 17)
            }else if cellState.isSelected && (cellState.date >= Date() || Calendar.current.isDateInToday(cellState.date)){
                currentCell.dateLabel.textColor = .white
                currentCell.selectedView.backgroundColor = .aetniaBlue
                currentCell.dateLabel.font = UIFont.boldSystemFont(ofSize: 17)
                
                currentCell.contentView.layer.cornerRadius = 10.0
                currentCell.contentView.layer.borderWidth = 1.0
                currentCell.contentView.layer.borderColor = UIColor.clear.cgColor
                currentCell.contentView.layer.masksToBounds = true
                
                currentCell.layer.shadowColor = UIColor.aetniaBlue.cgColor
                currentCell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
                currentCell.layer.shadowRadius = 1.0
                currentCell.layer.shadowOpacity = 1.0
                currentCell.layer.masksToBounds = false
                currentCell.layer.shadowPath = UIBezierPath(roundedRect: currentCell.bounds, cornerRadius: currentCell.contentView.layer.cornerRadius).cgPath
                currentCell.layer.backgroundColor = UIColor.white.cgColor
            }else {
                if cellState.dateBelongsTo == .thisMonth && cellState.date >= Date() || Calendar.current.isDateInToday(cellState.date) {
                    currentCell.backgroundColor = .clear
                    currentCell.selectedView.backgroundColor = .white
                    
                    if ![DaysOfWeek.sunday, DaysOfWeek.saturday].contains(cellState.day) {
                        currentCell.contentView.layer.cornerRadius = 10.0
                        currentCell.contentView.layer.borderWidth = 1.0
                        currentCell.contentView.layer.borderColor = UIColor.clear.cgColor
                        currentCell.contentView.layer.masksToBounds = true
                        
                        currentCell.layer.shadowColor = UIColor.aetniaBlue.cgColor
                        currentCell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
                        currentCell.layer.shadowRadius = 1.0
                        currentCell.layer.shadowOpacity = 1.0
                        currentCell.layer.masksToBounds = false
                        currentCell.layer.shadowPath = UIBezierPath(roundedRect: currentCell.bounds, cornerRadius: currentCell.contentView.layer.cornerRadius).cgPath
                        currentCell.layer.backgroundColor = UIColor.white.cgColor
                    }
                    currentCell.dateLabel.textColor = .aetniaBlue
                    currentCell.dateLabel.font = UIFont.systemFont(ofSize: 17)
                }else {
                    currentCell.dateLabel.textColor = .darkGray
                    currentCell.selectedView.backgroundColor = .clear
                    currentCell.dateLabel.font = UIFont.systemFont(ofSize: 17)
                }
                
                
            }
            //currentCell.backgroundColor = .clear
            //currentCell.backgroundView?.backgroundColor = .clear
        }
        
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 31)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "AppointmentsCalendarHeader", for: indexPath) as! AppointmentsCalendarHeader
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        header.monthLabel.text = dateFormatter.string(from: range.start)
        header.backgroundColor = .white
        
        header.addBorder(edge: .top, color: .aetniaBlue, thickness: 1, padding: nil)
        header.monthLabel.textColor = .aetniaBlue
        header.monthLabel.contentMode = .center
        
        if range.start.hasSame(.init(arrayLiteral: .month), as: Date()) {
            header.isCurrentMonth = true
        }else {
            header.isCurrentMonth = false
        }
        
        return header
    }
    
    func configureSelectedStateFor(cell: JTAppleCell?, cellState: CellState) {
        guard let currentCell = cell as? CalendarViewCell else { return }
        
        if cellState.isSelected {
            configureTextColorFor(cell: cell, cellState: cellState)
            currentCell.selectedView.isHidden = false
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        if calendar.selectedDates.contains(date) {
            calendar.deselectAllDates()
            return false
        }else if ([DaysOfWeek.sunday, DaysOfWeek.saturday].contains(cellState.day)) {
            return false
        } else {
            return true
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        self.currentlySelectedDate = date
        if timeSlotsDictionary[date] == nil {
            timeSlotsDictionary[date] = returnTimesForSelectedDate(date)
        }
        //timeSlotsForCurrentDate = timeSlotsDictionary[date] ?? []
        configureCell(cell: cell, cellState: cellState)
        calendar.backgroundColor = ibCollectionViewBackgroundColor
        continueButton.isEnabled = false
        continueButton.backgroundColor = UIColor.aetniaBlue.withAlphaComponent(0.3)
        timeSlotsCollectionView.backgroundColor = .aetniaLightBlue
        timeSlotsCollectionView.performBatchUpdates({
            
            timeSlotsForCurrentDate = timeSlotsDictionary[date] ?? []
            
            for i in (0...timeSlotsForCurrentDate.count - 1) {
                timeSlotsCollectionView.insertItems(at: [IndexPath(item: i, section: 0)])
            }
        }, completion: { _ in
            self.timeSlotsCollectionView.scrollToItem(at: [0,0], at: .top, animated: true)
        })
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
        calendar.backgroundColor = .aetniaLightBlue
        timeSlotsCollectionView.backgroundColor = ibCollectionViewBackgroundColor
        timeSlotsCollectionView.performBatchUpdates({
            timeSlotsForCurrentDate.removeAll()
            for i in 0..<timeSlotsCollectionView.numberOfItems(inSection: 0) {
                timeSlotsCollectionView.deleteItems(at: [IndexPath(item: i, section: 0)])
            }
        }, completion: nil)
    }
    

}


