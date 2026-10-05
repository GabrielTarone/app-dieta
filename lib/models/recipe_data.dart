import 'recipe.dart';

const Recipe panqueca = Recipe(
  title: 'Panqueca de banana e aveia',
  category: 'Café da manhã',
  imagePath: 'assets/images/imagemPanquecaDeBananaAveia.png',
  time: '15 min',
  timeMinutes: 15,
  difficulty: 'Fácil',
  calories: '320 kcal',
  caloriesValue: 320,
  servings: 1,
  diets: [
    'Vegetariana',
  ],
  ingredients: [
    '2 ovos',
    '1 banana',
    '3 colheres de aveia',
    'Canela a gosto',
  ],
  preparation: [
    'Amasse a banana em um recipiente.',
    'Adicione os ovos e misture bem.',
    'Acrescente a aveia e a canela.',
    'Despeje a mistura em uma frigideira aquecida.',
    'Doure dos dois lados e sirva.',
  ],
);

const Recipe frango = Recipe(
  title: 'Frango grelhado com legumes',
  category: 'Almoço',
  imagePath: 'assets/images/imagemFrangoGrelhadoComLegumes.png',
  time: '30 min',
  timeMinutes: 30,
  difficulty: 'Médio',
  calories: '410 kcal',
  caloriesValue: 410,
  servings: 1,
  diets: [
    'Sem glúten',
  ],
  ingredients: [
    '1 filé de peito de frango',
    '1 cenoura',
    '1 abobrinha',
    '1 colher de azeite',
    'Sal e temperos a gosto',
  ],
  preparation: [
    'Tempere o filé de frango a gosto.',
    'Corte a cenoura e a abobrinha.',
    'Aqueça o azeite em uma frigideira.',
    'Grelhe o frango até ficar bem cozido.',
    'Refogue os legumes e sirva com o frango.',
  ],
);

const Recipe sanduiche = Recipe(
  title: 'Sanduíche natural de frango',
  category: 'Lanches',
  imagePath: 'assets/images/imagemSanduicheNaturalDeFrango.png',
  time: '10 min',
  timeMinutes: 10,
  difficulty: 'Fácil',
  calories: '280 kcal',
  caloriesValue: 280,
  servings: 1,
  diets: [
    'Sem lactose',
  ],
  ingredients: [
    '2 fatias de pão integral',
    '100 g de frango desfiado',
    '2 colheres de iogurte natural',
    '1 folha de alface',
    'Tomate a gosto',
    'Sal e temperos a gosto',
  ],
  preparation: [
    'Coloque o frango desfiado em um recipiente.',
    'Adicione o iogurte natural e misture bem.',
    'Tempere a mistura a gosto.',
    'Coloque o frango sobre uma fatia de pão.',
    'Adicione a alface e o tomate.',
    'Feche o sanduíche com a outra fatia e sirva.',
  ],
);

const Recipe smoothieVerde = Recipe(
  title: 'Smoothie verde',
  category: 'Café da manhã',
  imagePath: 'assets/images/imagemSmoothieVerde.png',
  time: '5 min',
  timeMinutes: 5,
  difficulty: 'Fácil',
  calories: '180 kcal',
  caloriesValue: 180,
  servings: 1,
  diets: [
    'Vegetariana',
    'Sem glúten',
  ],
  ingredients: [
    '1 banana',
    '1 folha de couve',
    '200 ml de leite',
    'Gelo a gosto',
  ],
  preparation: [
    'Lave bem a folha de couve.',
    'Corte a banana em pedaços.',
    'Coloque todos os ingredientes no liquidificador.',
    'Bata até obter uma mistura homogênea.',
    'Sirva em seguida.',
  ],
);

const Recipe bowlFrangoQuinoa = Recipe(
  title: 'Bowl de frango com quinoa',
  category: 'Almoço',
  imagePath: 'assets/images/imagemBowlDeFrangoComQuinoa.png',
  time: '35 min',
  timeMinutes: 35,
  difficulty: 'Médio',
  calories: '380 kcal',
  caloriesValue: 380,
  servings: 4,
  diets: [
    'Sem glúten',
  ],
  ingredients: [
    '100 g de peito de frango',
    '1/2 xícara de quinoa',
    '1/2 cenoura',
    '1/2 pepino',
    'Folhas verdes a gosto',
    'Sal e temperos a gosto',
  ],
  preparation: [
    'Cozinhe a quinoa conforme as instruções da embalagem.',
    'Tempere o frango e grelhe até ficar bem cozido.',
    'Corte a cenoura e o pepino.',
    'Coloque a quinoa e as folhas verdes em uma tigela.',
    'Adicione o frango e os legumes.',
    'Tempere a gosto e sirva.',
  ],
);

const Recipe saladaMediterranea = Recipe(
  title: 'Salada mediterrânea',
  category: 'Jantar',
  imagePath: 'assets/images/imagemSaladaMediterranea.png',
  time: '15 min',
  timeMinutes: 15,
  difficulty: 'Fácil',
  calories: '250 kcal',
  caloriesValue: 250,
  servings: 2,
  diets: [
    'Vegetariana',
    'Sem glúten',
  ],
  ingredients: [
    'Folhas verdes a gosto',
    '1 tomate',
    '1/2 pepino',
    'Azeitonas a gosto',
    'Queijo branco a gosto',
    '1 colher de azeite',
  ],
  preparation: [
    'Lave bem as folhas e os legumes.',
    'Corte o tomate e o pepino.',
    'Coloque as folhas em uma tigela.',
    'Adicione o tomate, o pepino e as azeitonas.',
    'Acrescente o queijo branco.',
    'Finalize com azeite e sirva.',
  ],
);

const Recipe omeleteLegumes = Recipe(
  title: 'Omelete de legumes',
  category: 'Jantar',
  imagePath: 'assets/images/imagemOmeleteDeLegumes.png',
  time: '15 min',
  timeMinutes: 15,
  difficulty: 'Fácil',
  calories: '290 kcal',
  caloriesValue: 290,
  servings: 1,
  diets: [
    'Vegetariana',
    'Sem glúten',
  ],
  ingredients: [
    '2 ovos',
    '1/2 tomate',
    '1/2 cenoura',
    '1/4 de cebola',
    'Cheiro-verde a gosto',
    'Sal e temperos a gosto',
  ],
  preparation: [
    'Quebre os ovos em um recipiente e misture bem.',
    'Corte os legumes em pedaços pequenos.',
    'Misture os legumes com os ovos.',
    'Tempere a gosto.',
    'Despeje a mistura em uma frigideira aquecida.',
    'Doure dos dois lados e sirva.',
  ],
);

const List<Recipe> receitas = [
  panqueca,
  frango,
  sanduiche,
  smoothieVerde,
  bowlFrangoQuinoa,
  saladaMediterranea,
  omeleteLegumes,
];