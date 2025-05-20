# Habit Manager Backend

Backend para o sistema de gerenciamento de hábitos e desenvolvimento pessoal.

## Requisitos

- Node.js (v14 ou superior)
- PostgreSQL
- npm ou yarn

## Instalação

1. Clone o repositório
2. Instale as dependências:

```bash
npm install
```

3. Crie um arquivo `.env` na raiz do projeto com as seguintes variáveis:

```
NODE_ENV=development
PORT=3000
DB_HOST=localhost
DB_PORT=5432
DB_NAME=habit_manager
DB_USER=postgres
DB_PASSWORD=postgres
JWT_SECRET=seu_jwt_secret_aqui
JWT_EXPIRATION=24h
```

4. Configure o banco de dados PostgreSQL e crie um banco de dados chamado `habit_manager`

## Scripts Disponíveis

- `npm start`: Inicia o servidor em modo produção
- `npm run dev`: Inicia o servidor em modo desenvolvimento com hot-reload
- `npm test`: Executa os testes
- `npm run lint`: Executa o linter
- `npm run format`: Formata o código

## Estrutura do Projeto

```
habit_backend/
├── config/         # Configurações
├── controllers/    # Controladores
├── middlewares/    # Middlewares
├── models/         # Modelos do banco de dados
├── routes/         # Rotas da API
├── app.js         # Arquivo principal
└── package.json   # Dependências e scripts
```

## API Endpoints

- `/auth`: Autenticação
- `/users`: Gerenciamento de usuários
- `/habits`: Gerenciamento de hábitos
- `/journal`: Diário
- `/motivation`: Sistema de motivação
- `/missions`: Missões
- `/customization`: Personalização
- `/ranking`: Sistema de ranking
- `/events`: Eventos

## Segurança

- CORS habilitado
- Helmet para proteção de headers
- JWT para autenticação
- Validação de dados com express-validator
- Logging com Winston

## Logs

Os logs são salvos em:

- `error.log`: Logs de erro
- `combined.log`: Todos os logs

## Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request
