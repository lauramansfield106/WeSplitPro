//
//  ContentView.swift
//  WeSplitPro
//
//  Created by Laura Mansfield on 8/8/24.
//

import SwiftUI

struct BasicView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.decimalPad)
    }
}

extension View {
    func basicView () -> some View {
        modifier(BasicView())
    }
}


struct ContentView: View {
    @State private var numPeople: Int? = 2
    @State private var checkAmount: Double? = 0
    @State private var tipPercent: Int = 20
    var totalPerPerson: Double {
        if numPeople == 0 {
            return 0
        }
        let splitCheck = (checkAmount ?? 0)/Double(numPeople ?? 1)
        let tipFactor = (1 + Double(tipPercent )/100)
        return splitCheck * tipFactor
    }
    
    @FocusState private var amountIsFocused: Bool
    
    let tipPercents = [0, 10, 15, 20, 25]
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont.preferredFont(forTextStyle: .title1)]
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont.preferredFont(forTextStyle:  .title1)]
    }
    
    var body: some View {
       
        
        NavigationStack{
            
            VStack {
             
                Spacer()
                
                HStack {
                    Text("Check Amount:")
                    TextField("$", value: $checkAmount, format: .currency(code: "USD"))
                        .basicView()
                        .frame(maxWidth: 100)
                        .onChange(of: amountIsFocused){oldVal, newVal in
                            if newVal {
                                checkAmount = nil
                            } else {
                                if checkAmount == nil {
                                    checkAmount = 0
                                }
                            }
                        }
                }
                .padding()
                    
                
                
                HStack {
                    Text("No. of People:")
                    TextField("...", value: $numPeople, format: .number)
                        .basicView()
                        .frame(maxWidth: 40)
                        .focused($amountIsFocused)
                        .onChange(of: amountIsFocused){oldVal, newVal in
                            if newVal {
                                numPeople = nil
                            } else {
                                if numPeople == nil {
                                    numPeople = 0
                                }
                            }
                        }
                }
                .padding()
                
                Picker("Tip Percent", selection: $tipPercent){
                    ForEach(tipPercents, id: \.self){
                        percent in Text(percent, format: .percent)
                    }
                }
                .pickerStyle(.palette)
                .padding()
                

                
                Spacer()
                HStack{
                    Text("Total Per Person: ")
                    Text(totalPerPerson, format: .currency(code: "USD"))
                }
                .font(.title2)
                .padding()
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 15))
                
                   
                Spacer(minLength: 200)
            }
            .padding()
            .font(.title3)
            .frame(maxWidth: .infinity)
            .background(LinearGradient(gradient: Gradient(stops: [
                .init(color: Color.white, location: 0.0),
                .init(color: Color.peach, location: 0.5),
                .init(color: Color.black, location: 5)
            ]), startPoint: .top, endPoint: .bottom))
            .toolbar {
                if amountIsFocused{
                    Button("Done"){
                        amountIsFocused = false
                    }
                }
            }
            .navigationTitle("WeSplitPro")
      
            .navigationBarTitleDisplayMode(.inline)

            
        }


    }
}

#Preview {
    ContentView()
}
