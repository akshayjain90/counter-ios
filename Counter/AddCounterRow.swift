//
//  AddCounterRow.swift
//  Counter
//
//  Created by Pragya Goel on 12/27/19.
//  Copyright © 2019 GenericGenome. All rights reserved.
//

import SwiftUI

struct AddCounterRow: View {
    @EnvironmentObject var userData: UserData
    @State private var counter: Count
    @State private var keyboardHeight: CGFloat = 0
    
    private let showPublisher = NotificationCenter.Publisher.init(
        center: .default,
        name: UIResponder.keyboardWillShowNotification
    ).map { (notification) -> CGFloat in
        if let rect = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect {
            let rectSum = rect.size.height
            return rectSum
        } else {
            return 0
        }
    }

    private let hidePublisher = NotificationCenter.Publisher.init(
        center: .default,
        name: UIResponder.keyboardWillHideNotification
    ).map {_ -> CGFloat in 0}
    
    struct DismissingKeyboard: ViewModifier {
        func body(content: Content) -> some View {
            content
                .onTapGesture {
                    let keyWindow = UIApplication.shared.connectedScenes
                            .filter({$0.activationState == .foregroundActive})
                            .map({$0 as? UIWindowScene})
                            .compactMap({$0})
                            .first?.windows
                            .filter({$0.isKeyWindow}).first
                    keyWindow?.endEditing(true)
            }
        }
    }
    

    var body: some View {
        VStack {
        HStack {
            VStack {
                TextField("New Counter", text: $title)
                    .padding(.horizontal)
            }
           Spacer()
            Image("minus-counter").onTapGesture {self.value -= 1}
            Text("\(self.value)").frame(width: 50, height: nil)
            Image("plus-counter").onTapGesture {self.value += 1}
        }
        .animation(.default)
        .overlay(
           RoundedRectangle(cornerRadius: 10)
            .stroke(Color.black, lineWidth: 1)
        )
            //.background(LinearGradient(gradient: Gradient(colors: [Color(0xff9068), Color(0xfd746c)]), startPoint: .trailing, endPoint: .leading))
       .padding([.top])
       .padding(.horizontal, 5)
            if (keyboardHeight > 0.0) {
                HStack {
                    Image(systemName: "trash")
                    .padding(.horizontal, 50)
                    .padding([.top, .bottom])
                    .overlay(
                           RoundedRectangle(cornerRadius: 5)
                             .stroke(Color.black, lineWidth: 1)
                    ).padding()
                    .onTapGesture {
                       self.title = ""
                       self.value = 0
                        UIApplication.shared.endEditing()
                    }
                   Spacer()
                   Text("Add")
                    .font(.headline)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 50)
                    .padding([.top, .bottom])
                    .overlay(
                           RoundedRectangle(cornerRadius: 5)
                             .stroke(Color.black, lineWidth: 1)
                    ).padding()
                    .onTapGesture {
                       self.userData.countersData.append(Count(id: UUID.init(), title: self.title, value: self.value))
                       self.title = ""
                       self.value = 0
                       UIApplication.shared.endEditing()
                    }
                }
            }

        } .offset(y: -1.0 * keyboardHeight)
            .onReceive(showPublisher.merge(with: hidePublisher)) { (height) in
            self.keyboardHeight = height
        }
        
    }
    
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct AddCounterRow_Previews: PreviewProvider {
    static var previews: some View {
        AddCounterRow(index: -1)
    }
}
