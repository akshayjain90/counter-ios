//
//  ContentView.swift
//  Counter
//
//  Created by Pragya Goel on 12/26/19.
//  Copyright © 2019 GenericGenome. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var keyboardHeight: CGFloat = 0
    
    @EnvironmentObject var userData: UserData

    init() {
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().separatorStyle = .none

    }
    
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
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Text("Count On Me")
                    .font(.title)
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50, alignment: .topLeading)
            .padding(.top)
            .background(LinearGradient(gradient: Gradient(colors: [Color(0xff9068), Color(0xfd746c)]), startPoint: .trailing, endPoint: .leading))
            
            VStack {
                List{
                    ForEach(userData.countersData) {
                        countr in if(countr != self.userData.countersData.last) { CounterRow(counter :countr).environmentObject(self.userData).listRowInsets(EdgeInsets())
                        }
                    }
                }.blur(radius: keyboardHeight > 0.0 ? 10 : 0)
                
                Spacer()
                AddCounterRow(index : -1).environmentObject(self.userData)
            }.onReceive(showPublisher.merge(with: hidePublisher)) { (height) in
                self.keyboardHeight = height
            }
        }
    }
}

extension Color {
init(_ hex: Int, opacity: Double = 1.0) {
    let red = Double((hex & 0xff0000) >> 16) / 255.0
    let green = Double((hex & 0xff00) >> 8) / 255.0
    let blue = Double((hex & 0xff) >> 0) / 255.0
    self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserData())
    }
}
