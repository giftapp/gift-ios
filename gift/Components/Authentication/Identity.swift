//
// Created by Matan Lachmish on 27/05/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import Locksmith

struct IdentityConsts {
    static let service = "gift"
    static let account = "me"
    static let userKey = "user"
    static let tokenKey = "token"
}


class Identity : NSObject {

    var user : User?
    var token : Token?

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic override init() {
        super.init()
        
        self.loadIdentityFromKeychain()
    }
    
    private func loadIdentityFromKeychain() {
        let keyChainDictionaryOpt = Locksmith.loadDataForUserAccount(IdentityConsts.account)
        if let keyChainDictionary = keyChainDictionaryOpt {
            self.user = keyChainDictionary[IdentityConsts.userKey] as? User
            self.token = keyChainDictionary[IdentityConsts.tokenKey] as? Token
            print ("Successfully loaded account from keychain")
        }
    }
    
    private func storeIdentityInKeyChain() {
        guard let user = self.user
            else {
                print ("Misssing user in identity")
                return //TODO:consider throw
            }
        
        guard let token = self.token
            else {
                print ("Misssing token in identity")
                return
            }
        
        do {
            try Locksmith.updateData([IdentityConsts.userKey: user, IdentityConsts.tokenKey : token], forUserAccount: IdentityConsts.account)
            print ("Successfully stored account in keychain")

            //Broadcast event
            NSNotificationCenter.defaultCenter().postNotificationName(IdentityUpdatedEvent.name, object: nil)
        } catch {
            print ("Failed to store account in keychain")
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func setIdentity(user : User, token : Token) {
        self.user = user
        self.token = token

        self.storeIdentityInKeyChain()
    }
    
    func updateUser(user: User) {
        self.user = user
        
        self.storeIdentityInKeyChain()
    }
    
    func updateToken(token: Token) {
        self.token = token
        
        self.storeIdentityInKeyChain()
    }

    func isLoggedIn() -> Bool {
        return self.token != nil
    }

}
