import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/nosok_companies_controller.dart';
import '../../../application/nosok_seasons_controller.dart';
import '../../../system_routes.dart';
import '../../widgets/nosok_section_card.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokCompaniesPage extends ConsumerStatefulWidget {
  const NosokCompaniesPage({super.key});

  @override
  ConsumerState<NosokCompaniesPage> createState() => _NosokCompaniesPageState();
}

class _NosokCompaniesPageState extends ConsumerState<NosokCompaniesPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _seasonId;
  String? _query;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seasonsAsync = ref.watch(nosokPublicSeasonsProvider);
    final companiesAsync = ref.watch(
      nosokPublicCompaniesProvider(
        NosokPublicCompaniesFilter(query: _query, seasonId: _seasonId),
      ),
    );

    return PwfSisPublicServiceShell(
      children: [
        PwfSisPremiumPublicHero(
          title: 'الشركات المؤهلة',
          description:
              'اطلع على الشركات المنشورة للجمهور وابحث بالاسم أو العنوان أو الرخصة وفق الموسم المتاح.',
          badges: const ['شركات معتمدة', 'بحث وفلاتر', 'موسمية'],
          icon: Icons.business_center_outlined,
          primaryAction: FilledButton.icon(
              onPressed: () => context.go(NosokSystemRoutes.contact),
              icon: const Icon(Icons.support_agent_outlined),
              label: const Text('طلب مساعدة')),
          secondaryAction: OutlinedButton.icon(
              onPressed: () => context.go(NosokSystemRoutes.companyLogin),
              icon: const Icon(Icons.business_outlined),
              label: const Text('بوابة الشركات')),
        ),
        const SizedBox(height: 16),
        NosokSectionCard(
          title: 'البحث والفلترة',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 320,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'بحث بالاسم أو الرخصة أو العنوان',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = null);
                      },
                      icon: const Icon(Icons.clear),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (value) => setState(() =>
                      _query = value.trim().isEmpty ? null : value.trim()),
                ),
              ),
              SizedBox(
                width: 280,
                child: seasonsAsync.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (seasons) {
                    return DropdownButtonFormField<String?>(
                      initialValue: _seasonId,
                      decoration: const InputDecoration(
                        labelText: 'فلترة بالموسم',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem<String?>(
                            value: null, child: Text('كل المواسم')),
                        ...seasons.map((season) => DropdownMenuItem<String?>(
                              value: season.id,
                              child: Text(season.titleAr),
                            )),
                      ],
                      onChanged: (value) => setState(() => _seasonId = value),
                    );
                  },
                ),
              ),
              FilledButton.icon(
                onPressed: () => setState(() => _query =
                    _searchController.text.trim().isEmpty
                        ? null
                        : _searchController.text.trim()),
                icon: const Icon(Icons.filter_alt_outlined),
                label: const Text('تطبيق'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        companiesAsync.when(
          loading: () => const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (error, stack) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child:
                  const Text('تعذر تحميل الشركات حاليًا. أعد المحاولة لاحقًا.'),
            ),
          ),
          data: (companies) {
            if (companies.isEmpty) {
              return const NosokSectionCard(
                title: 'لا توجد نتائج',
                child: Text('لا توجد شركات مؤهلة منشورة وفق الفلاتر الحالية.'),
              );
            }
            return NosokSectionCard(
              title: 'الشركات',
              subtitle: 'عدد النتائج: ${companies.length}',
              child: Column(
                children: companies.map((company) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(company.companyNameAr),
                      subtitle: Text(
                        [
                          if ((company.licenseNo ?? '').isNotEmpty)
                            'الرخصة: ${company.licenseNo}',
                          company.mobile ?? company.phone ?? 'بدون هاتف',
                          company.addressText ?? 'بدون عنوان',
                        ].join(' • '),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(company.status),
                          if ((company.currentSeasonQualificationStatus ?? '')
                              .isNotEmpty)
                            Text(
                              company.currentSeasonQualificationStatus!,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}
