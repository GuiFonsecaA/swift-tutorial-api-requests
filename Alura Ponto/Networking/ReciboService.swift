//
//  ReciboService.swift
//  Alura Ponto
//
//  Created by Guilherme Fonseca on 16/07/23.
//

import Foundation

class ReciboService {
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
}
