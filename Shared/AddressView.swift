//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Erik Mikac on 4/12/21.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: OrderWrapper

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.order.name)
                TextField("Street Address", text: $order.order.streetAddress)
                TextField("City", text: $order.order.city)
                TextField("Zip", text: $order.order.zip)
                Text("Name: \(order.order.name), Cost: \(order.order.cost), Quantity: \(order.order.quantity), City: \(order.order.city)")
            }
        
            
            Section {
                NavigationLink(destination: CheckoutView(order: order)) {
                    Text("Check Out")
                }
            }
            .disabled(order.order.hasValidAddress == false && order.order.streetAddress.isOnlyWhiteSpace() == false)
        }
        .navigationBarTitle("Delivery Details", displayMode: .inline)
    }
    
}

extension String {
    func isOnlyWhiteSpace() -> Bool{
        for char in self {
            if char != " " {
                return true
            }
        }
        return false
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: OrderWrapper())
    }
}
