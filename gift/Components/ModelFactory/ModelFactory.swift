//
// Created by Matan Lachmish on 17/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation

class ModelFactory: NSObject {

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic override init() {
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------

    //-------------------------------------------------------------------------------------------
    // MARK: - User
    //-------------------------------------------------------------------------------------------
    func createUserFrom(userDTO: UserDTO) -> User{
        let user = User(
                firstName: userDTO.firstName,
                lastName: userDTO.lastName,
                phoneNumber: userDTO.phoneNumber,
                email: userDTO.email,
                avatarURL: userDTO.avatarURL,
                needsEdit: userDTO.needsEdit,
                id: userDTO.id,
                createdAt: userDTO.createdAt,
                updatedAt: userDTO.updatedAt)
        return user
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Token
    //-------------------------------------------------------------------------------------------
    func createTokenFrom(tokenDTO: TokenDTO, user: User) -> Token{
        let token = Token(
                accessToken: tokenDTO.accessToken,
                user: user,
                id: tokenDTO.id,
                createdAt: tokenDTO.createdAt,
                updatedAt: tokenDTO.updatedAt)
        return token
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Event
    //-------------------------------------------------------------------------------------------
    func createEventFrom(eventDTO: EventDTO, venue: Venue) -> Event{
        let event = Event(date: eventDTO.date,
                contact1FirstName: eventDTO.contact1FirstName,
                contact1LastName: eventDTO.contact1LastName,
                contact2FirstName: eventDTO.contact2FirstName,
                contact2LastName: eventDTO.contact2LastName,
                venue: venue,
                id: eventDTO.id,
                createdAt: eventDTO.createdAt,
                updatedAt: eventDTO.updatedAt)
        return event
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Venue
    //-------------------------------------------------------------------------------------------
    func createVenueFrom(venueDTO: VenueDTO) -> Venue{
        let venue = Venue(googlePlaceId: venueDTO.googlePlaceId,
                name: venueDTO.name,
                address: venueDTO.address,
                phoneNumber: venueDTO.phoneNumber,
                latitude: venueDTO.latitude,
                longitude: venueDTO.longitude,
                googleMapsUrl: venueDTO.googleMapsUrl,
                website: venueDTO.website,
                imageUrl: venueDTO.imageUrl,
                id: venueDTO.id,
                createdAt: venueDTO.createdAt,
                updatedAt: venueDTO.updatedAt)
        return venue
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Toast
    //-------------------------------------------------------------------------------------------
    func createToastFrom(toastDTO: ToastDTO, toastFlavor: ToastFlavor) -> Toast{
        let toast = Toast(userId: toastDTO.userId,
                eventId: toastDTO.eventId,
                toastFlavor: toastFlavor,
                giftPresenters: toastDTO.giftPresenters,
                videoUrl: toastDTO.videoUrl,
                imageUrl: toastDTO.imageUrl,
                text: toastDTO.text,
                id: toastDTO.id,
                createdAt: toastDTO.createdAt,
                updatedAt: toastDTO.updatedAt)
        return toast
    }

}
