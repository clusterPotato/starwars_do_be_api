import UIKit
struct Person: Decodable{
    let name: String
    let height: String
    let mass: String
    let hair_color: String
    let skin_color: String
    let eye_color: String
    let birth_year: String
    let gender: String
    let homeworld: URL
    let films: [URL]
    let species: [URL]
    let vehicles: [URL]
    let starships: [URL]
    let created: String
    let edited: String
    let url:URL
}
struct Film: Decodable{
    let title: String
//    let episode_id:Int
    let opening_crawl: String
//    let director: String
//    let producer: String
    let release_date: String
//    let characters: [URL]
//    let planets: [URL]
//    let starships: [URL]
//    let vehicles: [URL]
//    let species: [URL]
//    let created: String
//    let edited: String
//    let url: URL
}
class SwapiService{
    static let baseURL = URL(string: "https://swapi.dev/api/")
    static func fetchPerson(id: Int, completion: @escaping(Person?) -> Void){
        //5 step program
        guard let base = baseURL else {return completion(nil)}
        let url = base.appendingPathComponent("people/\(id)")
        URLSession.shared.dataTask(with: url) { data, _ , err in
            if let error = err{
                print("Error in \(#function), line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                return
            }
            guard let data = data else {return completion(nil)}
            do{
                let decoder = JSONDecoder()
//                print(String(data: data, encoding: .utf8))
                let person = try decoder.decode(Person.self, from: data)
                completion(person)
            }catch{
                print("Error in \(#function), line \(#line): \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
        }.resume()
    }
    static func fetchFilm(url: URL, completion: @escaping(Film?) -> Void){
        URLSession.shared.dataTask(with: url) { data, _, err in
            if let error = err{
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            guard let data = data else {return completion(nil)}
            do{
                let film = try JSONDecoder().decode(Film.self, from: data)
                return completion(film)
            }catch{
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
        }.resume()
    }
    static func fetchFilm(id: Int, completion: @escaping(Film?) -> Void){
        guard let base = baseURL else {return completion(nil)}
        //5 step AA program
        let url = base.appendingPathComponent("films/\(id)")
        URLSession.shared.dataTask(with: url) { data, _, err in
            if let error = err{
                print("Error in \(#function), \(#line) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            guard let data = data else {return completion(nil)}
            do{
                let person = try JSONDecoder().decode(Film.self, from: data)
                return completion(person)
            }catch{
                print("Error in \(#function), \(#line): \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
        }.resume()
    }
}
SwapiService.fetchPerson(id: 2) { person in
    guard let person = person else {return}
    print("\(person)\n\nFILMS \(person.name.uppercased()) IS IN\n")
    for url in person.films{
        SwapiService.fetchFilm(url: url) { film in
            print("\(film!)\n")
        }
    }
}

