//
//  ContentView.swift
//  messengerApp4
//
//  Created by 이수연 on 2020/03/26.
//  Copyright © 2020 이수연. All rights reserved.
//
import SwiftUI
import Firebase

struct ContentView: View {
   @State var name = ""
       
       var body: some View {
           
           
           NavigationView{
               ZStack{
                Color.yellow
                   VStack{
                    
                    Image("mingu").resizable().frame(width: CGFloat(100), height: CGFloat(100)).padding(.top, CGFloat(12))
                    
                    Text("Mingu Talk")
                    
                    TextField("name", text: $name).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                   if self.name != ""{
                        NavigationLink(destination: MsgPage()){
                                                  HStack{
                                                      Text("Join")
                                                   Image(systemName: "arrow.right.circle").resizable().frame(width: 20, height: 20)
                                                 }
                                              }  .frame(width: 100, height: 30)
                                               .background(Color.yellow)
                                               .foregroundColor(.white)
                                           .cornerRadius(20)
                                               .padding(.bottom, 15)
                            
                         
                  }
                   
                   }.background(Color.white)
                .cornerRadius(20)
                .padding()
           }.edgesIgnoringSafeArea(.all)
           }.animation(.default)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MsgPage : View {
    
    var name = ""
    @ObservedObject var msg = observer()
    @State var typedmsg = ""
    
    var body : some View{
        VStack{
            
            List(msg.msgs){
            i in
            
                if i.name == self.name{
                    MsgRow(msg : i.msg, myMsg : true,user: i.name)
                }
                else{
                    MsgRow(msg: i.msg, myMsg: false,user: i.name)
                }
            
            }.navigationBarTitle("Talks", displayMode: .inline)
        
            HStack{
            TextField("message", text: $typedmsg).textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
             self.msg.addMsg(msg: self.typedmsg, user: self.name)
             self.typedmsg = ""
            }){
                
                Image("sendingbtn").renderingMode(.original).resizable().frame(width: 30, height: 30)
            }
            }.padding()
    }
    }
    func removeRows(at offsets: IndexSet){
        msg.msgs.remove(atOffsets: offsets)
    }
}

  class observer : ObservableObject{
    @Published var msgs = [datatype]()
    init() {
        let db = Firestore.firestore()
        
        db.collection("msgs").addSnapshotListener{ (snap, err) in
            
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            for i in snap!.documentChanges{
                
                if i.type == .added{
                    
                    //if i.document.get("msg") != nil {
                    let msg = i.document.get("msg") as! String
                    let name = i.document.get("name") as! String
                    let id = i.document.documentID
                    
                    self.msgs.append(datatype(id: id, name: name, msg: msg))
                    
                    //}
                    
                }
            }
            }
        
    }
    func addMsg(msg : String, user: String){
        let db = Firestore.firestore()
        
        db.collection("msgs").addDocument(data: ["msg" :msg, "name" :user]) { (err) in
            
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            print("sucesss")
        }
    }
}

struct datatype : Identifiable{
    var id : String
    var name : String
    var msg : String
    
}

struct MsgRow : View{
    
    var msg = ""
    var myMsg = false
    var user = ""
    
    var body : some View{
        HStack{
            if myMsg{
                Spacer()
                Text(msg).padding(8).background(Color.blue).cornerRadius(6)
                    .foregroundColor(.white)
                
            }
            else{
                
                VStack(alignment: .leading){
                Text(msg).padding(8).background(Color.gray).cornerRadius(6)
                    .foregroundColor(.white)
                    Text(user)
                }
                Spacer()
            }
            
        }
    }
    }

