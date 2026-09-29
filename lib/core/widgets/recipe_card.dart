import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../../models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final bool showCategory;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onTap;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.showCategory = false,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(
          AppTheme.spacingSm,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .surface,
          borderRadius:
              BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            _buildRecipeImage(),

            const SizedBox(
              width: AppTheme.spacingMd,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  if (showCategory) ...[
                    Text(
                      recipe.category,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                            color: Theme.of(
                              context,
                            )
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),
                  ],

                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          recipe.title,
                          style: Theme.of(
                            context,
                          )
                              .textTheme
                              .bodyLarge,
                        ),
                      ),

                      IconButton(
                        onPressed:
                            onFavoriteTap,
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons
                                  .favorite_border,
                          color: isFavorite
                              ? AppTheme
                                  .verdePrincipal
                              : Theme.of(
                                  context,
                                )
                                    .colorScheme
                                    .onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height:
                        AppTheme.spacingSm,
                  ),

                  Wrap(
                    spacing:
                        AppTheme.spacingMd,
                    runSpacing:
                        AppTheme.spacingSm,
                    children: [
                      Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 17,
                            color: Theme.of(
                              context,
                            )
                                .colorScheme
                                .onSurfaceVariant,
                          ),

                          const SizedBox(
                            width: 4,
                          ),

                          Text(
                            recipe.time,
                            style: Theme.of(
                              context,
                            )
                                .textTheme
                                .bodyMedium,
                          ),
                        ],
                      ),

                      Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          Icon(
                            Icons
                                .signal_cellular_alt,
                            size: 17,
                            color: Theme.of(
                              context,
                            )
                                .colorScheme
                                .onSurfaceVariant,
                          ),

                          const SizedBox(
                            width: 4,
                          ),

                          Text(
                            recipe.difficulty,
                            style: Theme.of(
                              context,
                            )
                                .textTheme
                                .bodyMedium,
                          ),
                        ],
                      ),

                      Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          Icon(
                            Icons
                                .local_fire_department_outlined,
                            size: 17,
                            color: Theme.of(
                              context,
                            )
                                .colorScheme
                                .onSurfaceVariant,
                          ),

                          const SizedBox(
                            width: 4,
                          ),

                          Text(
                            recipe.calories,
                            style: Theme.of(
                              context,
                            )
                                .textTheme
                                .bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeImage() {
    // Foto escolhida pelo usuário.
    if (recipe.imageBytes != null) {
      return ClipRRect(
        borderRadius:
            BorderRadius.circular(14),
        child: Image.memory(
          recipe.imageBytes!,
          width: 110,
          height: 100,
          fit: BoxFit.cover,
        ),
      );
    }

    // Imagem original que está nos assets.
    if (recipe.imagePath != null) {
      return ClipRRect(
        borderRadius:
            BorderRadius.circular(14),
        child: Image.asset(
          recipe.imagePath!,
          width: 110,
          height: 100,
          fit: BoxFit.cover,
        ),
      );
    }

    // Receita sem nenhuma imagem.
    return Container(
      width: 110,
      height: 100,
      decoration: BoxDecoration(
        color: AppTheme.verdeClaro,
        borderRadius:
            BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.restaurant,
        color: AppTheme.verdePrincipal,
        size: 36,
      ),
    );
  }
}