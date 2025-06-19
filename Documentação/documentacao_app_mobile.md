# 📱 Documentação do Aplicativo Mobile - IMDBest (Flutter)

Este documento descreve a estrutura e as tecnologias utilizadas no desenvolvimento do aplicativo móvel IMDBest, desenvolvido com **Flutter** e linguagem **Dart**, com foco em Android/iOS.

---

## 🛠️ Tecnologias Utilizadas

| Recurso        | Descrição                                        |
|----------------|--------------------------------------------------|
| Linguagem      | Dart                                             |
| Framework      | Flutter (SDK estável mais recente)              |
| UI             | Widgets nativos do Flutter                      |
| Networking     | `http`, `dio`, `provider` ou `riverpod` (conforme uso) |
| Navegação      | `Navigator 2.0`, `GoRouter`, `GetX`, etc.       |
| Estado         | `Provider` / `Riverpod` / `Bloc` (especificar o usado) |

---

## 📂 Estrutura do Projeto

- `lib/main.dart` → Ponto de entrada da aplicação
- `lib/screens/` → Contém as telas (login, filmes, premiações, previsão)
- `lib/widgets/` → Componentes reutilizáveis de UI
- `lib/services/` → Requisições HTTP para APIs (Node.js e Python)
- `lib/models/` → Modelos de dados (Filme, Usuário, Premiação)
- `lib/providers/` → Gerenciamento de estado (se aplicável)

---

## 🖼️ Recursos (Resources)

- `assets/images/` → Ícones, splashscreen, imagens diversas
- `assets/fonts/` → Fontes customizadas utilizadas
- `pubspec.yaml` → Declaração de imagens e fontes
- Splashscreen configurado com `flutter_native_splash`

---

## 🧭 Navegação de Telas

- Implementada com `Navigator` ou `GoRouter` (especifique o usado)
- Fluxo típico:
  - `LoginPage` → `HomePage`
  - `HomePage` com abas: Filmes, Premiações, Perfil
  - Telas de detalhe acessadas via push

---

## 🧩 Principais Classes e Arquivos

- `api_service.dart` → Gerencia requisições HTTP
- `auth_service.dart` → Lógica de login/cadastro com armazenamento do token
- `filme_model.dart`, `premiacao_model.dart`, `usuario_model.dart`
- `login_screen.dart`, `filmes_screen.dart`, `previsao_screen.dart`

---

## 🧰 Principais Widgets de UI

- `Text`, `TextField`, `ElevatedButton`, `Image`, `AppBar`
- `ListView.builder`, `GridView`, `FutureBuilder`, `Card`
- `BottomNavigationBar` ou `TabBar`
- `SnackBar`, `Dialog`, `CircularProgressIndicator`

---

## 🖼️ Protótipos e Prints

As telas foram prototipadas no Figma e/ou capturadas diretamente no app rodando em emulador.

Serão incluídas na pasta:  
📁 `/DOCUMENTAÇÃO/figma/` ou `/DOCUMENTAÇÃO/prints/`

### Telas incluídas:
- Login e Cadastro
- Lista de Filmes com informações do IMDB
- Lista de Premiações com ano e vencedores
- Tela de previsão de chances de premiação com botão de consulta

---

## 🔐 Integração com API

- As requisições são feitas via `http` ou `dio`
- Headers de autenticação incluem o token JWT:

---

Authorization: Bearer SEU_TOKEN

- As previsões são feitas via POST para a API Python `/predict`
- A listagem de dados vem da API Node.js (hosteada na nuvem)

---

## ✅ Observações

- O app é **multiplataforma (Android/iOS)**, responsivo e moderno
- Estruturado para manutenção e evolução (modularização, providers)
- Documentado e comentado para fins acadêmicos