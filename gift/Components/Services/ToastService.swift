//
// Created by Matan Lachmish on 04/01/2017.
// Copyright (c) 2017 GiftApp. All rights reserved.
//

import Foundation

class ToastService: NSObject {

    //Injected
    private var giftServiceCoreClient: GiftServiceCoreClient
    private var modelFactory: ModelFactory

    //Private Properties

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(giftServiceCoreClient: GiftServiceCoreClient,
                          modelFactory: ModelFactory) {
        self.giftServiceCoreClient = giftServiceCoreClient
        self.modelFactory = modelFactory
        super.init()
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    //TODO: implement
}
