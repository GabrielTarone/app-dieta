# 👥 Integrantes e responsabilidades

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

A plataforma combina **descoberta e compartilhamento de receitas, organização de favoritos, coleções e interação entre usuários**, criando uma experiência em que as pessoas podem encontrar inspiração para suas refeições, compartilhar suas próprias receitas e interagir com outros usuários.

---

# 📌 Sobre o projeto

## Problema

Manter uma alimentação equilibrada pode ser difícil. Muitas pessoas têm vontade de melhorar seus hábitos alimentares, mas encontram obstáculos como falta de ideias para refeições, dificuldade em manter uma rotina, excesso de informações conflitantes e pouca motivação para continuar.

O **NutriGo** busca tornar esse processo mais acessível ao reunir receitas, organização e interação em uma única aplicação.

Em vez de apenas oferecer informações sobre dieta, o aplicativo busca criar uma experiência na qual os usuários possam descobrir receitas, publicar suas próprias opções, organizar seus favoritos e coleções e encontrar inspiração para suas refeições.

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

O NutriGo encontra-se em sua etapa final de desenvolvimento como aplicativo **Flutter/Dart**, com integração ao **Supabase** para autenticação, gerenciamento de usuários, persistência de receitas, armazenamento de imagens, favoritos, coleções, relacionamentos sociais e notificações.

O projeto possui as seguintes funcionalidades implementadas:

- **Autenticação:** cadastro, login com e-mail e senha, login com Google, recuperação e alteração de senha, além do gerenciamento de sessão por meio do Supabase Auth.
- **Perfis e configurações:** carregamento e edição das informações do usuário, foto de perfil, preferências alimentares e configuração de notificações, com persistência dos dados no Supabase.
- **Receitas:** cadastro, consulta, edição e exclusão de receitas, incluindo informações como categoria, tempo, dificuldade, calorias e quantidade de porções.
- **Imagens:** envio, substituição e exclusão de fotografias de receitas e avatares utilizando Supabase Storage.
- **Favoritos e curtidas:** adição e remoção de receitas favoritas, contabilização das curtidas recebidas nas próprias receitas e identificação dos usuários que curtiram.
- **Coleções:** criação, consulta, edição e exclusão de coleções personalizadas de receitas, com persistência por usuário no Supabase.
- **Sessão do usuário:** restauração automática da sessão autenticada, permitindo que o usuário retorne ao aplicativo sem realizar um novo login enquanto a sessão permanecer válida.
- **Perfil e progresso:** exibição dinâmica de receitas publicadas, curtidas recebidas, usuários seguidos, nível e pontuação, com acesso às informações pelas estatísticas do perfil.
- **Relacionamentos entre usuários:** seguir e deixar de seguir usuários, consulta de seguidores e de usuários seguidos e tela de Conexões, com controle de segurança por RLS.
- **Notificações:** notificações de novos seguidores e curtidas recebidas em receitas, com controle de leitura e preferência de ativação ou desativação.
- **Tratamento de carregamento:** exibição de indicador durante o carregamento dos dados e tratamento de falhas com opção de nova tentativa.
- **Segurança:** utilização de políticas Row Level Security (RLS) para controlar o acesso aos dados e arquivos.
- **Integridade dos dados:** utilização de chaves estrangeiras e restrições de unicidade para evitar registros duplicados em favoritos, relacionamentos entre usuários e vínculos entre receitas e coleções.
- **Navegação:** integração entre Home, Explorar Receitas, Favoritos, Perfil e telas de gerenciamento de receitas.

O aplicativo combina receitas demonstrativas com receitas cadastradas no banco de dados.

As funcionalidades principais do MVP encontram-se implementadas e integradas ao backend Supabase.

A validação estática do projeto foi realizada com `flutter analyze`, sem problemas identificados. O projeto encontra-se na etapa final de preparação para o **Checkpoint 6**, restando a geração e a validação do APK Android em modo release.

---

# ✨ Funcionalidades implementadas

## 👤 Autenticação e usuários

- Cadastro de novos usuários;
- Login com e-mail e senha;
- Login com Google utilizando OAuth e Supabase Auth;
- Retorno automático ao NutriGo após a autenticação com Google por deep link;
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
- Seleção, alteração e remoção da foto de perfil;
- Armazenamento do avatar no Supabase Storage, associado ao usuário autenticado;
- Edição do nome do usuário pela tela de Configurações;
- Persistência das alterações do perfil no Supabase PostgreSQL;
- Atualização automática dos dados exibidos no Perfil após a edição;
- Alteração de senha pelo usuário autenticado na tela de Configurações;
- Validação da nova senha e confirmação antes da atualização;
- Configuração das preferências alimentares do usuário;
- Seleção de múltiplas preferências, como vegetariana, vegana, sem glúten e sem lactose;
- Persistência das preferências alimentares no perfil do usuário no Supabase PostgreSQL;
- Recuperação automática das preferências alimentares salvas;
- Ativação e desativação das notificações pela tela de Configurações;
- Persistência da configuração de notificações no Supabase PostgreSQL;
- Recuperação automática da configuração de notificações entre sessões;
- Exibição da quantidade de receitas publicadas pelo usuário;
- Acesso às próprias receitas por meio da estatística `Receitas` no Perfil;
- Contabilização de curtidas recebidas nas receitas publicadas;
- Visualização das próprias receitas que receberam curtidas e dos usuários que curtiram;
- Acesso à tela de curtidas recebidas por meio da estatística `Curtidas` no Perfil;
- Contabilização de usuários seguidos;
- Acesso à tela de Conexões por meio da estatística `Seguindo` no Perfil;
- Sistema de pontuação baseado na atividade do usuário;
- Exibição dinâmica do nível do usuário de acordo com sua pontuação.

---

## 🍳 Receitas

O NutriGo permite consultar e gerenciar receitas, utilizando o **Supabase PostgreSQL** para armazenar as receitas publicadas.

Funcionalidades implementadas:

- Visualização de receitas demonstrativas e receitas cadastradas no Supabase;
- Tela de detalhes das receitas;
- Busca por nome e categoria;
- Filtros por categorias;
- Publicação de novas receitas;
- Cadastro de ingredientes e modo de preparo;
- Informações de tempo, dificuldade, calorias, quantidade de porções e categorias alimentares;
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

---

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

---

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

---

## 👥 Relacionamentos entre usuários

O NutriGo possui recursos sociais persistidos por meio da tabela `follows` no Supabase PostgreSQL.

A relação utiliza:

- `follower_id`: identifica o usuário que segue;
- `following_id`: identifica o usuário seguido;
- `created_at`: registra a criação do relacionamento.

Funcionalidades implementadas:

- Seguir outros usuários;
- Deixar de seguir usuários;
- Consultar os seguidores do usuário autenticado;
- Consultar os usuários que o usuário autenticado segue;
- Tela **Conexões** com abas **Seguidores** e **Seguindo**;
- Atualização dinâmica das relações sociais;
- Exibição da quantidade de usuários seguidos nas estatísticas do Perfil.

As regras de integridade impedem que um usuário siga a si mesmo e evitam que o mesmo relacionamento seja cadastrado mais de uma vez.

As políticas de Row Level Security (RLS) controlam a criação, consulta e remoção dos relacionamentos. Os perfis necessários à experiência social podem ser consultados por usuários autenticados, enquanto a criação e a alteração dos dados de perfil permanecem protegidas de acordo com o usuário correspondente.

---

## 🔔 Notificações

O NutriGo possui um sistema de notificações integrado ao Supabase para informar o usuário sobre interações sociais realizadas na plataforma.

Funcionalidades implementadas:

- Notificação quando um novo usuário começa a seguir o perfil;
- Notificação quando uma receita publicada recebe uma curtida;
- Identificação do usuário responsável pela interação;
- Identificação da receita relacionada à curtida;
- Diferenciação entre notificações lidas e não lidas;
- Marcação de notificações como lidas;
- Opção para marcar todas as notificações como lidas;
- Exibição do tempo relativo da interação;
- Ativação e desativação das notificações pela tela de Configurações;
- Persistência da preferência do usuário no Supabase.

A criação das notificações ocorre no banco de dados a partir das interações realizadas no aplicativo. A preferência `notificacoes_ativadas` do perfil é verificada antes da criação de uma nova notificação.

As políticas de Row Level Security (RLS) restringem o acesso às notificações pertencentes ao usuário autenticado.

---

## 🧭 Navegação

O aplicativo possui navegação entre as principais áreas:

- Home;
- Explorar Receitas;
- Favoritos;
- Perfil;
- Detalhes da receita;
- Publicação de receita;
- Edição de receita;
- Minhas receitas;
- Coleções;
- Configurações;
- Notificações;
- Conexões, com Seguidores e Seguindo;
- Curtidas recebidas.

---

# 🛠️ Tecnologias utilizadas

O projeto utiliza as seguintes tecnologias:

- **Flutter**
- **Dart**
- **Supabase**
- **PostgreSQL**
- **Supabase Auth**
- **Supabase Storage**
- **Google OAuth**
- **Row Level Security (RLS)**
- **flutter_dotenv**
- **supabase_flutter**
- **image_picker**

O desenvolvimento é realizado utilizando o **Visual Studio Code**.

---

# 🗄️ Banco de dados e autenticação

O projeto utiliza o **Supabase** como solução de backend em nuvem.

A integração contempla autenticação, gerenciamento de perfis, persistência de receitas, favoritos, coleções, relacionamentos sociais e notificações no PostgreSQL, além do armazenamento de imagens no Supabase Storage.

## Autenticação

O cadastro e o login com e-mail e senha são realizados utilizando o **Supabase Auth**.

O aplicativo também possui **login com Google via OAuth**, integrado ao Supabase Auth. Após a escolha e autenticação da conta Google, o usuário retorna ao NutriGo por meio do deep link configurado para o aplicativo.

Cada usuário possui um identificador único (`UUID`) gerado pelo sistema de autenticação.

### Recuperação de senha

O aplicativo possui fluxo de recuperação de senha integrado ao **Supabase Auth**.

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
├── avatar_url
├── preferencias_alimentares
├── notificacoes_ativadas
└── created_at
```

O campo `id` possui relação com o usuário criado pelo Supabase Auth.

---

## 🔐 Row Level Security

A tabela `profiles` utiliza **Row Level Security (RLS)**.

As políticas implementadas permitem que usuários autenticados consultem os perfis necessários às funcionalidades sociais do aplicativo.

A criação e a atualização dos dados de perfil permanecem restritas ao usuário proprietário do respectivo perfil.

Dessa forma, informações necessárias para recursos como Seguidores, Seguindo e Curtidas podem ser exibidas sem permitir que outro usuário altere os dados de um perfil que não lhe pertence.

Além da tabela `profiles`, o projeto utiliza Row Level Security nas tabelas `recipes`, `favorites`, `collections`, `collection_recipes`, `follows` e `notifications`.

As políticas foram configuradas de acordo com a responsabilidade de cada recurso. Receitas podem ser visualizadas pelos usuários autenticados, enquanto operações de criação, edição e exclusão são restritas ao proprietário. Favoritos, coleções, notificações e seus respectivos vínculos são protegidos de acordo com o usuário autenticado.

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
- Quantidade de porções;
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

## 👥 Tabela `follows`

A tabela `follows` armazena os relacionamentos entre usuários.

Estrutura principal:

```text
follows
├── id
├── follower_id
├── following_id
└── created_at
```

- `follower_id`: identifica o usuário que iniciou o relacionamento;
- `following_id`: identifica o usuário seguido;
- `created_at`: registra quando o relacionamento foi criado.

As regras de integridade impedem que um usuário siga a si mesmo e evitam relacionamentos duplicados.

As políticas RLS controlam a consulta, criação e remoção dos relacionamentos de acordo com o usuário autenticado.

---

## 🔔 Tabela `notifications`

A tabela `notifications` armazena notificações relacionadas às interações sociais do aplicativo.

Entre as informações armazenadas estão:

```text
notifications
├── id
├── user_id
├── actor_id
├── type
├── recipe_id
├── is_read
└── created_at
```

Os registros podem representar eventos como:

- Novo seguidor;
- Curtida recebida em uma receita.

O campo `is_read` permite controlar o estado de leitura da notificação.

A criação das notificações ocorre a partir das interações realizadas no aplicativo e considera a configuração `notificacoes_ativadas` definida pelo usuário.

As políticas RLS restringem o acesso às notificações do próprio usuário.

---

## 📷 Supabase Storage

O NutriGo utiliza o **Supabase Storage** para armazenar imagens de receitas e fotos de perfil.

Os buckets utilizados incluem:

```text
receitas
avatars
```

Os arquivos são organizados em pastas identificadas pelo UUID do usuário autenticado.

O aplicativo permite upload e exibição de imagens JPG, PNG e WebP, substituição e exclusão de imagens de receitas e seleção, alteração e remoção da foto de perfil.

As operações de alteração são protegidas por políticas de acesso e organizadas em pastas associadas ao usuário autenticado.

O serviço `SupabaseStorageService` centraliza as operações relacionadas às imagens de receitas, enquanto o serviço de perfil realiza as operações relacionadas ao avatar.

---

# 🧱 Arquitetura

O projeto utiliza uma separação entre **interface**, **modelos**, **contratos de serviços** e **implementações responsáveis pela comunicação com o Supabase**.

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

Para receitas:

```text
Telas de receitas
       ↓
 RecipeService
       ↓
SupabaseRecipeService
       ↓
Supabase PostgreSQL
       ↓
     recipes
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
│   ├── curtidas/
│   ├── detalhes_receita/
│   ├── favoritos/
│   ├── home/
│   ├── login/
│   ├── main/
│   ├── minhas_receitas/
│   ├── notificacoes/
│   ├── perfil/
│   ├── publicar_receita/
│   ├── receitas/
│   ├── redefinir_senha/
│   ├── seguindo/
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
│       ├── supabase_notification_service.dart
│       ├── supabase_profile_service.dart
│       ├── supabase_recipe_service.dart
│       └── supabase_storage_service.dart
│
├── env.dart
└── main.dart
```

A organização separa as responsabilidades da aplicação, facilitando a manutenção, leitura e evolução do projeto.

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
- Git;
- Dispositivo, emulador ou navegador compatível com Flutter.

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

Para executar em um dispositivo Android conectado ou emulador disponível:

```bash
flutter run
```

---

## 5. Verifique o código

Antes de executar ou enviar alterações ao repositório, utilize:

```bash
flutter analyze
```

Na validação final realizada para o Checkpoint 6, o projeto foi analisado sem problemas identificados.

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
| Bege | `#E8DCC2` | Fundos secundários e detalhes visuais |
| Creme | `#F5F0E7` | Fundos |
| Branco | `#FFFFFF` | Fundos e contraste |
| Cinza escuro | `#333333` | Textos |
| Cinza claro | `#8E8E8E` | Elementos secundários |
| Texto secundário | `#70766F` | Textos de apoio |
| Botão secundário | `#86B88E` | Ações secundárias |

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

Abaixo estão as principais telas e funcionalidades implementadas na versão final do NutriGo.

## 🔐 Autenticação

<table>
  <tr>
    <th>Login</th>
    <th>Criar conta</th>
    <th>Redefinir senha</th>
  </tr>
  <tr>
    <td><img src="assets/images/login.jpeg" width="250"></td>
    <td><img src="assets/images/criarConta.jpeg" width="250"></td>
    <td><img src="assets/images/redefinirSenha.jpeg" width="250"></td>
  </tr>
  <tr>
    <th>Validação de e-mail</th>
    <th>Validação de e-mail</th>
    <th>Validação de senha</th>
  </tr>
  <tr>
    <td><img src="assets/images/login-validacao-email.jpeg" width="250"></td>
    <td><img src="assets/images/login-validacao-email1.jpeg" width="250"></td>
    <td><img src="assets/images/login-validacao-senha.jpeg" width="250"></td>
  </tr>
</table>

---

## 🏠 Home e exploração

<table>
  <tr>
    <th>Home</th>
    <th>Explorar receitas</th>
    <th>Detalhes da receita</th>
  </tr>
  <tr>
    <td><img src="assets/images/home.jpeg" width="250"></td>
    <td><img src="assets/images/explorarReceitas.jpeg" width="250"></td>
    <td><img src="assets/images/detalhesDaReceita.jpeg" width="250"></td>
  </tr>
</table>

---

## 🍽️ Publicação e gerenciamento de receitas

<table>
  <tr>
    <th>Minhas receitas</th>
    <th>Publicar receita</th>
    <th>Informações da receita</th>
  </tr>
  <tr>
    <td><img src="assets/images/minhasReceitas.jpeg" width="250"></td>
    <td><img src="assets/images/publicarReceita1.jpeg" width="250"></td>
    <td><img src="assets/images/publicarReceita2.jpeg" width="250"></td>
  </tr>
  <tr>
    <th>Editar receita</th>
    <th>Compartilhar receita</th>
    <th>Favoritos</th>
  </tr>
  <tr>
    <td><img src="assets/images/editarReceita.jpeg" width="250"></td>
    <td><img src="assets/images/CompartilhamentoDeReceita.png" width="250"></td>
    <td><img src="assets/images/favoritos.jpeg" width="250"></td>
  </tr>
</table>

---

## ❤️ Coleções

<table>
  <tr>
    <th>Coleções</th>
    <th>Nova coleção</th>
    <th>Editar e excluir coleção</th>
  </tr>
  <tr>
    <td><img src="assets/images/colecoes.jpeg" width="250"></td>
    <td><img src="assets/images/novaColecao.jpeg" width="250"></td>
    <td><img src="assets/images/colecaoEditarApagar.jpeg" width="250"></td>
  </tr>
</table>

---

## 👥 Recursos sociais

<table>
  <tr>
    <th>Seguidores</th>
    <th>Seguindo</th>
    <th>Notificações</th>
  </tr>
  <tr>
    <td><img src="assets/images/seguidores.jpeg" width="250"></td>
    <td><img src="assets/images/seguindo.jpeg" width="250"></td>
    <td><img src="assets/images/notificacoes.jpeg" width="250"></td>
  </tr>
</table>

---

## 👤 Perfil

<table>
  <tr>
    <th>Perfil</th>
    <th>Alterar foto de perfil</th>
    <th>Editar perfil</th>
  </tr>
  <tr>
    <td><img src="assets/images/perfil.jpeg" width="250"></td>
    <td><img src="assets/images/perfilTrocarImagem.jpeg" width="250"></td>
    <td><img src="assets/images/configuracoesEditarPerfil.jpeg" width="250"></td>
  </tr>
</table>

---

## ⚙️ Configurações

<table>
  <tr>
    <th>Configurações</th>
    <th>Preferências alimentares</th>
    <th>Tema</th>
  </tr>
  <tr>
    <td><img src="assets/images/configuracoes.jpeg" width="250"></td>
    <td><img src="assets/images/configuracoesPreferenciasAlimentares.jpeg" width="250"></td>
    <td><img src="assets/images/configuracoesTema.jpeg" width="250"></td>
  </tr>
  <tr>
    <th>Alterar senha</th>
    <th>Privacidade</th>
    <th>Política de privacidade</th>
  </tr>
  <tr>
    <td><img src="assets/images/configuracoesAlterarSenha.jpeg" width="250"></td>
    <td><img src="assets/images/configuracoesPrivacidade.jpeg" width="250"></td>
    <td><img src="assets/images/configuracoesPoliticaDePrivacidade.jpeg" width="250"></td>
  </tr>
  <tr>
    <th>Sobre o NutriGo</th>
    <th>Termos de uso</th>
    <th>Ajuda e suporte</th>
  </tr>
  <tr>
    <td><img src="assets/images/configuracoesSobre.jpeg" width="250"></td>
    <td><img src="assets/images/configuracoesTermosDeUso.jpeg" width="250"></td>
    <td><img src="assets/images/ajudaSuporte.jpeg" width="250"></td>
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

# 📚 Aprendizados do grupo

Durante o desenvolvimento do NutriGo, o grupo evoluiu o projeto de um protótipo inicial para uma aplicação Flutter integrada a serviços reais de backend.

Entre os principais aprendizados obtidos durante o desenvolvimento estão:

- Estruturação e desenvolvimento de aplicações multiplataforma com Flutter e Dart;
- Criação de interfaces reutilizáveis e consistentes com a identidade visual definida para o projeto;
- Gerenciamento de estado e atualização dinâmica das informações exibidas nas telas;
- Implementação de autenticação com e-mail, senha e Google OAuth;
- Integração do Flutter com Supabase Auth, PostgreSQL e Storage;
- Implementação de operações CRUD para dados persistentes;
- Upload, atualização e remoção de imagens armazenadas em nuvem;
- Criação de relacionamentos entre usuários, favoritos, coleções e notificações;
- Utilização de Row Level Security (RLS) para proteção dos dados;
- Utilização de chaves estrangeiras e restrições para garantir a integridade do banco de dados;
- Implementação e tratamento de deep links no Android;
- Organização do projeto utilizando modelos, telas, serviços e implementações específicas;
- Utilização do Git e GitHub para versionamento e evolução incremental do projeto;
- Importância de testes, validação de fluxos e revisão contínua durante o desenvolvimento.

A evolução entre os Checkpoints permitiu aplicar progressivamente os conceitos estudados na disciplina, partindo da idealização e do protótipo até uma aplicação integrada a um backend real.

---

# 🔄 Melhorias futuras

Com as funcionalidades principais do MVP implementadas, possíveis evoluções futuras do NutriGo incluem:

- Recomendações de receitas personalizadas de acordo com as preferências do usuário;
- Planejamento de refeições e cardápios;
- Ampliação das categorias e filtros de receitas;
- Melhorias adicionais de responsividade para diferentes tamanhos de tela;
- Expansão dos recursos sociais;
- Análises e estatísticas adicionais sobre a atividade do usuário;
- Otimizações de desempenho e experiência de uso.

Essas melhorias não fazem parte dos requisitos principais do MVP entregue no Checkpoint 6, mas representam possibilidades de evolução futura do produto.

---

# 📦 Checkpoint 6 — App Final

Para o Checkpoint 6, o NutriGo apresenta:

- Funcionalidades principais do MVP implementadas;
- Aplicação desenvolvida em Flutter/Dart;
- Backend integrado ao Supabase;
- Autenticação com e-mail, senha e Google OAuth;
- Persistência dos dados no PostgreSQL;
- Armazenamento de imagens no Supabase Storage;
- CRUD de receitas;
- Sistema de favoritos e coleções;
- Recursos sociais de seguidores e usuários seguidos;
- Sistema de notificações;
- Preferências e configurações persistentes;
- Políticas de segurança com Row Level Security;
- Documentação completa do projeto;
- Arquitetura e organização do código documentadas;
- Responsabilidades dos integrantes documentadas;
- Histórico de evolução mantido no GitHub;
- Validação estática realizada com `flutter analyze`, sem problemas identificados.

A etapa final restante é a geração do APK Android em modo release e a validação do arquivo instalável em dispositivo ou emulador.

---

# 📚 Projeto acadêmico

Projeto desenvolvido para a disciplina de **Cross-Platform Application Development (CPAD)**, utilizando Flutter e Dart como tecnologias principais para o desenvolvimento da aplicação.

O projeto foi desenvolvido de forma incremental ao longo dos Checkpoints, evoluindo da idealização e definição visual para um protótipo funcional e, posteriormente, para uma aplicação integrada ao Supabase com persistência de dados, autenticação, armazenamento de arquivos e recursos sociais.