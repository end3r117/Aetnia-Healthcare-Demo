//
//  AppointmentsCalendarManager.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/9/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
enum CustomError: Error {
    case eventAlreadyExistsInCalendar, eventNotAddedToCalendar, calendarAccessDeniedOrRestricted
}
enum EventsCalendarManagerResponseError<Bool, CustomError>: Error {
    case success(Bool), failure(CustomError)
}
typealias EventsCalendarManagerResponse = (_ result: EventsCalendarManagerResponseError<Bool, CustomError>) -> Void

class EventsCalendarManager: NSObject {
    let eventModalVC = EKEventEditViewController()
    var eventStore: EKEventStore!
    weak var presenter: UIViewController?
    init(eventStore: EKEventStore, presenter: UIViewController) {
        self.presenter = presenter
        self.eventStore = eventStore
        super.init()
        let authStatus = getAuthorizationStatus()
        switch authStatus {
        case .notDetermined:
            //Auth is not determined
            //We should request access to the calendar
            requestAccess { (accessGranted, error) in
                if !accessGranted {
                    self.popUp()
                    print(String(describing: self))
                }
            }
        case .denied, .restricted:
            // Auth denied or restricted, we should display a popup
            self.popUp()
        case .authorized:
            break
        @unknown default:
            fatalError()
        }
        
    }
    
    private func popUp() {
        let alertController = UIAlertController(quicklyUsing: .OK, alertTitle: "Access Denied", alertMessage: "If you'd like to add appointments, consultations, etc., to your Calendar, you must authorize Aetnia in the Settings app.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Open Settings", style: .default, handler: { (alertAction) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        alertController.addAction(settingsAction)
        DispatchQueue.main.async {
            self.presenter?.present(alertController, animated: true)
        }
//        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true)
    }
    
    // Request access to the Calendar
    
    private func requestAccess(completion: @escaping EKEventStoreRequestAccessCompletionHandler) {
        eventStore.requestAccess(to: EKEntityType.event) { (accessGranted, error) in
            completion(accessGranted, error)
        }
    }
    
    // Get Calendar auth status
    
    private func getAuthorizationStatus() -> EKAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: EKEntityType.event)
    }
    
    // Check Calendar permissions auth status
    // Try to add an event to the calendar if authorized
    
    func addEventToCalendar(event: EKEvent, completion : @escaping EventsCalendarManagerResponse) {
        let authStatus = getAuthorizationStatus()
        switch authStatus {
        case .authorized:
            self.addEvent(event: event, completion: { (result) in
                switch result {
                case .success:
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        case .notDetermined:
            //Auth is not determined
            //We should request access to the calendar
            requestAccess { (accessGranted, error) in
                if accessGranted {
                    self.addEvent(event: event, completion: { (result) in
                        switch result {
                        case .success:
                            completion(.success(true))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    })
                } else {
                    // Auth denied, we should display a popup
                    completion(.failure(.calendarAccessDeniedOrRestricted))
                }
            }
        case .denied, .restricted:
            // Auth denied or restricted, we should display a popup
            completion(.failure(.calendarAccessDeniedOrRestricted))
        @unknown default:
            let alertController = UIAlertController(quicklyUsing: .OK, alertTitle: "Error", alertMessage: "An unknown error occured. Sorry 'bout ittt.")
            
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            window?.rootViewController?.present(alertController, animated: true)
            
        }
    }
    
    // Generate an event which will be then added to the calendar
    
    private func generateEvent(event: EKEvent) -> EKEvent {
        let newEvent = EKEvent(eventStore: eventStore)
        newEvent.calendar = eventStore.defaultCalendarForNewEvents
        newEvent.title = event.eventIdentifier
        newEvent.startDate = event.startDate
        newEvent.endDate = event.endDate
        // Set default alarm minutes before event
        let alarm = EKAlarm(relativeOffset: TimeInterval(60*60))
        newEvent.addAlarm(alarm)
        return newEvent
    }
    
    // Try to save an event to the calendar
    
    private func addEvent(event: EKEvent, completion : @escaping EventsCalendarManagerResponse) {
        let eventToAdd = generateEvent(event: event)
        if !eventAlreadyExists(event: eventToAdd) {
            do {
                try eventStore.save(eventToAdd, span: .thisEvent)
            } catch {
                // Error while trying to create event in calendar
                completion(.failure(.eventNotAddedToCalendar))
            }
            completion(.success(true))
        } else {
            completion(.failure(.eventAlreadyExistsInCalendar))
        }
    }
    
    // Check if the event was already added to the calendar
    
    private func eventAlreadyExists(event eventToAdd: EKEvent) -> Bool {
        let predicate = eventStore.predicateForEvents(withStart: eventToAdd.startDate, end: eventToAdd.endDate, calendars: nil)
        let existingEvents = eventStore.events(matching: predicate)
        
        let eventAlreadyExists = existingEvents.contains { (event) -> Bool in
            return eventToAdd.title == event.title && event.startDate == eventToAdd.startDate && event.endDate == eventToAdd.endDate
        }
        return eventAlreadyExists
    }
    
    // Show event kit ui to add event to calendar
    
    func presentCalendarModalToAddEvent(event: Event, presenter: UIViewController, completion : @escaping EventsCalendarManagerResponse) {
        let authStatus = getAuthorizationStatus()
        switch authStatus {
        case .authorized:
            presentEventCalendarDetailModal(event: event, presenter: presenter)
            completion(.success(true))
        case .notDetermined:
            //Auth is not determined
            //We should request access to the calendar
            requestAccess { (accessGranted, error) in
                if accessGranted {
                    self.presentEventCalendarDetailModal(event: event, presenter: presenter)
                    completion(.success(true))
                } else {
                    // Auth denied, we should display a popup
                    completion(.failure(.calendarAccessDeniedOrRestricted))
                    self.popUp()
                }
            }
        case .denied, .restricted:
            // Auth denied or restricted, we should display a popup
            completion(.failure(.calendarAccessDeniedOrRestricted))
            popUp()
        @unknown default:
            fatalError()
        }
    }
    
    // Present edit event calendar modal
    
    private func presentEventCalendarDetailModal(event: Event, presenter: UIViewController) {
        eventModalVC.event = event.event
        eventModalVC.view.backgroundColor = .systemGroupedBackground
        eventModalVC.eventStore = event.store
        eventModalVC.editViewDelegate = presenter as? EKEventEditViewDelegate
        eventModalVC.navigationBar.titleTextAttributes = [
            .font: UIFont(name: "Arial-BoldItalicMT", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .bold),
            .foregroundColor :  UIColor.white
        ]
        eventModalVC.navigationBar.barTintColor = .appColor(.aetniaBlue)
        eventModalVC.navigationController?.toolbarItems?.forEach({print($0)})
        eventModalVC.navigationBar.topItem?.title = "Confirm Event"
        presenter.present(eventModalVC, animated: true, completion: nil)
        
    }

    deinit {
        print("Events Calendar Manager - deinit")
    }
}

struct Event {
    
    var store: EKEventStore
    var event: EKEvent
    
}
