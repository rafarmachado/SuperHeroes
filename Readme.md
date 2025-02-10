# SuperHeroes App - README 📖

## 📌 Introdução

Bem-vindo ao **SuperHeroes**, um aplicativo iOS desenvolvido para listar personagens da Marvel, permitindo favoritar e visualizar detalhes de cada um. Este projeto foi desenvolvido seguindo **princípios do SOLID, Clean Code** e **boas práticas de arquitetura**, garantindo escalabilidade e facilidade de manutenção.

A aplicação utiliza **MVVM (Model-View-ViewModel)** como padrão arquitetural, combinado com a **injeção de dependências** e **gerenciamento eficiente de cache** para otimizar o carregamento de imagens e dados.

---

## 🚀 Como executar o projeto

### ✅ **Pré-requisitos**
1. **Xcode 15+**
2. **Swift 5+**
3. **Cocoapods instalado (se houver dependências externas)**

### ▶️ **Passos para rodar o app**
1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-usuario/superheroes.git
   ```
2. Acesse a pasta do projeto:
   ```bash
   cd superheroes
   ```
3. Abra o projeto no Xcode:
   ```bash
   open SuperHeroes.xcodeproj
   ```
4. Compile e execute no simulador ou dispositivo real (iPhone).

---

## 🔐 Segurança da Private Key

Por **motivos de segurança**, a **chave privada** da API **não foi commitada** no repositório.  
Para gerar sua própria chave, siga estes passos:

1. **Crie uma conta no portal da Marvel Developer**:  
   👉 [https://developer.marvel.com/](https://developer.marvel.com/)

2. **Gere suas chaves pública e privada**.

3. **Adicione sua chave privada ao projeto** dentro do arquivo `SecureConstants.swift`, substituindo a chave existente:

   ```swift
   // SecureConstants.swift

   struct SecureConstants {
       static let publicKey: String = {
       ...
       } else {
               let initialKey = "SUA_PRIVATE_KEY_AQUI" // Insira sua Private Key aqui
                ...
           }
       }
   }
```
   
---

## 📂 Estrutura do Projeto

O projeto segue uma organização modularizada, dividida em camadas claras:

```plaintext
SuperHeroes/
├── App/
│   ├── AppCoordinator.swift
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│
├── Core/
│   ├── Base/
│   │   ├── BaseListView.swift
│   ├── Database/
│   │   ├── CacheManager.swift
│   │   ├── CoreDataManager.swift
│   │   ├── FavoritesManager.swift
│   │   ├── ImageCacheManager.swift
│   ├── Networking/
│   │   ├── ApiService.swift
│   │   ├── ImageLoader.swift
│   ├── Protocols/
│   │   ├── FavoritesRepositoryProtocol.swift
│   │   ├── ViewModelDelegate.swift
│   ├── Utilities/
│   │   ├── ApiError.swift
│   │   ├── ErrorManager.swift
│   │   ├── NetworkMonitor.swift
│   │   ├── SecureConstants.swift
│
├── Features/
│   ├── Characters/
│   │   ├── Model/
│   │   │   ├── MarvelCharacter.swift
│   │   ├── ViewModel/
│   │   │   ├── CharactersViewModel.swift
│   │   ├── Controller/
│   │   │   ├── CharactersViewController.swift
│   │   ├── View/
│   │   │   ├── CharactersView.swift
│   │   │   ├── CharacterCell.swift
│   │   ├── Service/
│   │   │   ├── CharactersService.swift
│
│   ├── CharactersDetail/
│   │   ├── ViewModel/
│   │   │   ├── CharacterDetailViewModel.swift
│   │   ├── Controller/
│   │   │   ├── CharacterDetailViewController.swift
│   │   ├── View/
│   │   │   ├── CharacterDetailView.swift
│
│   ├── Favorites/
│   │   ├── ViewModel/
│   │   │   ├── FavoritesViewModel.swift
│   │   ├── Controller/
│   │   │   ├── FavoritesViewController.swift
│   │   ├── View/
│   │   │   ├── FavoritesView.swift
│
├── Tests/
│   ├── SuperHeroesTests/
│   ├── SuperHeroesUITests/
```

Cada módulo segue o princípio de responsabilidade única, facilitando a manutenção e expansão do projeto.

---

## 🎯 **Decisões Técnicas e Arquiteturais**

### 🔹 **Arquitetura MVVM**
O projeto segue **MVVM (Model-View-ViewModel)**, separando a lógica de negócio (ViewModel) da interface gráfica (ViewController). Isso melhora a testabilidade e evita ViewControllers muito carregados.

- **Model**: Representa os dados (exemplo: `MarvelCharacter.swift`).
- **View**: Interface gráfica e interações com o usuário.
- **ViewModel**: Processa a lógica de negócios e comunica-se com a `ViewController`.

---

### 🔹 **Gerenciamento de Dependências**
Adotamos **injeção de dependências** para desacoplar os componentes do sistema, tornando-os **testáveis e fáceis de substituir**.

Exemplo:
```swift
init(viewModel: CharacterDetailViewModelProtocol) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
}
```
Isso permite passar diferentes implementações do `ViewModel` nos testes, sem depender diretamente de classes concretas.

---

### 🔹 **Uso de Singletons**
Usamos singletons em componentes que devem compartilhar estados globalmente, como **CacheManager**, **FavoritesManager**, e **NetworkMonitor**. Isso **evita múltiplas instâncias desnecessárias** e melhora a eficiência.

Exemplo:
```swift
final class CacheManager {
    static let shared = CacheManager()
    private init() {}
}
```

---

### 🔹 **Uso de Cache**
Para otimizar a performance, implementamos um **cache de imagens** (`ImageCacheManager.swift`). Isso evita downloads repetidos e melhora a experiência do usuário.

Exemplo:
```swift
if let cachedImage = CacheManager.shared.loadImage(for: imageUrl) {
    completion(cachedImage)
    return
}
```

---

### 🔹 **Princípios SOLID Aplicados**
O código segue os **princípios SOLID**, garantindo modularidade e facilidade de manutenção:

1. **Single Responsibility Principle (SRP)**  
   - Cada classe tem uma única responsabilidade.  
   - Exemplo: `ApiService.swift` **só lida com chamadas de API**.

2. **Open-Closed Principle (OCP)**  
   - O código é **extensível sem modificação**.  
   - Exemplo: `ImageLoader.swift` pode ser substituído sem alterar a lógica central.

3. **Liskov Substitution Principle (LSP)**  
   - Substituímos `FavoritesRepositoryProtocol` sem alterar o código existente.  

4. **Interface Segregation Principle (ISP)**  
   - Interfaces pequenas e específicas (`ViewModelDelegate` e `FavoritesManagerDelegate`).

5. **Dependency Inversion Principle (DIP)**  
   - `ViewModel`s recebem **protocolos** em vez de instâncias concretas.  

---

## ✅ **Testes e Cobertura**
O projeto contém testes unitários para validar a lógica de negócio, garantindo estabilidade e previsibilidade.

Exemplo de Teste Unitário:
```swift
func testSearchCharacters_ShouldFilterResults() {
    let mockCharacters = [
        MarvelCharacter(id: 1, name: "Spider-Man"),
        MarvelCharacter(id: 2, name: "Iron Man")
    ]
    
    viewModel.allCharacters = mockCharacters  
    viewModel.searchCharacter(with: "Iron")

    XCTAssertEqual(viewModel.filteredCharacters.count, 1)
    XCTAssertEqual(viewModel.filteredCharacters.first?.name, "Iron Man")
}
```
Os testes podem ser executados através do Xcode:
- Para rodar os **testes unitários**, pressione `Cmd + U`
- Para rodar os **testes de interface**, utilize a guia de Test Navigator no Xcode
---

## 🛠 Engenharia de Prompt

Abaixo estão alguns exemplos de **prompts utilizados durante o desenvolvimento do projeto** para **refatoração de código**, **rastreamento de erros**, **logs de depuração** e **criação de assets**:

### 📌 Refatoração de Código  
**"Refactor the `FavoritesManager` class to use a `CoreDataManager` protocol without removing any functionalities."**  

### 📌 Rastreamento de Erros  
**"I'm having an issue saving images in `CacheManager`. The error returned is: 'The file doesn’t exist'. How can I fix this?"**  

### 📌 Logs de Depuração  
**"Add detailed print statements in the `CharactersViewModel` loading flow to identify where the loading state is being incorrectly modified."**  

### 📌 Ideias para Splash Screen & Ícone do App  
**"I want a splash screen that matches the Marvel superheroes theme. Any ideas for colors and graphic elements for the design?"**  

---

## 📌 **Conclusão**
Este projeto foi estruturado para **ser escalável, testável e performático**, seguindo **boas práticas de arquitetura, SOLID, Clean Code** e utilizando **cache e singletons onde faz sentido**.

Caso tenha dúvidas ou sugestões, fique à vontade para abrir um **Issue** ou um **Pull Request**. 🚀

---

**Autor:** Rafael Rezende Machado
**Contato:** rafael.rezendem@hotmail.com
