//
//  AddView.swift
//  myExpenses
//
//  Created by Matteo Cavallo on 30/06/21.
//

import SwiftUI

struct AddView: View {
    @ObservedObject var expenses: Expenses
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    var types = ["Personal", "Business"]
    
    @State private var alertTitle = ""
    @State private var showAlert = false
    
    var body: some View {
        NavigationView{
            Form{
                TextField("Name", text: $name)
                Picker("Type", selection: $type){
                    ForEach(types, id: \.self){
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationTitle("Add Expense")
            .navigationBarItems(trailing: Button("Done", action: saveExpense))
            .alert(isPresented: $showAlert){
                Alert(title: Text(alertTitle), dismissButton: .default(Text("Ok")))
            }
        }
    }
    
    func saveExpense(){
        if let amount = Int(self.amount){
            let newExpense = ExpenseItem(name: self.name, type: self.type, amount: amount)
            expenses.items.insert(newExpense, at: 0)
            presentationMode.wrappedValue.dismiss()
        } else {
            alertTitle = "Wrong input"
            showAlert = true
        }
    }
}

struct AddView_Previews: PreviewProvider {
    
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
