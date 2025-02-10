//
//  ErrorManager.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 06/02/25.
//

import Foundation

enum ErrorManager {
    
    static func getMessage(for error: APIError) -> String {
        switch error {
        case .invalidURL:
            return "Erro interno: URL inválida."
        case .networkError:
            return "Falha de conexão. Verifique sua internet e tente novamente."
        case .noData:
            return "Nenhuma informação disponível no momento."
        case .rateLimitExceeded:
            return "Você atingiu o limite de requisições. Tente novamente mais tarde."
        case .serverError(let statusCode):
            return "Erro no servidor (Código: \(statusCode)). Tente novamente mais tarde."
        case .decodingError:
            return "Erro ao processar os dados recebidos."
        }
    }
    
    /// Mensagem de erro genérica para situações desconhecidas.
    static let genericErrorMessage = "Ocorreu um erro inesperado. Tente novamente mais tarde."
}
