import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view_model/add_visit_view_model.dart';
import '../../../view_model/visit_list_view_model.dart';

class AddVisitScreen extends StatefulWidget {
  const AddVisitScreen({super.key});

  @override
  State<AddVisitScreen> createState() => _AddVisitScreenState();
}

class _AddVisitScreenState extends State<AddVisitScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _farmerNameController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _farmerNameController.dispose();
    _villageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _onSavePressed() async {
    if (!_formKey.currentState!.validate()) return;

    final addVisitViewModel = context.read<AddVisitViewModel>();

    if (addVisitViewModel.capturedImageFile == null) {
      _showSnackBar('Please capture a photo before saving.');
      return;
    }

    final bool success = await addVisitViewModel.saveVisit(
      farmerName: _farmerNameController.text.trim(),
      village: _villageController.text.trim(),
      cropType: addVisitViewModel.selectedCropType!,
      imagePath: addVisitViewModel.capturedImageFile!.path,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    if (!mounted) return;

    if (!success) {
      _showSnackBar(
        addVisitViewModel.errorMessage ?? 'Something went wrong.',
        isWarning: true,
      );
      addVisitViewModel.clearError();
      return;
    }

    final syncError = addVisitViewModel.errorMessage;
    if (syncError != null) {
      _showSnackBar(syncError, isWarning: true);
      addVisitViewModel.clearError();
    }

    await context.read<VisitListViewModel>().loadVisits();
    Navigator.pop(context, true);
  }

  void _showSnackBar(String message, {bool isWarning = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isWarning ? Icons.warning_amber_rounded : Icons.info_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isWarning
            ? const Color(0xFFE65100)
            : const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AddVisitViewModel vm = context.watch<AddVisitViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text("Add New Visit"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionHeader(title: "Farmer Details"),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _farmerNameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: _inputDecoration("Farmer Name *", Icons.person_outline),
                        validator: (value) => value == null || value.trim().isEmpty
                            ? 'Enter farmer name'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _villageController,
                        textCapitalization: TextCapitalization.words,
                        decoration: _inputDecoration("Village *", Icons.location_city_outlined),
                        validator: (value) => value == null || value.trim().isEmpty
                            ? 'Enter village name'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: vm.selectedCropType,
                        decoration: _inputDecoration("Crop Type *", Icons.grass_outlined),
                        items: vm.cropOptions
                            .map((crop) => DropdownMenuItem(value: crop, child: Text(crop)))
                            .toList(),
                        onChanged: vm.selectCropType,
                        validator: (value) => value == null ? 'Select crop type' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: _inputDecoration("Notes (Optional)", Icons.notes_outlined),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionHeader(title: "Visit Photo"),
                      const SizedBox(height: 16),
                      _buildPhotoSection(vm),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: vm.isSaving ? null : _onSavePressed,
                    child: vm.isSaving
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text(
                      "Save Visit",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: child,
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: const Color(0xFFF7F9FB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildPhotoSection(AddVisitViewModel vm) {
    if (vm.capturedImageFile == null) {
      return GestureDetector(
        onTap: vm.capturePhoto,
        child: Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF2E7D32)),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt, size: 40, color: Color(0xFF2E7D32)),
              SizedBox(height: 8),
              Text(
                "Tap to Capture Photo",
                style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2E7D32)),
              ),
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        children: [
          Image.file(
            vm.capturedImageFile!,
            height: 220,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: vm.capturePhoto,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.refresh, size: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: Color(0xFF2E7D32),
      ),
    );
  }
}