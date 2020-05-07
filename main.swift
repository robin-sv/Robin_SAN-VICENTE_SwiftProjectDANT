import Foundation

// Prévision actuelle
struct Current: Decodable {
  var current: CurrentDetail
}

struct CurrentDetail: Decodable {
  var dt: Double
  var temp: Double
  var clouds: Int
  var wind_speed: Double
  var weather: [Weather]
}

struct Weather: Decodable {
  var description: String
}

// Prévision 5 jours
struct Forecast: Decodable {
  var list: [ForecastDetail]
}

struct ForecastDetail: Decodable {
  var dt: Double
  var main: MainDetail
  var weather: [WeatherForecast]
}

struct MainDetail: Decodable {
  var temp: Double
}

struct WeatherForecast: Decodable {
  var description: String
}

enum WeatherError: Error {
  case noDataAvailable
  case canNotProcessData
}

struct CurrentRequest {
  let resourceURL: URL
  let API_KEY = "97cee058fa8e6909f7d368d06c4519a7"

  init?(latitude: Double, longitude: Double) {
    let resourceString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(API_KEY)"
    guard let resourceURL = URL(string: resourceString) else {print("Error")
    return nil}
    self.resourceURL = resourceURL
  }

  func getCurrent (completion: @escaping(Result<CurrentDetail, WeatherError>) -> Void) {
    let dataTask = URLSession.shared.dataTask(with: resourceURL) {data, _, _ in
      guard let jsonData = data else {
        completion(.failure(.noDataAvailable))
        return
      }
      do {
        let decoder = JSONDecoder()
        let currentResponse = try! decoder.decode(Current.self, from: jsonData)
        let currentDetails = currentResponse.current
        completion(.success(currentDetails))
      } catch {
        completion(.failure(.canNotProcessData))
      }
    }
    dataTask.resume()
  }
}

struct ForecastRequest {
  let resourceURL: URL
  let API_KEY = "97cee058fa8e6909f7d368d06c4519a7"

  init?(latitude: Double, longitude: Double) {
    let resourceString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(API_KEY)"
    guard let resourceURL = URL(string: resourceString) else {print("Error")
    return nil}
    self.resourceURL = resourceURL
  }

  func getForecast (completion: @escaping(Result<[ForecastDetail], WeatherError>) -> Void) {
    let dataTask = URLSession.shared.dataTask(with: resourceURL) {data, _, _ in
      guard let jsonData = data else {
        completion(.failure(.noDataAvailable))
        return
      }
      do {
        let decoder = JSONDecoder()
        let forecastResponse = try! decoder.decode(Forecast.self, from: jsonData)
        let forecastDetails = forecastResponse.list
        completion(.success(forecastDetails))
      } catch {
        completion(.failure(.canNotProcessData))
      }
    }
    dataTask.resume()
  }
}

print("Enter a French city where you want to see the weather :")
let city = getln()
print("Here's the weather in \(city).")

let json = JsonParser()
let cityDetails = json.loadJson(filename: "cityList", cityname: city)

let currentRequest = CurrentRequest(latitude: cityDetails!.lat, longitude: cityDetails!.lon)

currentRequest?.getCurrent { result in 
  switch result {
    case .failure(let error):
      print(error)
    case .success(let current):
      print("\n")
      print("Current:")
      print("\n")
      let date = Date(timeIntervalSince1970: current.dt)
      let dateFormatter = DateFormatter()
      dateFormatter.timeStyle = DateFormatter.Style.medium
      dateFormatter.dateStyle = DateFormatter.Style.medium
      dateFormatter.timeZone = .current
      let localDate = dateFormatter.string(from: date)
      print("Date: \(localDate)")
      print("Description: \(current.weather[0].description)")
      print("Temperature: \(current.temp)°C")
      print("Wind speed: \(current.wind_speed)m/s")
      print("Clouds: \(current.clouds)%")
  }
}

let forecastRequest = ForecastRequest(latitude: cityDetails!.lat, longitude: cityDetails!.lon)

forecastRequest?.getForecast { result in 
  switch result {
    case .failure(let error):
      print(error)
    case .success(let forecast):
      print("\n")
      print("Forecast:")
      print("\n")
      let date = Date(timeIntervalSince1970: forecast[0].dt)
      let dateFormatter = DateFormatter()
      dateFormatter.timeStyle = DateFormatter.Style.medium
      dateFormatter.dateStyle = DateFormatter.Style.medium
      dateFormatter.timeZone = .current
      let localDate = dateFormatter.string(from: date)
      print("Date: \(localDate)")
      print("Description: \(forecast[0].weather[0].description)")
      print("Temperature: \(forecast[0].main.temp)°C")
  }
}

RunLoop.main.run()