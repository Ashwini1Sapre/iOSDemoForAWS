//
//  Backend.swift
//  iOSDemoForAWS
//
//  Created by Knoxpo MacBook Pro on 05/02/21.
//

import UIKit
import Amplify
import AmplifyPlugins
class Backend {
    
    
    static let shared = Backend()
    static func initialize() -> Backend {
        do{
        try Amplify.configure()
        }
        catch {
            
            print("\(error)")
        }
        
        return shared
        
       
    }
    
    
    
    private init() {
        
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
          //  try Amplify.configure()
            print("Intilized amplify")
            
        }
        catch {
            
            print("\(error)")
        }
        
        _ = Amplify.Hub.listen(to: .auth) { (payload) in
            switch payload.eventName {
            case HubPayload.EventName.Auth.signedIn:
                print("Sign IN, update UI")
            
                self.updateUserData(withSignnStatus: true)
                
            case HubPayload.EventName.Auth.signedOut:
                print("signOut, update ui")
                
            case HubPayload.EventName.Auth.sessionExpired:
                print("show  sign in Ui")
                self.updateUserData(withSignnStatus: false)
            
            default:
                break
            
            }
            
            
            
            
            
        }
        
        _ = Amplify.Auth.fetchAuthSession { (result) in
            do {
                
                let session = try result.get()
                self.updateUserData(withSignnStatus: session.isSignedIn)
            } catch {
                
                print("\(error)")
            }
            
            
            
        }
        
        
        
        
    }
    
    
    public func signIn() {
        
        _ = Amplify.Auth.signInWithWebUI(presentationAnchor:UIApplication.shared.windows.first!) { result in
            switch result {
            case .success(_):
                print("sign in success")
            case .failure(let error):
                print("\(error)")
            
            
            
            }
            
            
            
        }
        
        
    }
    
    
    
    public func signOut() {
        
        _ = Amplify.Auth.signOut() { (result) in
            switch result {
            
            case .success:
                print("sign out")
            case .failure(let error):
                print("\(error)")
            
            
            }
            
            
            
        }
        
        
        
        
    }
    
    
    func updateUserData(withSignnStatus status : Bool) {
        
        DispatchQueue.main.async() {
            let userData : UserData = .shared
            userData.isSignedIn = status
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
