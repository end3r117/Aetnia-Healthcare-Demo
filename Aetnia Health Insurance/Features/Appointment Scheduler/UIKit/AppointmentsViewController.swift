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
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var doctorNameLabel: UILabel = {
        let lbl = UILabel()
        
        lbl.text = doctorName
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    var chooseDateAndTimeLabel: UILabel = {
        let lbl = UILabel()
        
        lbl.text = "Choose an available date and time"
        lbl.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        return lbl
        
    }()

    var calendarShade: UIView = {
        let v = UIView()
        v.alpha = 0.5
        v.backgroundColor = .secondarySystemBackground
        
        return v
    }()
    
    lazy var calendarView: JTAppleCalendarView = {
        let cv = JTAppleCalendarView()
        cv.backgroundColor = ibCollectionViewBackgroundColor
        cv.scrollDirection = .horizontal
        cv.scrollingMode = .stopAtEachSection
        cv.allowsMultipleSelection = false
        
        return cv
    }()
    var serviceTextField: UITextField  = {
        let tf = UITextField()
        tf.backgroundColor = .aetniaLightBlue
        tf.text = "--"
        tf.textAlignment = .center
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.textColor = .label
        tf.layer.cornerRadius = 8
        
        return tf
    }()
    
    var servicePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .secondarySystemBackground
        picker.setupShadow(opacity: 0.5, radius: 2, offset: CGSize(width: 0, height: 1), color: .aetniaBlue)
        picker.isHidden = true
        picker.layer.cornerRadius = 8
        
        return picker
    }()
    var calendarDaysStackView: UIStackView = {
        let dayLabel = UILabel()
        dayLabel.font = .systemFont(ofSize: 16, weight: .medium)
        dayLabel.textAlignment = .center
        dayLabel.numberOfLines = 1
        dayLabel.textColor = .aetniaBlue
        let days = [UILabel](repeating: dayLabel, count: 7)
        
        days[0].text = "S"
        days[1].text = "M"
        days[2].text = "T"
        days[3].text = "W"
        days[4].text = "T"
        days[5].text = "F"
        days[6].text = "S"
        
        let stackView = UIStackView(arrangedSubviews: days)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        
        return stackView
    }()
    
    var timeSlotsShade: UIView = {
        let v = UIView()
        v.alpha = 0.5
        v.backgroundColor = .secondarySystemBackground
        
        return v
    }()
    
    var timeSlotsCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        cv.backgroundColor = .secondarySystemBackground
        
        return cv
    }()
    
    var continueButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Continue", for: .normal)
        btn.setTitleColor(.systemBackground, for: .normal)
        btn.backgroundColor = UIColor.aetniaBlue.withAlphaComponent(0.3)
        btn.layer.cornerRadius = 8
        btn.isEnabled = false
        
        return btn
    }()
    var timeSlotsTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont(name: "HelveticaNeue- LightItalic", size: 12)
        tv.textColor = UIColor.rgb(red: 74, green: 74, blue: 74, alpha: 0.7)
        tv.text = "Tap an available date on the calendar to see available time-slots."
        tv.textAlignment = .center
        tv.backgroundColor = .clear
        tv.isEditable = false
        tv.isUserInteractionEnabled = false
        tv.isSelectable = false
        
        return tv
    }()
    
    var addEventCBLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Also add event to Calendar"
        lbl.textColor = .darkGray
        lbl.font = .systemFont(ofSize: 12)
        lbl.alpha = 0.3
        
        return lbl
    }()
    
    var addEventToCalendarCheckBox: BEMCheckBox = {
        let cb = BEMCheckBox()
        cb.on = true
        cb.boxType = .square
        cb.onCheckColor = .white
        cb.onAnimationType = .bounce
        cb.offAnimationType = .fade
        cb.offFillColor = .clear
        cb.onFillColor = .aetniaBlue
        cb.onTintColor = .aetniaBlue
        cb.tintColor = .aetniaBlue
        
        return cb
    }()
    
    var scheduleAppointmentLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 19)
        lbl.text = "Schedule an appointment with"
        lbl.textAlignment = .center
        lbl.textColor = UIColor.rgb(red: 74, green: 74, blue: 74)
        
        return lbl
    }()
    
    var reasonForVisitLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 17)
        lbl.text = "Reason for your visit"
        lbl.textColor = .label
        
        return lbl
    }()
        
    var scrollView = UIScrollView()
    var contentView = UIView()
    var height: NSLayoutConstraint!
    
    let store = EKEventStore()
    var eventsCalendarManager: EventsCalendarManager!
    var constraintsForPortrait = [NSLayoutConstraint]()
    var constraintsForLandscape = [NSLayoutConstraint]()
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
    var ibCollectionViewBackgroundColor: UIColor = .secondarySystemBackground
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
    @objc func continueTapped(_ sender: Any) {
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
        scrollView = UIScrollView(frame: view.frame)
        servicePicker.delegate = self
        servicePicker.dataSource = self
        eventsCalendarManager = EventsCalendarManager(eventStore: self.store, presenter: self)
        calendarHeader = AppointmentsCalendarHeader()
        serviceTextField.delegate = self
        setupCalendarView()
        setupTimeSlotsCollectionView()
        //servicePicker.selectRow(0, inComponent: 0, animated: false)
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(hidePicker))
        tapGest.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGest)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRotationNotification(_:)), name: .rotationEngaged, object: nil)
        
        continueButton.addTarget(self, action: #selector(continueTapped(_:)), for: .touchUpInside)
        //scrollView.delegate = self
        fillConstraintsCollections()
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
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let str = (doctorDataModel.docType == .physician ? PhysicianServices.allCases[row].rawValue : DentalServices.allCases[row].rawValue)
        let attributes: [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 14, weight: .regular),
            .foregroundColor : UIColor.label
        ]
        let attrStr = NSAttributedString(string: str, attributes: attributes)
        
        return attrStr
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//
//
//        return (doctorDataModel.docType == .physician ? PhysicianServices.allCases[row].rawValue : DentalServices.allCases[row].rawValue)
//    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        serviceTextField.text = (doctorDataModel.docType == .physician ? PhysicianServices.allCases[row].rawValue : DentalServices.allCases[row].rawValue)
        timeNeededChanged()
        pickerView.resignFirstResponder()
        pickerView.isHidden = true
    }
    
    func timeNeededChanged() {
        if serviceTextField.text == "--" {
            continueButton.isEnabled = false
            serviceTextField.backgroundColor = .aetniaLightBlue
            calendarView.backgroundColor = ibCollectionViewBackgroundColor
            calendarShade.isHidden = false
            timeSlotsShade.isHidden = false
            continueButton.backgroundColor = UIColor.aetniaBlue.withAlphaComponent(0.3)

            addEventCBLabel.alpha = 0.3
            addEventToCalendarCheckBox.alpha = 0.3
            
        }else {
            serviceTextField.backgroundColor = ibCollectionViewBackgroundColor
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
        timeSlotsCollectionView.delegate = self
        timeSlotsCollectionView.dataSource = self
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
//            currentCell.view.safeAreaLayoutGuide.layer.cornerRadius = 4.0
//            currentCell.view.safeAreaLayoutGuide.layer.borderWidth = 1.0
//            currentCell.view.safeAreaLayoutGuide.layer.borderColor = UIColor.clear.cgColor
//            currentCell.view.safeAreaLayoutGuide.layer.masksToBounds = true
//
//            currentCell.layer.shadowColor = UIColor.aetniaBlue.cgColor
//            currentCell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
//            currentCell.layer.shadowRadius = 1.0
//            currentCell.layer.shadowOpacity = 1.0
//            currentCell.layer.masksToBounds = false
//            currentCell.layer.shadowPath = UIBezierPath(roundedRect: currentCell.bounds, cornerRadius: currentCell.view.safeAreaLayoutGuide.layer.cornerRadius).cgPath
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


extension AppointmentsViewController: UIScrollViewDelegate {
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        scrollView.contentOffset.x = 0
//    }
    
    @objc func handleRotationNotification(_ sender: Notification) {
        if let dict = sender.userInfo as? [String:Orientation] {
            let orientation = dict["orientation"]
            DispatchQueue.main.async {
                self.refreshConstraintsForNewOrientation(orientation!)
            }
        }
    }
    
    func refreshConstraintsForNewOrientation(_ orientation: Orientation) {
        NSLayoutConstraint.deactivate(constraintsForPortrait)
        NSLayoutConstraint.deactivate(constraintsForLandscape)
        
        orientation == .portrait ? (NSLayoutConstraint.activate(constraintsForPortrait)) : (NSLayoutConstraint.activate(constraintsForPortrait))
        
    }
    
    func fillConstraintsCollections() {
        view.addSubviews(views: scrollView, translatesAutoResizingMaskIntoConstraints: false)
        
        contentView.backgroundColor = .blue
        //contentView.removeFromSuperview()
        contentView = UIView(frame: view.frame)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubviews(views: contentView, translatesAutoResizingMaskIntoConstraints: false)
        
        contentView.addSubviews(views: chooseDateAndTimeLabel,calendarDaysStackView,calendarView,calendarShade,timeSlotsCollectionView,timeSlotsTextView,serviceTextField,timeSlotsShade,addEventToCalendarCheckBox,addEventCBLabel,scheduleAppointmentLabel,doctorNameLabel,reasonForVisitLabel,continueButton,servicePicker, translatesAutoResizingMaskIntoConstraints: false)
        
        
        height = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 860)//contentSizeForScrollView)
        height.priority = UILayoutPriority(rawValue: 999)
        constraintsForPortrait = [
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            height,
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            scheduleAppointmentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            scheduleAppointmentLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            scheduleAppointmentLabel.heightAnchor.constraint(equalToConstant: 25),
            scheduleAppointmentLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            
            
            doctorNameLabel.topAnchor.constraint(equalTo: scheduleAppointmentLabel.bottomAnchor, constant: 12),
            doctorNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            doctorNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            doctorNameLabel.heightAnchor.constraint(equalToConstant: 25),
            
            serviceTextField.topAnchor.constraint(equalTo: doctorNameLabel.bottomAnchor, constant: 20),
            serviceTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            serviceTextField.leadingAnchor.constraint(equalTo: contentView.centerXAnchor),
            serviceTextField.heightAnchor.constraint(equalToConstant: 40),
            
            servicePicker.topAnchor.constraint(equalTo: serviceTextField.topAnchor),
            servicePicker.leadingAnchor.constraint(equalTo: serviceTextField.leadingAnchor),
            servicePicker.trailingAnchor.constraint(equalTo: serviceTextField.trailingAnchor),
            servicePicker.heightAnchor.constraint(equalToConstant: 150),
            
            reasonForVisitLabel.centerYAnchor.constraint(equalTo: serviceTextField.centerYAnchor),
            reasonForVisitLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            reasonForVisitLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            chooseDateAndTimeLabel.topAnchor.constraint(equalTo: serviceTextField.bottomAnchor, constant: 8),
            chooseDateAndTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            chooseDateAndTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            chooseDateAndTimeLabel.heightAnchor.constraint(equalToConstant: 40),
            
            calendarDaysStackView.topAnchor.constraint(equalTo: chooseDateAndTimeLabel.bottomAnchor, constant: 8),
            calendarDaysStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            calendarDaysStackView.heightAnchor.constraint(equalToConstant: 18),
            calendarDaysStackView.widthAnchor.constraint(equalToConstant: 320),
            
            calendarView.widthAnchor.constraint(equalToConstant: 350),
            calendarView.heightAnchor.constraint(equalToConstant: 320),
            calendarView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            calendarView.topAnchor.constraint(equalTo: chooseDateAndTimeLabel.bottomAnchor, constant: 30),
            
            calendarShade.topAnchor.constraint(equalTo: calendarDaysStackView.topAnchor),
            calendarShade.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            calendarShade.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
            calendarShade.bottomAnchor.constraint(equalTo: calendarView.bottomAnchor),
            
            timeSlotsCollectionView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 30),
            timeSlotsCollectionView.heightAnchor.constraint(equalToConstant: 125),
            timeSlotsCollectionView.widthAnchor.constraint(equalTo: calendarView.widthAnchor, multiplier: 1),
            timeSlotsCollectionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            timeSlotsTextView.heightAnchor.constraint(equalToConstant: 54),
            timeSlotsTextView.widthAnchor.constraint(equalTo: timeSlotsCollectionView.widthAnchor, multiplier: 1),
            timeSlotsTextView.centerXAnchor.constraint(equalTo: timeSlotsCollectionView.centerXAnchor),
            timeSlotsTextView.centerYAnchor.constraint(equalTo: timeSlotsCollectionView.centerYAnchor),
            
            timeSlotsShade.widthAnchor.constraint(equalTo: timeSlotsCollectionView.widthAnchor, multiplier: 1),
            timeSlotsShade.heightAnchor.constraint(equalTo: timeSlotsCollectionView.heightAnchor, multiplier: 1),
            timeSlotsShade.centerYAnchor.constraint(equalTo: timeSlotsCollectionView.centerYAnchor),
            timeSlotsShade.centerXAnchor.constraint(equalTo: timeSlotsCollectionView.centerXAnchor),
            
            addEventToCalendarCheckBox.widthAnchor.constraint(equalToConstant: 18),
            addEventToCalendarCheckBox.heightAnchor.constraint(equalToConstant: 18),
            addEventToCalendarCheckBox.leadingAnchor.constraint(equalTo: timeSlotsCollectionView.leadingAnchor),
            
            addEventToCalendarCheckBox.topAnchor.constraint(equalTo: timeSlotsCollectionView.bottomAnchor, constant: 12),
            
            addEventCBLabel.centerYAnchor.constraint(equalTo: addEventToCalendarCheckBox.centerYAnchor),
            addEventCBLabel.leadingAnchor.constraint(equalTo: addEventToCalendarCheckBox.trailingAnchor, constant: 8),
            addEventCBLabel.heightAnchor.constraint(equalToConstant: 18),
            addEventCBLabel.trailingAnchor.constraint(equalTo: timeSlotsCollectionView.trailingAnchor),
            
            continueButton.widthAnchor.constraint(equalToConstant: 300),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            continueButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            continueButton.topAnchor.constraint(equalTo: addEventToCalendarCheckBox.bottomAnchor, constant: 40),
            continueButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20)
            
            
            
        ]
        
        DispatchQueue.main.async {
           
            self.scrollView.bringSubviewToFront(self.servicePicker)
            self.refreshConstraintsForNewOrientation(UIDevice.current.orientation == .portrait ? .portrait : .landscape)
        }
    }
}
