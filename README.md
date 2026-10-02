## 👥 Integrantes e responsabilidades

| Integrante | RM | Responsabilidades |
| ---------- | -- | ----------------- |
| Bruno Anselmo da Silva | RM 566521 | Desenvolvimento de marca, modelo de negócio e pitch |
| Fernando de Almeida Godoi Martines | RM 564820 | Identidade visual, tipografia, paleta de cores e padronização das interfaces |
| Gabriel Ber Soares Tarone | RM 563520 | Documentação, README e organização da entrega |
| Guilherme de Freitas Salgado | RM 562494 | Criação e organização das imagens, materiais visuais e estrutura |
| Vinicius Ribeiro Dias | RM 566468 | Desenvolvimento da interface inicial, componentes e execução do projeto Flutter |

---

# NutriGo 🥗

O **NutriGo** é um aplicativo desenvolvido em Flutter voltado para pessoas que desejam melhorar sua alimentação de forma simples, prática e social.

A plataforma combina **descoberta e compartilhamento de receitas, organização de favoritos e acompanhamento do usuário**, criando uma experiência em que as pessoas podem encontrar inspiração para suas refeições e compartilhar suas próprias receitas.

---

# 📌 Sobre o projeto

## Problema

Manter uma alimentação equilibrada pode ser difícil. Muitas pessoas têm vontade de melhorar seus hábitos alimentares, mas encontram obstáculos como falta de ideias para refeições, dificuldade em manter uma rotina, excesso de informações conflitantes e pouca motivação para continuar.

O **NutriGo** busca tornar esse processo mais acessível ao reunir receitas, organização e interação em uma única aplicação.

Em vez de apenas oferecer informações sobre dieta, o aplicativo busca criar uma experiência na qual os usuários possam descobrir receitas, publicar suas próprias opções, organizar seus favoritos e encontrar inspiração para suas refeições.

---

# 🎯 Público-alvo

O aplicativo é destinado principalmente a:

- Pessoas que desejam melhorar seus hábitos alimentares;
- Usuários que procuram receitas práticas e variadas;
- Pessoas que desejam organizar melhor sua alimentação;
- Usuários interessados em diferentes estilos alimentares;
- Pessoas que encontram motivação por meio do compartilhamento de experiências.

---

# 🚀 Status atual do projeto

O NutriGo encontra-se em desenvolvimento como aplicativo **Flutter/Dart**, com integração ao **Supabase** para autenticação, gerenciamento de usuários, persistência de receitas, armazenamento de imagens, favoritos e coleções.

O projeto já possui as seguintes funcionalidades implementadas:

- **Autenticação:** cadastro, login, recuperação e alteração de senha, além do gerenciamento de sessão por meio do Supabase Auth.
- **Perfis e configurações:** carregamento e edição das informações do usuário, preferências alimentares e configuração de notificações, com persistência dos dados no PostgreSQL.
- **Receitas:** cadastro, consulta, edição e exclusão de receitas, com persistência no Supabase.
- **Imagens:** envio, substituição e exclusão de fotografias utilizando Supabase Storage.
- **Favoritos:** adição e remoção de receitas favoritas, com persistência por usuário no banco de dados.
- **Coleções:** criação, consulta, edição e exclusão de coleções personalizadas de receitas, com persistência por usuário no Supabase.
- **Sessão do usuário:** restauração automática da sessão autenticada, permitindo que o usuário retorne ao aplicativo sem realizar um novo login enquanto a sessão permanecer válida.
- **Perfil e progresso:** exibição dinâmica de receitas publicadas, curtidas recebidas, usuários seguidos, nível e pontuação.
- **Relacionamentos entre usuários:** estrutura de seguidores implementada no Supabase, com controle de segurança por RLS.
- **Tratamento de carregamento:** exibição de indicador durante o carregamento dos dados e tratamento de falhas com opção de nova tentativa.
- **Segurança:** utilização de políticas Row Level Security (RLS) para controlar o acesso aos dados e arquivos.
- **Integridade dos dados:** utilização de chaves estrangeiras e restrições de unicidade para evitar registros duplicados em favoritos, relacionamentos entre usuários e vínculos entre receitas e coleções.
- **Navegação:** integração entre Home, Explorar Receitas, Favoritos, Perfil e telas de gerenciamento de receitas.

O aplicativo combina receitas demonstrativas com receitas cadastradas no banco de dados.

As funcionalidades de persistência de receitas, gerenciamento de imagens, favoritos, coleções, preferências alimentares e configurações de notificações foram implementadas e testadas.

O projeto continua em evolução, com melhorias e funcionalidades adicionais previstas para as próximas etapas.


---

# ✨ Funcionalidades implementadas

## 👤 Autenticação e usuários

- Cadastro de novos usuários;
- Login com e-mail e senha;
- Autenticação utilizando Supabase Auth;
- Validação dos campos de cadastro e login;
- Recuperação de senha por e-mail;
- Envio do link de recuperação utilizando Supabase Auth;
- Redirecionamento para o aplicativo por meio de deep link no Android;
- Tela para definição e confirmação da nova senha;
- Atualização da senha do usuário autenticado;
- Encerramento da sessão de recuperação após a alteração da senha;
- Retorno automático à tela de login após a redefinição;
- Armazenamento do perfil do usuário;
- Identificação do usuário autenticado;
- Exibição dinâmica do nome do usuário na Home;
- Gerenciamento de sessão utilizando Supabase Auth;
- Restauração automática da sessão autenticada ao iniciar o aplicativo;
- Redirecionamento automático para a aplicação quando existe uma sessão válida;
- Retorno à tela de login após o encerramento da sessão;
- Exibição dinâmica do nome e e-mail do usuário na tela de Perfil;
- Edição do nome do usuário pela tela de Configurações;
- Persistência das alterações do perfil no Supabase PostgreSQL;
- Atualização automática dos dados exibidos no Perfil após a edição;
- Alteração de senha pelo usuário autenticado na tela de Configurações;
- Validação da nova senha e confirmação antes da atualização;
- Configuração das preferências alimentares do usuário;
- Seleção de múltiplas preferências, como vegetariana, vegana, sem lactose, sem glúten, low carb e saudável;
- Persistência das preferências alimentares no perfil do usuário no Supabase PostgreSQL;
- Recuperação automática das preferências alimentares salvas;
- Ativação e desativação das notificações pela tela de Configurações;
- Persistência da configuração de notificações no Supabase PostgreSQL;
- Recuperação automática da configuração de notificações entre sessões;
- Exibição da quantidade de receitas publicadas pelo usuário;
- Contabilização de curtidas recebidas nas receitas publicadas;
- Contabilização de usuários seguidos;
- Sistema de pontuação baseado na atividade do usuário;
- Exibição dinâmica do nível do usuário de acordo com sua pontuação.

## 🍳 Receitas

O NutriGo permite consultar e gerenciar receitas, utilizando o **Supabase PostgreSQL** para armazenar as receitas publicadas.

Funcionalidades implementadas:

- Visualização de receitas demonstrativas e receitas cadastradas no Supabase;
- Tela de detalhes das receitas;
- Busca por nome e categoria;
- Filtros por categorias;
- Publicação de novas receitas;
- Cadastro de ingredientes e modo de preparo;
- Informações de tempo, dificuldade, calorias e categorias alimentares;
- Visualização das receitas publicadas pelo próprio usuário;
- Edição de receitas existentes;
- Exclusão de receitas publicadas pelo usuário;
- Persistência das receitas na tabela `recipes`;
- Associação das receitas aos usuários autenticados por meio de identificadores UUID.

### 📷 Imagens das receitas

As imagens são gerenciadas utilizando o **Supabase Storage**, no bucket `receitas`.

O aplicativo permite:

- Selecionar imagens da galeria;
- Enviar imagens JPG, PNG e WebP, com limite de 5 MB;
- Armazenar as imagens em pastas associadas ao usuário autenticado;
- Exibir as imagens armazenadas no Supabase;
- Substituir imagens durante a edição de receitas;
- Excluir imagens vinculadas a receitas removidas;
- Remover imagens antigas após a substituição, evitando arquivos desnecessários.

As operações de armazenamento utilizam políticas de segurança para restringir as alterações aos arquivos pertencentes ao usuário autenticado.

## ❤️ Favoritos

O NutriGo possui um sistema de favoritos com **persistência no Supabase**, permitindo que cada usuário mantenha suas receitas favoritas mesmo após fechar e abrir novamente o aplicativo.

Funcionalidades implementadas:

- Adicionar receitas aos favoritos;
- Remover receitas dos favoritos;
- Salvar favoritos na tabela `favorites`;
- Associar favoritos ao usuário autenticado;
- Recuperar automaticamente os favoritos ao carregar o aplicativo;
- Favoritar receitas demonstrativas e receitas cadastradas no Supabase;
- Sincronizar a exibição dos favoritos entre Home, Explorar, Favoritos e Perfil;
- Atualizar imediatamente o estado visual do favorito enquanto a sincronização com o Supabase ocorre em segundo plano;
- Exibir receitas favoritas em uma tela dedicada.

A tabela `favorites` utiliza `recipe_id` para receitas persistidas no banco e `demo_recipe_key` para identificar receitas demonstrativas.

As políticas RLS restringem a consulta, a inclusão e a remoção dos registros de favoritos ao usuário correspondente.

## 📁 Coleções

O NutriGo permite organizar receitas em **coleções personalizadas**, com persistência no Supabase para cada usuário autenticado.

Funcionalidades implementadas:

- Criar novas coleções;
- Definir um nome para cada coleção;
- Adicionar receitas às coleções;
- Visualizar as receitas pertencentes a uma coleção;
- Editar o nome e as receitas de uma coleção;
- Excluir coleções;
- Recuperar automaticamente as coleções salvas;
- Manter as coleções persistentes entre sessões;
- Armazenar receitas demonstrativas e receitas cadastradas no Supabase em coleções;
- Manter uma receita na coleção mesmo após ela ser removida dos favoritos;
- Excluir automaticamente os vínculos das receitas quando uma coleção é removida.

As coleções são armazenadas na tabela `collections`, enquanto a relação entre coleções e receitas é armazenada na tabela `collection_recipes`.

Para receitas cadastradas no Supabase, a relação utiliza `recipe_id`. Para receitas demonstrativas, é utilizado `demo_recipe_key`.

As tabelas utilizam políticas de **Row Level Security (RLS)** para restringir o acesso às coleções pertencentes ao usuário autenticado.

## 👥 Relacionamentos entre usuários

O NutriGo possui uma estrutura de relacionamentos entre usuários utilizando a tabela `follows` no Supabase PostgreSQL.

A relação utiliza:

- `follower_id`: identifica o usuário que segue;
- `following_id`: identifica o usuário seguido;
- `created_at`: registra a criação do relacionamento.

As regras de integridade impedem que um usuário siga a si mesmo e evitam que o mesmo relacionamento seja cadastrado mais de uma vez.

As políticas de Row Level Security (RLS) controlam a criação, consulta e remoção desses relacionamentos.

A quantidade de usuários seguidos é utilizada dinamicamente nas estatísticas exibidas no Perfil.

## 🧭 Navegação

O aplicativo possui navegação entre as principais áreas:

- Home;
- Receitas;
- Favoritos;
- Perfil;
- Detalhes da receita;
- Publicação de receita;
- Configurações.

---

# 🛠️ Tecnologias utilizadas

O projeto utiliza as seguintes tecnologias:

- **Flutter**
- **Dart**
- **Supabase**
- **PostgreSQL**
- **Supabase Auth**
- **Row Level Security (RLS)**
- **flutter_dotenv**
- **supabase_flutter**
- **image_picker**

O desenvolvimento é realizado utilizando o **Visual Studio Code**.

---

# 🗄️ Banco de dados e autenticação

O projeto utiliza o **Supabase** como solução de backend em nuvem.

Atualmente, a integração contempla autenticação, gerenciamento de perfis, persistência de receitas, favoritos e coleções no PostgreSQL, além do armazenamento de imagens no Supabase Storage.

## Autenticação

O cadastro é realizado utilizando o **Supabase Auth**.

Cada usuário possui um identificador único (`UUID`) gerado pelo sistema de autenticação.

### Recuperação de senha

O aplicativo também possui fluxo de recuperação de senha integrado ao **Supabase Auth**.

A partir da tela de login, o usuário pode solicitar a recuperação informando o e-mail cadastrado. O Supabase envia um e-mail contendo um link de recuperação.

No Android, após a validação do link, o usuário é redirecionado para o NutriGo por meio do deep link:

```text
io.supabase.nutrigo://reset-password
```

O aplicativo identifica o evento de recuperação do Supabase e direciona o usuário para a tela de redefinição de senha.

Fluxo de recuperação implementado:

```text
Esqueci minha senha
        ↓
Supabase Auth
        ↓
E-mail de recuperação
        ↓
Link de recuperação
        ↓
Deep link Android
        ↓
NutriGo
        ↓
Redefinição da senha
        ↓
Logout da sessão de recuperação
        ↓
Login com a nova senha
```

Após a alteração, a sessão utilizada durante a recuperação é encerrada e o usuário retorna à tela de login para acessar o aplicativo utilizando a nova senha.

### Fluxo de cadastro

Fluxo atual:

```text
Cadastro
   ↓
Supabase Auth
   ↓
auth.users
   ↓
Trigger do banco
   ↓
profiles
```

Após a criação do usuário, um trigger do PostgreSQL cria automaticamente o perfil correspondente na tabela `profiles`.

---

## Tabela `profiles`

A tabela `profiles` armazena informações complementares e configurações do usuário.

Estrutura utilizada:

```text
profiles
├── id
├── nome
├── preferencias_alimentares
├── notificacoes_ativadas
└── created_at
```

O campo `id` possui relação com o usuário criado pelo Supabase Auth.

---

## 🔐 Row Level Security

A tabela `profiles` utiliza **Row Level Security (RLS)**.

As políticas implementadas garantem que um usuário autenticado possa:

- visualizar seu próprio perfil;
- criar seu próprio perfil;
- atualizar seu próprio perfil.

Dessa forma, os dados de cada perfil são associados ao usuário autenticado.

Além da tabela `profiles`, o projeto utiliza Row Level Security nas tabelas `recipes`, `favorites`, `collections`, `collection_recipes` e `follows`.

As políticas foram configuradas de acordo com a responsabilidade de cada recurso. Receitas podem ser visualizadas pelos usuários autenticados, enquanto operações de criação, edição e exclusão são restritas ao proprietário. Favoritos, coleções e seus vínculos são protegidos de acordo com o usuário autenticado.

Também são utilizadas restrições de unicidade para evitar favoritos duplicados, relacionamentos duplicados entre usuários e a inclusão repetida da mesma receita em uma mesma coleção.

---

## 🍳 Tabela `recipes`

A tabela `recipes` armazena as receitas publicadas pelos usuários do NutriGo.

Cada receita possui um identificador único (`UUID`) e está associada ao usuário responsável pela publicação.

Entre os dados armazenados estão:

- Identificador da receita (`id`);
- Identificador do usuário (`user_id`);
- Nome da receita;
- Categoria;
- Tempo de preparo;
- Dificuldade;
- Calorias;
- Ingredientes;
- Modo de preparo;
- Categorias alimentares;
- Caminho da imagem armazenada no Supabase Storage.

### Operações implementadas

O aplicativo realiza as operações CRUD:

- **CREATE:** publicação de novas receitas;
- **READ:** consulta das receitas cadastradas;
- **UPDATE:** edição das receitas pertencentes ao usuário;
- **DELETE:** exclusão das receitas pertencentes ao usuário.

A aplicação utiliza o serviço `SupabaseRecipeService` para realizar essas operações.

### Segurança das receitas

As políticas de Row Level Security (RLS) permitem a consulta de receitas conforme as regras configuradas e restringem as operações de criação, edição e exclusão aos usuários autorizados.

---

## ❤️ Tabela `favorites`

A tabela `favorites` armazena os favoritos de cada usuário autenticado.

Estrutura principal:

```text
favorites
├── id
├── user_id
├── recipe_id
├── demo_recipe_key
└── created_at
```

Os campos possuem as seguintes responsabilidades:

- `id`: identificador único do favorito;
- `user_id`: identifica o usuário responsável;
- `recipe_id`: identifica uma receita cadastrada no Supabase;
- `demo_recipe_key`: identifica uma receita demonstrativa;
- `created_at`: registra a data de criação do favorito.

Uma restrição garante que cada registro utilize `recipe_id` ou `demo_recipe_key`, mas não ambos.

Também existem restrições para evitar que o mesmo usuário cadastre o mesmo favorito mais de uma vez.

### Segurança dos favoritos

A tabela utiliza políticas RLS para permitir que usuários autenticados:

- Consultem seus próprios favoritos;
- Adicionem favoritos associados à própria conta;
- Removam seus próprios favoritos.

O gerenciamento é realizado pelo serviço `SupabaseFavoriteService`.

Os favoritos são recuperados quando o aplicativo carrega as receitas, permitindo sua persistência entre sessões.

---

## 📁 Tabelas de coleções

O sistema de coleções utiliza duas tabelas no Supabase PostgreSQL: `collections` e `collection_recipes`.

### Tabela `collections`

A tabela `collections` armazena as coleções criadas por cada usuário autenticado.

Estrutura principal:

```text
collections
├── id
├── user_id
├── name
└── created_at
```

Os campos possuem as seguintes responsabilidades:

- `id`: identificador único da coleção;
- `user_id`: identifica o usuário proprietário da coleção;
- `name`: armazena o nome definido pelo usuário;
- `created_at`: registra a data de criação da coleção.

Cada coleção está associada ao usuário autenticado por meio de `user_id`.

### Tabela `collection_recipes`

A tabela `collection_recipes` armazena as receitas pertencentes a cada coleção.

Estrutura principal:

```text
collection_recipes
├── id
├── collection_id
├── recipe_id
├── demo_recipe_key
└── created_at
```

Os campos possuem as seguintes responsabilidades:

- `id`: identificador único do vínculo;
- `collection_id`: identifica a coleção;
- `recipe_id`: identifica uma receita cadastrada no Supabase;
- `demo_recipe_key`: identifica uma receita demonstrativa;
- `created_at`: registra a criação do vínculo.

Uma restrição garante que cada vínculo utilize `recipe_id` ou `demo_recipe_key`, mas não ambos.

Para receitas persistidas no Supabase, uma restrição de unicidade em `collection_id` e `recipe_id` impede que a mesma receita seja adicionada mais de uma vez à mesma coleção.

O campo `collection_id` possui relação com a tabela `collections` utilizando `ON DELETE CASCADE`. Dessa forma, ao excluir uma coleção, seus vínculos em `collection_recipes` são removidos automaticamente sem excluir as receitas originais.

### Operações implementadas

O gerenciamento das coleções possui operações CRUD:

- **CREATE:** criação de coleções e associação das receitas selecionadas;
- **READ:** recuperação das coleções e de suas receitas;
- **UPDATE:** alteração do nome e das receitas pertencentes à coleção;
- **DELETE:** exclusão da coleção e remoção automática de seus vínculos.

O gerenciamento é realizado pelo serviço `SupabaseCollectionService`.

### Segurança das coleções

As tabelas `collections` e `collection_recipes` utilizam políticas de **Row Level Security (RLS)**.

As políticas permitem que o usuário autenticado:

- Visualize suas próprias coleções;
- Crie coleções associadas à própria conta;
- Atualize suas próprias coleções;
- Exclua suas próprias coleções;
- Consulte as receitas vinculadas às próprias coleções;
- Adicione, atualize e remova vínculos de receitas somente em suas próprias coleções.

Dessa forma, cada usuário possui acesso apenas às suas próprias coleções e aos respectivos vínculos de receitas.

---

## 📷 Supabase Storage

O NutriGo utiliza o **Supabase Storage** para armazenar as imagens das receitas.

O bucket utilizado é:

```text
receitas
```

Os arquivos são organizados em pastas identificadas pelo UUID do usuário autenticado.

Exemplo ilustrativo:

```text
receitas/
└── UUID_DO_USUARIO/
    ├── imagem_1.jpg
    └── imagem_2.png
```

O aplicativo permite:

- Upload de imagens JPG, PNG e WebP;
- Limite de 5 MB por imagem;
- Exibição das imagens armazenadas;
- Substituição de imagens durante a edição;
- Exclusão das imagens associadas às receitas removidas;
- Limpeza da imagem anterior após uma substituição bem-sucedida.

### Segurança do armazenamento

O bucket utiliza políticas de acesso para operações de:

- `SELECT`;
- `INSERT`;
- `UPDATE`;
- `DELETE`.

As operações de alteração são restringidas aos arquivos localizados nas pastas pertencentes ao usuário autenticado.

O serviço `SupabaseStorageService` centraliza as operações de armazenamento e exclusão de imagens.

---

# 🧱 Arquitetura

O projeto utiliza uma separação entre **interface**, **regras de acesso aos dados** e **implementações dos serviços**.

As telas não precisam conhecer diretamente os detalhes de comunicação com o banco.

Exemplo:

```text
HomePage
   ↓
ProfileService
   ↓
SupabaseProfileService
   ↓
Supabase
   ↓
profiles
```

Para autenticação:

```text
LoginPage / CadastroPage
          ↓
      AuthService
          ↓
SupabaseAuthService
          ↓
    Supabase Auth
```

Essa estrutura facilita a manutenção e permite substituir ou evoluir a camada de persistência sem concentrar a lógica de banco de dados nas telas.

---

# 📁 Estrutura do projeto

A aplicação Flutter está organizada principalmente da seguinte forma:

```text
lib/
├── core/
│   ├── theme/
│   └── widgets/
│
├── models/
│   ├── recipe.dart
│   ├── recipe_collection.dart
│   └── recipe_data.dart
│
├── screens/
│   ├── cadastro/
│   ├── configuracoes/
│   ├── detalhes_receita/
│   ├── favoritos/
│   ├── home/
│   ├── login/
│   ├── main/
│   ├── perfil/
│   ├── receitas/
│   ├── redefinir_senha/
│   └── ...
│
├── services/
│   ├── auth_service.dart
│   ├── collection_service.dart
│   ├── favorite_service.dart
│   ├── profile_service.dart
│   ├── recipe_service.dart
│   ├── storage_service.dart
│   │
│   └── supabase/
│       ├── supabase_auth_service.dart
│       ├── supabase_collection_service.dart
│       ├── supabase_favorite_service.dart
│       ├── supabase_follow_service.dart
│       ├── supabase_profile_service.dart
│       ├── supabase_recipe_service.dart
│       └── supabase_storage_service.dart
│
├── env.dart
└── main.dart
```

A estrutura continuará sendo expandida conforme novas funcionalidades e integrações forem adicionadas.

---

# 🔑 Variáveis de ambiente

As credenciais públicas necessárias para conexão com o Supabase são carregadas por meio de variáveis de ambiente.

O projeto contém o arquivo:

```text
.env.example
```

Exemplo:

```env
SUPABASE_URL=
SUPABASE_ANON_KEY=
```

Por segurança, o arquivo `.env` real **não é versionado no GitHub** e está incluído no `.gitignore`.

> Nunca devem ser adicionadas ao aplicativo chaves administrativas, `service_role` ou outras credenciais secretas do Supabase.

---

# ▶️ Como executar o projeto

## Pré-requisitos

É necessário possuir:

- Flutter SDK instalado;
- Dart;
- Visual Studio Code ou outra IDE compatível;
- Git.

Verifique a instalação do Flutter:

```bash
flutter doctor
```

---

## 1. Clone o repositório

```bash
git clone https://github.com/GabrielTarone/app-dieta.git
```

Entre na pasta do projeto Flutter:

```bash
cd app-dieta
```

---

## 2. Instale as dependências

Execute:

```bash
flutter pub get
```

---

## 3. Configure o Supabase

Crie um arquivo chamado:

```text
.env
```

na raiz do projeto Flutter.

Utilize `.env.example` como referência:

```env
SUPABASE_URL=SUA_URL_DO_SUPABASE
SUPABASE_ANON_KEY=SUA_CHAVE_PUBLICAVEL
```

O arquivo `.env` não deve ser enviado ao GitHub.

---

## 4. Execute o projeto

Para verificar os dispositivos disponíveis:

```bash
flutter devices
```

Para executar no Chrome:

```bash
flutter run -d chrome
```

Também é possível executar em outros dispositivos compatíveis configurados no ambiente Flutter.

---

## 5. Verifique o código

Antes de executar ou enviar alterações ao repositório, recomenda-se utilizar:

```bash
flutter analyze
```

O comando verifica problemas e avisos no código Dart/Flutter.

---

# 🖼️ Identidade visual

A identidade visual do NutriGo busca transmitir:

- Saúde;
- Naturalidade;
- Leveza;
- Simplicidade;
- Comunidade.

## Logo

<p align="center">
  <img src="./docs/imagens/logo.png" width="150">
</p>

---

## 🎨 Paleta de cores

| Cor | Hexadecimal | Aplicação |
| --- | --- | --- |
| Verde principal | `#4CAF6A` | Ações principais e identidade |
| Verde claro | `#A8D5B2` | Elementos secundários |
| Creme | `#F5EFE4` | Fundos |
| Bege | `#E8DCC2` | Fundos secundários e detalhes visuais |
| Cinza escuro | `#333333` | Textos |
| Cinza grafite | `#4E4747` | Ícones e texto de ícones |
| Branco | `#FFFFFF` | Fundos e contraste |

A combinação busca transmitir **saúde e naturalidade** por meio dos tons verdes, enquanto os tons neutros ajudam a manter uma interface leve e organizada.

---

# 🔤 Tipografia

A identidade tipográfica do NutriGo utiliza a fonte **Inter** como fonte principal da interface.

A escolha busca garantir boa legibilidade em dispositivos móveis e proporcionar uma aparência moderna, limpa e consistente.

<p align="center">
  <img src="./docs/imagens/tipografia.png" width="700">
</p>

| Estilo | Fonte | Peso | Tamanho |
| ------ | ----- | ---- | ------- |
| Título Logo | Inter | Bold | 40px |
| Subtítulo | Inter | Semi Bold | 16px |
| Texto Normal | Inter | Regular | 12px |
| Texto Normal Chamativo | Inter | Bold | 12px |
| Texto Botão | Inter | Bold | 12px |
| Título Chamativo | Inter | Semi Bold | 24px |
| Subtítulo Chamativo | Inter | Bold | 16px |

---

# 📱 Interface

As telas do NutriGo seguem a identidade visual definida para o projeto, utilizando a paleta de cores, tipografia e componentes de forma consistente.

<table>
  <tr>
    <td align="center">
      <strong>Login</strong><br><br>
      <img src="./docs/imagens/login.jpeg" width="220">
    </td>
    <td align="center">
      <strong>Home</strong><br><br>
      <img src="./docs/imagens/home.jpeg" width="220">
    </td>
    <td align="center">
      <strong>Explorar Receitas</strong><br><br>
      <img src="./docs/imagens/explorar.jpeg" width="220">
    </td>
  </tr>
  <tr>
    <td align="center">
      <strong>Detalhes da Receita</strong><br><br>
      <img src="./docs/imagens/receita.jpeg" width="220">
    </td>
    <td align="center">
      <strong>Favoritos</strong><br><br>
      <img src="./docs/imagens/favoritos.jpeg" width="220">
    </td>
    <td align="center">
      <strong>Perfil</strong><br><br>
      <img src="./docs/imagens/perfil.jpeg" width="220">
    </td>
  </tr>
</table>

---

# 💡 Desenvolvimento de marca

## Nome: NutriGo

O nome **NutriGo** combina duas ideias centrais do aplicativo:

**Nutri** → representa nutrição, alimentação e hábitos alimentares.

**Go** → representa determinação, iniciativa e a vontade de começar.

A combinação reforça a proposta de que melhorar a alimentação pode ser uma experiência coletiva, na qual as pessoas compartilham receitas, conhecimentos e descobertas.

### Naming rationale

O nome foi escolhido por ser:

- Fácil de lembrar;
- Relacionado diretamente ao propósito do aplicativo;
- Associado aos conceitos de alimentação e iniciativa.

---

# 🗣️ Tom de voz

A comunicação da marca busca ser:

**Amigável**  
O aplicativo conversa com o usuário de forma próxima e acessível.

**Positiva**  
O foco está em incentivar melhorias e conquistas, evitando uma comunicação baseada em culpa.

**Motivadora**  
A linguagem busca estimular pequenas mudanças consistentes.

**Inclusiva**  
O produto busca respeitar diferentes estilos de alimentação, objetivos e realidades.

**Simples**  
As informações e funcionalidades são apresentadas de maneira clara, evitando excesso de termos técnicos.

---

# 💡 Ideia de venda — Pitch

## O problema

Milhões de pessoas desejam se alimentar melhor, mas encontram dificuldades para transformar esse objetivo em uma rotina sustentável.

Aplicativos tradicionais frequentemente focam apenas em **calorias, dietas ou acompanhamento individual**, deixando de lado um fator importante: **motivação e troca de experiências**.

## A solução

O **NutriGo** transforma a alimentação em uma experiência social e participativa.

O usuário pode descobrir receitas, compartilhar suas próprias criações e encontrar inspiração em uma comunidade com objetivos semelhantes.

## Diferencial competitivo

O principal diferencial proposto pelo NutriGo é combinar:

**Receitas + comunidade + hábitos alimentares**

Em vez de tratar alimentação apenas como um conjunto de números ou restrições, o aplicativo busca criar uma experiência mais positiva e sustentável.

---

# 💰 Modelo de negócio

O modelo de negócio poderá combinar diferentes fontes de receita.

### Freemium

A maioria das funcionalidades poderá ser disponibilizada gratuitamente, enquanto recursos avançados poderão fazer parte de um plano premium.

### Plano Premium

Possíveis funcionalidades futuras:

- Recomendações personalizadas;
- Análises avançadas de hábitos;
- Cardápios;
- Planejamento de refeições;
- Recursos adicionais para organização alimentar.

### Parcerias

O aplicativo também poderá estabelecer parcerias com:

- Marcas de alimentos;
- Mercados;
- Empresas de produtos naturais;
- Profissionais e serviços relacionados à alimentação;
- Plataformas de entrega.

---

# 🎤 Pitch

> “O NutriGo é uma plataforma social para pessoas que querem melhorar sua alimentação sem transformar esse processo em uma obrigação. Combinamos compartilhamento de receitas, descoberta de novos pratos e acompanhamento de hábitos em uma única experiência, permitindo que os usuários aprendam, compartilhem e evoluam juntos.”

---

# 🔄 Próximas etapas

O NutriGo já possui sua estrutura principal integrada ao Supabase, incluindo autenticação, gerenciamento de sessão, recuperação e alteração de senha, perfis, receitas, imagens, favoritos, coleções, preferências do usuário e políticas de segurança.

Nesta etapa, o desenvolvimento encontra-se em fase de revisão, validação e preparação da entrega.

As próximas atividades incluem:

### 👥 Recursos sociais

- Finalizar e validar o fluxo de seguir e deixar de seguir outros usuários;
- Validar o comportamento dos relacionamentos utilizando diferentes contas.

### 🎨 Interface e experiência

- Realizar a revisão visual das telas em relação ao protótipo;
- Refinar eventuais diferenças de espaçamento, tipografia e componentes;
- Revisar a responsividade das principais interfaces.

### 🧪 Testes e validação

- Realizar testes finais dos principais fluxos da aplicação;
- Validar o comportamento com diferentes usuários;
- Realizar testes de regressão das funcionalidades já implementadas;
- Revisar possíveis erros e inconsistências.

### 📱 Preparação da entrega

- Atualizar as imagens das interfaces utilizadas na documentação;
- Revisar a documentação final do projeto;
- Gerar e validar o APK Android;
- Confirmar a execução do projeto sem problemas utilizando `flutter analyze`;
- Preparar a versão final para apresentação acadêmica.

---

# 📚 Projeto acadêmico

Projeto desenvolvido para a disciplina de **CPAD**, utilizando Flutter e Dart como tecnologias principais para o desenvolvimento da aplicação.

O projeto evolui de forma incremental, mantendo o repositório atualizado conforme novas funcionalidades são implementadas e testadas.