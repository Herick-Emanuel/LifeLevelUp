# Life Level Up

Aplicativo de gerenciamento de hábitos e desenvolvimento pessoal.

## Requisitos

- Flutter (versão mais recente)
- Dart (versão mais recente)
- Android Studio / VS Code
- Git

## Instalação

1. Clone o repositório
2. Instale as dependências:

```bash
flutter pub get
```

3. Configure os assets:

   - Adicione o ícone do app em `assets/icons/app_icon.png`
   - Adicione a imagem de splash em `assets/images/splash.png`
   - Adicione as fontes em `assets/fonts/`

4. Gere os ícones e a tela de splash:

```bash
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash:create
```

5. Execute o app:

```bash
flutter run
```

## Estrutura do Projeto

```
lib/
├── core/
│   ├── config/     # Configurações
│   ├── theme/      # Temas
│   └── utils/      # Utilitários
├── features/       # Funcionalidades
│   ├── auth/       # Autenticação
│   ├── habits/     # Hábitos
│   ├── profile/    # Perfil
│   └── settings/   # Configurações
└── shared/         # Compartilhado
    ├── widgets/    # Widgets
    ├── models/     # Modelos
    └── services/   # Serviços
```

## Funcionalidades

- Autenticação de usuários
- Gerenciamento de hábitos
- Perfil do usuário
- Configurações
- Notificações
- Estatísticas
- Ranking

## Tecnologias Utilizadas

- Flutter
- Provider
- BLoC
- Go Router
- Dio
- Hive
- Flutter Secure Storage
- Flutter Local Notifications
- Fl Chart
- Syncfusion Charts

## Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request
