//
//  ContentView.swift
//  myExpenses
//
//  Created by Matteo Cavallo on 29/06/21.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable{
    var id = UUID()
    let name: String
    let type: String
    let amount: Int
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem](){
        didSet{
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items){
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init(){
        let decoder = JSONDecoder()
        if let items = UserDefaults.standard.data(forKey: "Items"){
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items){
                self.items = decoded
                return
            }
        }
        self.items = []
    }
}

struct ContentView: View {
    @ObservedObject var expenses: Expenses = Expenses()
    @State private var showNewExpense = false
    
    var body: some View {
    
        NavigationView{
            List{
                ForEach(expenses.items){item in
                    HStack{
                        VStack(alignment:.leading){
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text("€ \(item.amount)")
                            .bold()
                    }
                }
                .onDelete(perform: { indexSet in
                    expenses.items.remove(atOffsets: indexSet)
                })
            }
            .navigationTitle("My Expenses")
            .navigationBarItems(leading: EditButton(), trailing: toolBarItems)
            .sheet(isPresented:$showNewExpense){
                AddView(expenses: expenses)
            }
        }
    }
    
    var toolBarItems: some View {
            Button(action: {
                showNewExpense = true
            }){
                Image(systemName: "plus")
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
