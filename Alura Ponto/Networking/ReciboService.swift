//
//  ReciboService.swift
//  Alura Ponto
//
//  Created by Guilherme Fonseca on 16/07/23.
//

import Foundation
import Alamofire

class ReciboService {
    let baseURL = "http://localhost:8080/"
    let path = "recibos"
    var url: String {
        return baseURL + path
    }
    
    func get(completion: @escaping(_ recibos: [Recibo]?, _ error: Error?) -> Void) {
        AF.request(url, method: .get, headers: ["Accept":"application/json"]).responseJSON { resposta in
            switch resposta.result {
            case .success(let json):
                var recibos: [Recibo] = []
                if let listaDeRecibos = json as? [[String: Any]]{
                    for reciboDict in listaDeRecibos {
                        if let novoRecibo = Recibo.serializa(reciboDict){
                            recibos.append(novoRecibo)
                        }
                    }
                    completion(recibos, nil)
                }
                break
            case .failure(let error):
                completion(nil, error)
                break
            }
        }
    }
    
    func post(_ recibo: Recibo, completion: @escaping(_ salvo: Bool) -> Void){
        let baseUrl = "http://localhost:8080/"
        let path = "recibos"
        
        let parametros: [String: Any] = [
            "data": FormatadorDeData().getData(recibo.data),
            "status": recibo.status,
            "localizacao": [
                "latitude": recibo.latitude,
                "longitude": recibo.longitude
            ]
        ]
        
        guard let body = try? JSONSerialization.data(withJSONObject: parametros, options: []) else {return}
        
        guard let url = URL(string: baseUrl + path) else {return}
        
        var requisicao = URLRequest(url: url)
        requisicao.httpMethod = "POST"
        requisicao.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requisicao.httpBody = body
        
        URLSession.shared.dataTask(with: requisicao) { data, resposta, error in
            if error == nil {
                completion(true)
                return
            }
            completion(false)
        }.resume()
    }
    
    func delete(id: String, completion: @escaping() -> Void){
        AF.request("\(url)/\(id)", method: .delete, headers: ["Accept":"application/json"]).responseData { _ in
            completion()
        }
    }
}
