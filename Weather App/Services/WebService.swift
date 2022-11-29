//
//  WebService.swift
//  Weather App
//
//  Created by Kuda Zata on 27/11/2022.
//

import Foundation

/// The different error types that might occur when making network calls
enum NetworkError: Error {
    case badUrl
    case decodingError
    case badRequest
    case noData
    case customError(Error)
}

extension NetworkError: LocalizedError {
    
    public var errorDescription: String? {
        return "There was an error connecting to our server. Please try again"
    }
}

/// A resource object to be created when making network calls
struct Resource<T> {
    let urlString: String
    let parse: (Data) -> T?
}


///This is a protocol that the WebService will conform to so as to allow us to mock it for testing purposes
protocol WebServiceProtocol {
    func getCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (Result<CurrentWeatherResponse?, NetworkError>) -> Void)
    func getForecastWeather(latitude: Double, longitude: Double, completion: @escaping (Result<ForecastWeatherResponse?, NetworkError>) -> Void)
}


/// The class responsible for all network calls within the app
final class WebService: WebServiceProtocol {
    
    /// Generic network caller that can take in and return any type of object
    /// - Parameters:
    ///    - resource: object of type Resource to be used for the network call
    ///    - completion: Code to be executed by the caller. Will contain type Result
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T?, NetworkError>) -> Void) {
        
        guard let url = URL(string: resource.urlString) else {
            completion(.failure(.badUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.customError(error)))
                    return
                }
                
                if (response as? HTTPURLResponse)?.statusCode != 200 {
                    completion(.failure(.badRequest))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                
                completion(.success(resource.parse(data)))
            }
            
        }.resume()
    }

    
    /// Fetch the current weather for a given location
    /// - Parameters:
    ///   - location: A CLLocation object containing the current location of the device
    ///   - completion: Callback with either the current weather resource or a Network Error
    func getCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (Result<CurrentWeatherResponse?, NetworkError>) -> Void) {
        
        let url = Urls.currentWeatherUrl(latitude: latitude, longitude: longitude)
        let resource = Resource<CurrentWeatherResponse>(urlString: url) { data in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let weatherResponse = try? decoder.decode(CurrentWeatherResponse.self, from: data)
            return weatherResponse
        }
        
        load(resource: resource) { result in
            switch result {
            case let .success(currentWeatherResponse):
                completion(.success(currentWeatherResponse))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    /// Fetch the forecasr weather for a given location
    /// - Parameters:
    ///   - location: A CLLocation object containing the current location of the device
    ///   - completion: Callback with either the forecast weather resource or a Network Error
    func getForecastWeather(latitude: Double, longitude: Double, completion: @escaping (Result<ForecastWeatherResponse?, NetworkError>) -> Void) {
        
        let url = Urls.forecastWeather(latitude: latitude, longitude: longitude)
        let resource = Resource<ForecastWeatherResponse>(urlString: url) { data in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.setDateDecodingStrategy()
            let forecastWeatherResponse = try? decoder.decode(ForecastWeatherResponse.self, from: data)
            return forecastWeatherResponse
        }
        
        load(resource: resource) { result in
            switch result {
            case let .success(forecastWeatherResponse):
                completion(.success(forecastWeatherResponse))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
