//
//  RegistrationVerifier.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 12/11/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI
import Combine

class RegistrationVerifier: ObservableObject {
    // input
    @Published var username = ""
    @Published var password = ""
    @Published var repeatPassword = ""
    
    // output
    @Published var usernameMessage = ""
    @Published var usernameValid: Bool = false
    @Published var passwordMessage = ""
    @Published var passwordValid: Bool = false
    @Published var isValid = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var isUsernameValidPublisher: AnyPublisher<Bool, Never> {
        $username
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input.count >= 3
        }
        .eraseToAnyPublisher()
    }
    
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                return password == ""
        }
        .eraseToAnyPublisher()
    }
    
    private var arePasswordsEqualPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $repeatPassword)
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map { password, passwordAgain in
                return password == passwordAgain
        }
        .eraseToAnyPublisher()
    }
    
    enum PasswordCheck {
        case valid
        case empty
        case noMatch
    }
    
    private var isPasswordValidPublisher: AnyPublisher<PasswordCheck, Never> {
        Publishers.CombineLatest(isPasswordEmptyPublisher, arePasswordsEqualPublisher)
            .map { passwordIsEmpty, passwordsAreEqual in
                if (passwordIsEmpty) {
                    self.passwordValid = false
                    return .empty
                }
                else if (!passwordsAreEqual) {
                    self.passwordValid = false
                    return .noMatch
                }
                else {
                    self.passwordValid = true
                    return .valid
                }
        }
        .eraseToAnyPublisher()
    }
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isUsernameValidPublisher, isPasswordValidPublisher)
            .map { userNameIsValid, passwordIsValid in
                return userNameIsValid && (passwordIsValid == .valid)
        }
        .eraseToAnyPublisher()
    }
    
    init() {
        isUsernameValidPublisher
            .receive(on: RunLoop.main)
            .map { valid in
                self.usernameValid = valid
                return valid ? "Username good" : "Username must be at least 3 characters long"
        }
        .assign(to: \.usernameMessage, on: self)
        .store(in: &cancellableSet)
        
        isPasswordValidPublisher
            .receive(on: RunLoop.main)
            .map { passwordCheck in
                switch passwordCheck {
                case .empty:
                    return "Password must not be empty"
                case .noMatch:
                    return "Passwords don't match"
                default:
                    return "Password good"
                }
        }
        .assign(to: \.passwordMessage, on: self)
        .store(in: &cancellableSet)
        
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
    }
    
}
