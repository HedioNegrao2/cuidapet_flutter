# Cuidapet API 🐾

Uma API REST construída com [Shelf](https://pub.dev/packages/shelf) para conectar donos de pets com prestadores de serviços de cuidados para animais de estimação.

## 📋 Sobre o Projeto

A Cuidapet API é o backend do aplicativo Cuidapet, fornecendo endpoints para autenticação, gerenciamento de usuários, fornecedores, agendamentos e chat. A API é construída em Dart usando o framework Shelf e está configurada para execução com Docker.

## ✨ Funcionalidades

- 🔐 **Autenticação JWT** - Sistema de login seguro com tokens JWT
- 👥 **Gerenciamento de Usuários** - Cadastro, login e atualização de perfil
- 🏪 **Fornecedores** - Cadastro e gerenciamento de prestadores de serviços
- 📅 **Agendamentos** - Sistema completo de agendamento de serviços
- 💬 **Chat** - Sistema de chat entre usuários e fornecedores
- 🗺️ **Geolocalização** - Busca de fornecedores por localização
- 📱 **Notificações Push** - Gerenciamento de tokens de dispositivos
- 🏷️ **Categorias** - Sistema de categorização de serviços

## 🛠️ Tecnologias Utilizadas

- **Dart** - Linguagem de programação
- **Shelf** - Framework web para Dart
- **MySQL** - Banco de dados relacional
- **JWT** - Autenticação via JSON Web Tokens
- **Docker** - Containerização da aplicação

## 📦 Dependências

```yaml
dependencies:
  shelf: ^1.4.0
  dotenv: ^3.0.0          # Gerenciamento de variáveis de ambiente
  mysql1: ^0.20.0         # Comunicação com banco de dados MySQL
  get_it: ^7.7.0          # Service locator
  injectable: ^1.1.2      # Gerenciador de dependências
  logger: ^1.0.0          # Gerador de logs
  jaguar_jwt: ^3.0.0      # JWT para autenticação
```

## 🚀 Executando o Projeto

### Com Dart SDK

```bash
# Instalar dependências
dart pub get

# Executar servidor
dart run bin/server.dart
```

O servidor estará rodando em `http://localhost:8080`

### Com Docker

```bash
# Construir imagem
docker build . -t cuidapet-api

# Executar container
docker run -it -p 8080:8080 cuidapet-api
```

## 🌐 Endpoints da API

### Autenticação

#### Login
```http
POST /auth/
Content-Type: application/json

{
  "login": "user@example.com",
  "password": "password",
  "social_login": false,
  "supplier_user": false
}
```

#### Login Social
```http
POST /auth/
Content-Type: application/json

{
  "login": "user@example.com",
  "social_login": true,
  "avatar": "avatar_url",
  "supplier_user": false,
  "social_key": "social_id",
  "social_type": "FACEBOOK"
}
```

#### Confirmação de Login
```http
PATCH /auth/confirm
Content-Type: application/json

{
  "login": "user@example.com",
  "password": "password"
}
```

#### Refresh Token
```http
PUT /auth/refresh
Authorization: Bearer <token>
```

### Usuários

#### Obter Usuário por Token
```http
GET /user/
Authorization: Bearer <token>
```

#### Atualizar Avatar
```http
PUT /user/avatar
Authorization: Bearer <token>
Content-Type: application/json

{
  "url_avatar": "new_avatar_url"
}
```

#### Atualizar Token do Dispositivo
```http
PUT /user/device
Authorization: Bearer <token>
Content-Type: application/json

{
  "token": "device_token",
  "platform": "ANDROID|IOS"
}
```

### Categorias

#### Listar Categorias
```http
GET /categories/
Authorization: Bearer <token>
```

### Fornecedores

#### Buscar por Geolocalização
```http
GET /suppliers/?lat={latitude}&lng={longitude}
Authorization: Bearer <token>
```

#### Obter Fornecedor por ID
```http
GET /suppliers/{id}
Authorization: Bearer <token>
```

#### Verificar Email do Fornecedor
```http
GET /suppliers/user?email={email}
Authorization: Bearer <token>
```

#### Cadastrar Fornecedor
```http
POST /suppliers/user
Authorization: Bearer <token>
Content-Type: application/json

{
  "supplierName": "Nome do Fornecedor",
  "email": "fornecedor@example.com",
  "password": "password",
  "category_id": 1
}
```

#### Atualizar Dados do Fornecedor
```http
PUT /suppliers/
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "Nome Atualizado",
  "email": "email@example.com",
  "password": "new_password",
  "category": 1,
  "logo": "logo_url",
  "address": "Endereço",
  "phone": "123456789",
  "lat": -23.561472512749365,
  "lng": -46.65636555396984
}
```

#### Listar Serviços do Fornecedor
```http
GET /suppliers/{id}/services
Authorization: Bearer <token>
```

### Agendamentos

#### Criar Agendamento
```http
POST /schedules/
Authorization: Bearer <token>
Content-Type: application/json

{
  "schedule_date": "2021-06-15T10:00:00",
  "supplier_id": 1,
  "services": [1, 2, 3],
  "name": "Nome do Cliente",
  "pat_name": "Nome do Pet"
}
```

#### Atualizar Status do Agendamento
```http
PUT /schedules/{id}/status/{status}
Authorization: Bearer <token>
```

#### Listar Agendamentos do Usuário
```http
GET /schedules/
Authorization: Bearer <token>
```

#### Listar Agendamentos do Fornecedor
```http
GET /schedules/supplier
Authorization: Bearer <token>
```

### Chat

#### Iniciar Chat
```http
POST /chats/schedule/{schedule_id}/start-chat
Authorization: Bearer <token>
```

#### Listar Chats do Usuário
```http
GET /chats/user
Authorization: Bearer <token>
```

#### Listar Chats do Fornecedor
```http
GET /chats/supplier
Authorization: Bearer <token>
```

#### Finalizar Chat
```http
PUT /chats/{id}/end-chat
Authorization: Bearer <token>
```

## 🔧 Configuração

### Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto:

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

### Banco de Dados

A API utiliza MySQL como banco de dados. Certifique-se de ter o MySQL instalado e configurado com as tabelas necessárias.

## 📝 Logs

O sistema de logs está configurado para exibir informações detalhadas sobre as requisições:

```
2021-05-06T15:47:04.620417  0:00:00.000158 GET     [200] /
2021-05-06T15:47:08.392928  0:00:00.001216 GET     [200] /suppliers/
```

## 🤝 Contribuindo

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT.

## 👨‍💻 Autor

**Hedio Negrao**
- GitHub: [@HedioNegrao2](https://github.com/HedioNegrao2)

---

⭐ Se este projeto te ajudou, considere dar uma estrela!