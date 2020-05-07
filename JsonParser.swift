import Foundation

struct City: Decodable {
  let cities: [CityDetails]
}
struct CityDetails: Decodable {
    let id: Int
    let name: String
    let state: String
    let country: String
    let coord: Coord
}

struct Coord: Decodable {
  let lon: Double
  let lat: Double
}

class JsonParser {
  
  func parseJson() -> [CityDetails]? {
    if let localData = self.readLocalFile(forName: "cityList") {
      let cityDetails = self.parse(jsonData: localData)
      return cityDetails!
    }
    return nil
  }
  
  private func readLocalFile(forName name: String) -> Data? {
  do {
      if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
    return nil
  }

  private func parse(jsonData: Data) -> [CityDetails]? {
      do {
          let decodedData = try JSONDecoder().decode(City.self, from: jsonData)
          
          // print("ID: ", decodedData.id)
          // print("Name: ", decodedData.name)
          // print("State: ", decodedData.state)
          // print("Country: ", decodedData.country)
          // print("Lon: ", decodedDatacoord.lon)
          // print("Lat: ", decodedDatacoord.lat)
          // print("===================================")
          //print(decodedData.cities[1].name)
          return decodedData.cities
      } catch {
          print("decode error")
      }
      return nil
  }
  

  func loadJson(filename fileName: String, cityname cityName: String) -> Coord? {
    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(City.self, from: data)
            for city in jsonData.cities {
              if city.name == cityName {
                return city.coord
              }
            }
            //return jsonData.cities
        } catch {
            print("error")
        }
    }
    return nil
}


}