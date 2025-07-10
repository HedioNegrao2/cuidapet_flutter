# Cuidapet 🐾
Projeto baseado no curso  Academia do Flutter

Um aplicativo Flutter para conectar donos de pets com prestadores de serviços especializados em cuidados animais, com uma API REST robusta para gerenciar todas as operações.

## 📝 Sobre o Projeto

O Cuidapet é uma plataforma completa que facilita a conexão entre tutores de animais de estimação e profissionais especializados em cuidados pet. O projeto é dividido em duas partes principais:

- **Aplicativo Mobile (Flutter)**: Uma interface intuitiva para os usuários encontrarem, agendarem e avaliarem serviços.
- **API REST (Dart + Shelf)**: O backend que gerencia todos os dados, desde usuários e fornecedores até agendamentos e chat.

---

## 📱 Aplicativo Mobile (Cuidapet App)

O aplicativo mobile, desenvolvido com Flutter, oferece uma experiência de usuário fluida e completa para donos de pets.

### ✨ Funcionalidades do App

- 🐕 Cadastro e gerenciamento de serviços
- 🏥 Busca por serviços veterinários e pet shops
- 📅 Agendamento de  serviços
- 📍 Localização de estabelecimentos próximos
- 👤 Perfil de usuário e histórico de serviços
-

### 🛠️ Tecnologias Utilizadas no App

- **Flutter** - Framework para desenvolvimento mobile
- **Dart** - Linguagem de programação
- **Firebase** - Backend e autenticação
- **Google Maps** - Serviços de localização


### 🚀 Executando o Aplicativo

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/HedioNegrao2/cuidapet_flutter.git
   ```

2. **Navegue até o diretório do aplicativo:**
   ```bash
   cd cuidapet/cuidapet32
   ```

3. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

4. **Execute o aplicativo:**
   ```bash
   flutter run
   ```

---

## ⚙️ API REST (Cuidapet API)

A API do Cuidapet, construída com Dart e o framework Shelf, é o cérebro por trás da plataforma, garantindo segurança e eficiência.

### ✨ Funcionalidades da API

- 🔐 **Autenticação JWT** - Sistema de login seguro com tokens JWT
- 👥 **Gerenciamento de Usuários** - Cadastro, login e atualização de perfil
- 🏪 **Fornecedores** - Cadastro e gerenciamento de prestadores de serviços
- 📅 **Agendamentos** - Sistema completo de agendamento de serviços
- 💬 **Chat** - Sistema de chat entre usuários e fornecedores
- 🗺️ **Geolocalização** - Busca de fornecedores por localização
- 📱 **Notificações Push** - Gerenciamento de tokens de dispositivos
- 🏷️ **Categorias** - Sistema de categorização de serviços


### 🛠️ Tecnologias Utilizadas na API

- **Dart** - Linguagem de programação
- **Shelf** - Framework web para Dart
- **MySQL** - Banco de dados relacional
- **JWT** - Autenticação via JSON Web Tokens
- **Docker** - Containerização da aplicação

### 🚀 Executando a API

#### Com Dart SDK

1. **Navegue até o diretório da API:**
   ```bash
   cd cuidapet/cuidapet_api
   ```

2. **Crie o arquivo `.env`** com as configurações de ambiente (veja a seção de configuração abaixo).

3. **Instale as dependências:**
   ```bash
   dart pub get
   ```

4. **Execute o servidor:**
   ```bash
   dart run bin/server.dart
   ```
   O servidor estará rodando em `http://localhost:8080`.

#### Com Docker

1. **Navegue até o diretório da API:**
   ```bash
   cd cuidapet/cuidapet_api
   ```

2. **Construa a imagem:**
   ```bash
   docker build . -t cuidapet-api
   ```

3. **Execute o container:**
   ```bash
   docker run -it -p 8080:8080 cuidapet-api
   ```

### 🔧 Configuração da API

Crie um arquivo `.env` na raiz do diretório `cuidapet_api` com o seguinte conteúdo:

```env
# Banco de dados
DB_HOST=localhost
DB_PORT=3306
DB_NAME=cuidapet
DB_USER=root
DB_PASSWORD=password

# JWT
JWT_SECRET=your_jwt_secret_key

# Servidor
PORT=8080
```

---


## 📄 Licença

Este projeto está sob a licença MIT.

## 👨‍💻 Contato

- **Hedio Negrao** - GitHub: [@HedioNegrao2](https://github.com/HedioNegrao2)


