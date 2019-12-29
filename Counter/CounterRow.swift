//
//  CounterRow.swift
//  Counter
//
//  Created by Pragya Goel on 12/26/19.
//  Copyright © 2019 GenericGenome. All rights reserved.
//

import SwiftUI

struct CounterRow: View {
    var counter: Count
    @EnvironmentObject var userData: UserData
    
    var counterIndex: Int {
           userData.countersData.firstIndex(where: { $0.id == counter.id })!
       }

    var body: some View {
        HStack {
            Text(counter.title)
                    .font(.headline)
                    .fontWeight(.heavy)
                    .padding()
            Spacer()
        
            Image("minus-counter").onTapGesture {self.userData.countersData[self.counterIndex].value -= 1
            }
            Text(String(counter.value)).frame(width: 20, height: nil)
            Image("plus-counter").onTapGesture {self.userData.countersData[self.counterIndex].value += 1
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 1)
        )
                
        .padding([.top])
        .padding(.horizontal, 5)
    }
}

struct CounterRow_Previews: PreviewProvider {
    static var previews: some View {
        CounterRow(counter: counters[0])
    }
}
