import 'package:flutter/material.dart';
import 'package:tez_med_client/core/extension/localization_extension.dart';
import 'package:tez_med_client/data/clinic/model/clinics_model.dart';
import 'package:tez_med_client/generated/l10n.dart';

class ClinicSearchDialog extends StatefulWidget {
  final List<Clinic> clinics;
  final Function(Clinic) onClinicSelected;

  const ClinicSearchDialog({
    super.key,
    required this.clinics,
    required this.onClinicSelected,
  });

  @override
  State<ClinicSearchDialog> createState() => _ClinicSearchDialogState();
}

class _ClinicSearchDialogState extends State<ClinicSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<Clinic> _filteredClinics = [];

  @override
  void initState() {
    super.initState();
    _filteredClinics = widget.clinics;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterClinics(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredClinics = widget.clinics;
      } else {
        final lowercaseQuery = query.toLowerCase();
        _filteredClinics = widget.clinics.where((clinic) {
          return clinic.nameUz.toLowerCase().contains(lowercaseQuery) ||
              clinic.nameRu.toLowerCase().contains(lowercaseQuery) ||
              clinic.nameEn.toLowerCase().contains(lowercaseQuery) ||
              clinic.address.toLowerCase().contains(lowercaseQuery);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Text(
              S.of(context).search_clinic,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Search field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: S.of(context).clinic_name_or_address,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
              onChanged: _filterClinics,
            ),
            const SizedBox(height: 16),

            // Results list
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: _filteredClinics.isEmpty
                    ?  Center(
                        child: Text(S.of(context).no_clinics_found),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: _filteredClinics.length,
                        itemBuilder: (context, index) {
                          final clinic = _filteredClinics[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              context.toLocalized(
                                uz: clinic.nameUz,
                                ru: clinic.nameRu,
                                en: clinic.nameEn,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              clinic.address,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              widget.onClinicSelected(clinic);
                            },
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(height: 8),

            // Close button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(S.of(context).close),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
