//
//  LaunchLibraryResponseTypes.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 02/08/2021.

import Foundation

//MARK: Response Array
struct UpcomingLaunchApiResponse: Codable {
    let results: [LaunchInfo]
}

//MARK: Main Response Object
struct LaunchInfo: Codable {
    let id: String
    let name: String
    let launchStatus: LaunchStatus
    let noEarlierThan: String
    let windowStart: String
    let windowEnd: String
    let inhold: Bool
    let tbdtime: Bool
    let tbddate: Bool
    let holdreason: String?
    let launchServiceProvider: providerInfo
    let rocket: RocketInfo
    let mission: MissionInfo?
    let pad: PadInfo
    let probability: Int? // -1 = no weather data, positive is a percentage Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case launchStatus = "status"
        case noEarlierThan = "net"
        case windowStart = "window_start"
        case windowEnd = "window_end"
        case inhold = "inhold"
        case tbdtime = "tbdtime"
        case tbddate = "tbddate"
        case holdreason = "holdreason"
        case launchServiceProvider = "launch_service_provider"
        case rocket = "rocket"
        case mission = "mission"
        case pad = "pad"
        case probability = "probability"
    }
}

//MARK: Launch Status
struct LaunchStatus: Codable {
    let id: Int
    let name: String
    let description: String
    //Status ID Codes
    // 1 - Go - Current T-0 confirmed by official or reliable sources.
    // 2 - To Be Determined - Current date is a 'No Earlier Than' estimation based on unreliable or interpreted sources.
    // 3 - Launch Successful - The launch vehicle successfully inserted its payload(s) into the target orbit(s).
    // 4 - Launch Failure - Either the launch vehicle did not reach orbit, or the payload(s) failed to separate.
    // 8 - To Be Confirmed - Awaiting official confirmation, current date is known with some certainty.
}

//MARK: Launch Provider
struct providerInfo: Codable {
    let id: Int
    let name: String
    let abbreviation: String
    let logoUrl: String?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case abbreviation = "abbrev"
        case logoUrl = "logo_url"
        case type = "type"
    }
}

//MARK: Rocket
struct RocketInfo: Codable {
    let configuration: ConfigurationInfo
}

struct ConfigurationInfo: Codable {
    let name: String
    let family: String
    let variant: String
}

//MARK: Mission
struct MissionInfo: Codable {
    let id: Int
    let name: String
    let description: String
    let type: String
    let orbit: OrbitInfo?
}

struct OrbitInfo: Codable {
    let id: Int
    let name: String
    let abbrev: String
}

//MARK: Pad
struct PadInfo: Codable {
    let id: Int
    let name: String
    let latitude: String
    let longitude: String
    let location: PadLocationInfo
}

struct PadLocationInfo: Codable {
    let name: String
}

//MARK: Program
struct programInfo: Codable {
    let id: Int
    let name: String
    let description: String
}

