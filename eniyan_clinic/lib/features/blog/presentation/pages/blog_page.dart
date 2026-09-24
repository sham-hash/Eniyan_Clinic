import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_feedback.dart';
import '../../../../shared/widgets/clinic_app_bar.dart';
import '../../../profile/presentation/notification_navigation.dart';

class BlogAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BlogAppBar({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return ClinicHeader(
      title: 'Health & Wellness',
      showBackButton: true,
      onBack: onBack ?? () => Navigator.of(context).maybePop(),
      onNotificationTap: () => openNotifications(context),
      onProfileTap: () => openProfile(context),
    );
  }
}

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  int _selectedCategory = 0;

  static const _categories = ['All', 'Child Health', 'Nutrition', 'Parenting'];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 32),
      children: [
        const Text(
          'Helpful guidance for\nhealthier, happier families.',
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 25,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final isSelected = _selectedCategory == index;
              return ChoiceChip(
                label: Text(_categories[index]),
                selected: isSelected,
                onSelected: (_) => setState(() => _selectedCategory = index),
                selectedColor: AppColors.blue,
                backgroundColor: AppColors.white,
                side: BorderSide(
                  color: isSelected ? AppColors.blue : AppColors.borderLight,
                ),
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.white : AppColors.textBlueGray,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 22),
        const _FeaturedArticle(),
        const SizedBox(height: 28),
        const _BlogSectionHeader(title: 'Latest articles'),
        const SizedBox(height: 14),
        ..._articles.map(
          (article) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _ArticleCard(article: article),
          ),
        ),
      ],
    );
  }
}

const _articles = [
  _Article(
    category: 'Child Health',
    title: 'The little rituals that make bedtime easier',
    summary: 'Simple routines that help children settle into restful sleep.',
    date: '08 Sep 2026',
    color: AppColors.purpleLight,
    icon: Icons.nightlight_round,
  ),
  _Article(
    category: 'Nutrition',
    title: 'Building a happy, healthy plate for your child',
    summary: 'Practical ways to make everyday meals balanced and enjoyable.',
    date: '12 Sep 2026',
    color: AppColors.blueLight,
    icon: Icons.restaurant_rounded,
  ),
  _Article(
    category: 'Parenting',
    title: 'Understanding your child’s changing emotions',
    summary:
        'A calm, compassionate approach to big feelings and small moments.',
    date: '15 Sep 2026',
    color: AppColors.softGreen,
    icon: Icons.favorite_rounded,
  ),
];

class _FeaturedArticle extends StatelessWidget {
  const _FeaturedArticle();

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A315D8B),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 128,
            width: double.infinity,
            color: AppColors.blueLight,
            child: const Center(
              child: Icon(
                Icons.health_and_safety_rounded,
                color: AppColors.blue,
                size: 62,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FEATURED ARTICLE',
                  style: TextStyle(
                    color: AppColors.green,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'A parent’s guide to confident everyday care',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Trusted insights from the Eniyan Clinic care team.',
                  style: TextStyle(color: AppColors.gray, fontSize: 13),
                ),
                const SizedBox(height: 14),
                TextButton.icon(
                  onPressed: () =>
                      showAppMessage(context, 'Featured article opened.'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    foregroundColor: AppColors.blue,
                  ),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 19),
                  label: const Text('Read article'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BlogSectionHeader extends StatelessWidget {
  const _BlogSectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const Icon(Icons.tune_rounded, color: AppColors.blue, size: 20),
      ],
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article});

  final _Article article;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => showAppMessage(context, '${article.title} opened.'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 76,
                height: 76,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: article.color,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(article.icon, color: AppColors.blue, size: 34),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.category,
                      style: const TextStyle(
                        color: AppColors.blue,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.date,
                      style: const TextStyle(
                        color: AppColors.gray,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.blue),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlogNotificationButton extends StatelessWidget {
  const _BlogNotificationButton();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: () => openNotifications(context),
          tooltip: 'Notifications',
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.blue,
            size: 23,
          ),
        ),
        Positioned(
          top: 3,
          right: 4,
          child: Container(
            width: 14,
            height: 14,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.red,
              shape: BoxShape.circle,
            ),
            child: const Text(
              '3',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BlogProfileAvatar extends StatelessWidget {
  const _BlogProfileAvatar({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.softBlue,
        borderRadius: BorderRadius.circular(11),
      ),
      child: const Icon(
        Icons.person_outline_rounded,
        color: AppColors.blue,
        size: 20,
      ),
      ),
    );
  }
}

class _Article {
  const _Article({
    required this.category,
    required this.title,
    required this.summary,
    required this.date,
    required this.color,
    required this.icon,
  });

  final String category;
  final String title;
  final String summary;
  final String date;
  final Color color;
  final IconData icon;
}
