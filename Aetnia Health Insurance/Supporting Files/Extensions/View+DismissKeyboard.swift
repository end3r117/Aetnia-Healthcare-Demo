//
//  View+DismissKeyboard.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/12/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI

struct DismissKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

struct DismissKeyboardOnTapGesture: ViewModifier {
    var gesture = TapGesture().onEnded {_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func dismissKeyboardOnTapGesture() -> some View {
        return modifier(DismissKeyboardOnTapGesture())
    }
    
    func dismissKeyboardOnDragGesture() -> some View {
        return modifier(DismissKeyboardOnDragGesture())
    }
    
    func dismissKeyboardOnUserInteraction() -> some View {
        return modifier(DismissKeyboardOnTapGesture()).modifier(DismissKeyboardOnDragGesture())
    }
    
}
