//
//  NetworkModelTests.swift
//  KCDragonBallTests
//
//  Created by Ariana Rodríguez on 14/03/25.
//

import XCTest
import OSLog
@testable import KCDragonBall

final class NetworkModelTests: XCTestCase {
    private var sut: NetworkModelProtocol! // sut means System Under Test
    private var apiClientMock: APIClientMock!
    
    override func setUp() {
        super.setUp()
        apiClientMock = APIClientMock()
        sut = NetworkModel(apiClient: apiClientMock)
        sut.storedJWT = "{jwt}"
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: Login Success Cases
    func test_login_URL() {
        // Given
        let successResult = Result<String, APIClientError>.success("{jwt}")
        apiClientMock.receiveJWTResult = successResult
        
        // When
        var receivedResult: Result<String, APIClientError>?
        sut.jwt(
            user: "regularuser@keepcoding.es",
            password: "Regularuser1"
        ) { result in
            receivedResult = result
        }
        
        // Then
        XCTAssertEqual(
            apiClientMock.receiveJWTRequest?.url,
            URL(string: "https://dragonball.keepcoding.education/api/auth/login")
        )
        XCTAssertNotNil(receivedResult, "Request Succeeded")
    }
    
    func test_login_success() {
        // Given
        let successResult = Result<String, APIClientError>.success("{jwt}")
        apiClientMock.receiveJWTResult = successResult
        
        // When
        var receivedResult: Result<String, APIClientError>?
        sut.jwt(
            user: "regularuser@keepcoding.es",
            password: "Regularuser1"
        ) { result in
            receivedResult = result
        }
        
        // Then
        XCTAssertEqual(successResult, receivedResult)
    }
    
    // MARK: Login Failure Cases
    func test_login_email_format_failure() {
        // Given
        let successResult = Result<String, APIClientError>.success("{jwt}")
        apiClientMock.receiveJWTResult = successResult
        
        // When
        var receivedResult: Result<String, APIClientError>?
        sut.jwt(
            user: "regularuser.es",
            password: "Regularuser1"
        ) { result in
            receivedResult = result
        }
        
        // Then
        XCTAssertEqual(receivedResult, .failure(.emailFormat))
    }
    
    // MARK: Heros Success Cases
    func test_getHeros_URL() {
        // Given
        let successResult = Result<[Hero], APIClientError>.success([])
        apiClientMock.receiveHeroResult = successResult
        
        // When
        var receivedResult: Result<[Hero], APIClientError>?
        sut.getHeros { result in
            receivedResult = result
        }
        
        // Then
        XCTAssertEqual(
            apiClientMock.receiveRequest?.url,
            URL(string: "https://dragonball.keepcoding.education/api/heros/all")
        )
        XCTAssertNotNil(receivedResult, "Request Succeeded")
    }
    
    func test_getHeros_success() {
        // Given
        let successResult = Result<[Hero], APIClientError>.success(SuccessResonsesMock.heros)
        apiClientMock.receiveHeroResult = successResult
        
        // When
        var receivedResult: Result<[Hero], APIClientError>?
        sut.getHeros { result in
            receivedResult = result
        }
        
        // Then
        if case let .success(heroList) = receivedResult {
            Logger.tests.log("Get Heros Succeeded")
            XCTAssertTrue(!heroList.isEmpty, "The list has items")
        } else {
            Logger.debug.log("Get Heros Failed")
        }
    }
    
    // MARK: Heros Failure Cases
    func test_getHeros_encoding_failure() {
        // Given
        sut.heroJSONObject = [
            "name": "Gohan",
            // Using Set we can force a decoding error
            "transformations": Set([
                "1. Kaio-Ken",
                "2. Super Saiyan 2",
                "3. Super Saiyan Blue Kaio-ken"
            ])
        ]
        
        // When
        var receivedResult: Result<[Hero], APIClientError>?
        sut.getHeros { result in
            receivedResult = result
        }
        
        // Then
        XCTAssertEqual(receivedResult, .failure(.encodingFailed))
    }
    
    // MARK: Heros Edge Cases
    func test_getHeros_empty_response() {
        // Given
        let successResult = Result<[Hero], APIClientError>.success([])
        apiClientMock.receiveHeroResult = successResult
        
        // When
        var receivedResult: Result<[Hero], APIClientError>?
        sut.getHeros { result in
            receivedResult = result
        }
        
        // Then
        if case let .success(heroList) = receivedResult {
            Logger.tests.log("Get Heros Empty Succeeded")
            XCTAssertTrue(heroList.isEmpty, "The list is empty")
        } else {
            Logger.tests.log("Get Heros Empty Failed")
        }
    }
}
