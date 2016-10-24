//
//  Pokemon.swift
//  100-Pokedex
//
//  Created by Brian Leip on 10/14/16.
//  Copyright © 2016 Triskelion Studios. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    fileprivate var _name: String!
    fileprivate var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _defense: String!
    private var _nextEvolutionText: String!
    private var _nextEvolutionID: String!
    private var _pokemonURL: String!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionText == nil {
            _nextEvolutionText = ""
        }
        return _nextEvolutionText
    }
    
    var nextEvolutionID: String {
        if _nextEvolutionID == nil {
            _nextEvolutionID = ""
        }
        return _nextEvolutionID
    }
    
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete) {
        
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                
                if let types = dict["types"] as? [Dictionary<String, String>] , types.count > 0 {
                    // pokemon can have multiple types so we are finding the types and putting them into an array of Dictionaries cast as String/String
                    
                    if let type1 = types[0]["name"] {
                        self._type = type1.capitalized
                    }
                    
                    if types.count > 1 {
                        
                        for x in 1..<types.count {
                            if let typex = types[x]["name"] {
                                self._type! += "/\(typex.capitalized)"
                            }
                        }
                    }
                    print(self._type)
                    
                } else {
                    self._type = ""
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>], descArr.count > 0 {
                    // the pokeAPI has descriptions laid out in an odd way.  They have different descriptions for each pokemon generation, and for each gen they provide a URL to a separate JSON database
                    
                    
                    if var descURL = descArr[0]["resource_uri"] {
                        descURL = URL_BASE + descURL
                        print(descURL)

                        Alamofire.request(descURL).responseJSON(completionHandler: { (response) in
                            //print(response.result.value)
                            
                            if let descDict = response.result.value as? Dictionary<String, Any> {
                                if let desc = descDict["description"] {
                                    let newDescription = (desc as AnyObject).replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = "\(newDescription)"
                                    print("\(newDescription)")
                                }
                            }
                            completed()
                        })
                    }
                } else {
                    self._description = ""
                }
                
                if let evolArr = dict["evolutions"] as? [Dictionary<String, Any>], evolArr.count > 0 {
                    if let nextEvo = evolArr[0]["to"] as? String {
                        
                        if nextEvo.range(of: "mega") == nil {
                            // mega pokemon not supported in this app so filter them out
                            self._nextEvolutionText = "Next Evolution: \(nextEvo)"
                            
                            if let levelEvo = evolArr[0]["level"] {
                                self._nextEvolutionText = "\(self._nextEvolutionText!) Lvl \(levelEvo)"
                                print(self._nextEvolutionText!)
                                
                            } else {
                                //self._nextEvolutionText = "no level?"
                            }
                            
                            if let uri = evolArr[0]["resource_uri"] as? String {
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                self._nextEvolutionID = nextEvoId
                            } else {
                                self._nextEvolutionID = ""
                            }
                            
                        } else {
                            self._nextEvolutionText = "Mega - not supported in this app"
                        }
                    } else {
                        self._nextEvolutionText = "Fully Evolved"
                    }
                    

                } else {
                    self._nextEvolutionText = "Fully Evolved"
                }
                
                
            }
            
            completed()
        }
        
    }
    
    
}
