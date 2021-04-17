//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Erik Mikac on 4/12/21.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: OrderWrapper
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var showingError = false
    
    @State private var connError = ""
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    Text("Your total is $\(self.order.order.cost, specifier: "%.2f")")
                        .font(.title)
                    
                    Button("Place Order") {
                        self.placeOrder()
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("Check out", displayMode: .inline)
        .alert(isPresented: $showingConfirmation) {
            Alert(title: Text("Thank you!"), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $showingError) {
            Alert(title: Text("No data in response"), message: Text(connError), dismissButton: .default(Text("OK")))
        }
        
    }
    func placeOrder() {
        print("Inside of place order")
        guard let encoded = try? JSONEncoder().encode(order.order) else {
            print("Failed to encode order.")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupckaes")!
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        req.httpBody = encoded
        
        URLSession.shared.dataTask(with: req) {
            data, response, error in
            // handle the result here
            guard let data = data else {
                self.connError = error?.localizedDescription ?? "Unknown error!"
                self.showingError = true
                return
            }
            
            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                self.confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
                self.showingConfirmation = true
            } else {
                print("Invalid response from server")
            }
        }.resume()
        
        
    }
}

struct CheckoutView_Previews: PreviewProvider {

    static var previews: some View {
        CheckoutView(order: OrderWrapper())
    }
}
