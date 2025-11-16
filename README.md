## Reminder App
O Reminder App é uma aplicação para controle de lembretes pessoais com autenticação de usuário, registro de novos lembretes e consulta automática de previsão do tempo para a data do lembrete. O projeto utiliza Flutter para o front-end mobile/web e permite cadastro, login, remoção e edição de lembretes, apresentando interface moderna, rápida e responsiva.

## Tecnologias Utilizadas
- Flutter (UI mobile/web)
- Provider (gerenciamento de estado)
- Firebase Auth (autenticação)
- Firebase Firestore (armazenamento backend de lembretes)
- Pacote intl (formatação de datas)
- API de Clima (consulta clima para os lembretes)

## Passos para Instalação e Execução
Clone o repositório:

```
git clone https://github.com/SantosJoaoGabriel/ReminderFlutter.git
```
Instale as dependências do Flutter:
```
npm install
flutter pub get
npm install firebase
```

Configure suas credenciais do Firebase:

No seu navegador faça login no site do Firebase, logo após fazer login vá até Firebase Console e crie um novo projeto do Firebase com nome de rpg-builder e siga os passos do Firebase.
Depois de criar sua Firebase na visão geral do projeto terá um engrenagem e nela terá a opção de configurar seu projeto Geral -> Adicionar Aplicativo -> web -> Nome do app rpg-builder -> site do Firebase hosting vinculado selecionar seu projeto.
- Após realizar tudo isso no seu vsCode na pasta lib edite seu firebase_options.dart com as informações que estão no seu Firebase Web.

## Configurações da API

Em https://www.weatherapi.com faça registro e gera uma chave para API.

Depois dentro do projeto em lib > services > weather_service.dart adicione em apiKey = 'SuaChaveApi';
