//
//  ContentView.swift
//  iOSDemoForAWS
//
//  Created by Knoxpo MacBook Pro on 05/02/21.
//

import SwiftUI
//singleton object to store user data
class UserData : ObservableObject {
    
    private init() {}
    static let shared = UserData()
    @Published var notes : [Note] = []
    @Published var isSignedIn : Bool = false
    
}


class Note : Identifiable, ObservableObject
{
    var id : String
    var name : String
    var desc : String?
    var imageName : String?
    @Published var image : Image?
    
    init(id: String, name: String, desc: String? = nil, image: String? = nil) {
        
        
        self.id = id
        self.name = name
        self.desc = desc
        self.imageName = image
        
    }
    
    
    
}

//a view to represent a single list item
struct ListRow: View {
    @ObservedObject var note : Note
    var body: some View {
        return HStack(alignment: .center, spacing: 5.0) {
            
            if (note.image != nil) {
                
              
               note.image!
                    .resizable()
                   
                .frame(width: 50, height: 50)
                
            }
            
            VStack(alignment: .leading, spacing: 5.0) {
                Text(note.name)
                    .bold()
                
                
                if ((note.desc) != nil)
                {
                    
                    Text(note.desc!)
                }
            }
            
            
            
            
        }
        
        
        
    }
    
    
    
    
    
}





struct ContentView: View {
    @ObservedObject private var userData: UserData = .shared
    
    var body: some View {
        ZStack {
            if (userData.isSignedIn) {
                NavigationView {
                    
                    List {
                        
                        ForEach(userData.notes) { note in
                            ListRow(note: note)
                            
                            
                        }
                    
                }
                    .navigationBarTitle(Text("Notes"))
                    .navigationBarItems(leading: SignOutButton())
            }
            
            
            
            } else {
                
                SignInButton()
            }
        
        
      
            
            
        }
        
        
    }
    
    struct SignInButton: View {
        
        var body: some View {
            
            
            Button(action: { Backend.shared.signIn()}) {
                
                HStack {
                    Image(systemName: "person.fill")
                        .scaleEffect(1.5)
                        .padding()
                    Text("Sign IN")
                        .font(.largeTitle)
                    
                    
                    
                }
                
                .padding()
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(30)
                
            }
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    struct SignOutButton : View {
        
        var body : some View {
            
            Button(action: { Backend.shared.signOut() }) {
                
                
                Text ("Sign Out")
            }
        }
        
        
        
    }
    
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        let _ = prepareTestData()
        ContentView()
    }
}

func prepareTestData() -> UserData {
    let userData = UserData.shared
    userData.isSignedIn = true
    let desc = "this is a very long desc"
    
    let n1 = Note(id: "01", name: "Hello", desc: desc, image: "mic")
    
    let n2 = Note(id: "02", name: "world", desc: desc, image: "phone")
    
    n1.image = Image(systemName: n1.imageName!)
    n2.image = Image(systemName: n2.imageName!)
    
    
    userData.notes = [n1,n2]
    return userData
}













