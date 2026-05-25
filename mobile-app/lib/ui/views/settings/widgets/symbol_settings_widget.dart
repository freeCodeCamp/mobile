/// Symbol Settings Widget
///
/// Provides a comprehensive UI for managing symbol sets:
/// - View and switch between predefined symbol sets
/// - Create new custom symbol sets
/// - Edit and delete custom symbol sets
/// - Reset to defaults
///
/// This widget is embedded in the Settings view to give users
/// full control over their symbol bar customization.

import 'package:flutter/material.dart';
import 'package:freecodecamp/models/symbol_set_model.dart';
import 'package:freecodecamp/ui/viewmodels/symbol_bar_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SymbolSettingsWidget extends StatelessWidget {
  const SymbolSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SymbolBarViewModel>.reactive(
      viewModelBuilder: () => SymbolBarViewModel(),
      onViewModelReady: (model) => model.init(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Symbol Bar Settings'),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Predefined Sets Section
                _buildSectionHeader(context, 'Predefined Symbol Sets'),
                ...model.predefinedSets
                    .map((set) => _buildPredefinedSetTile(context, model, set))
                    .toList(),
                const Divider(),

                // Custom Sets Section
                _buildSectionHeader(context, 'Custom Symbol Sets'),
                if (model.customSymbolSets.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Text(
                      'No custom symbol sets created yet',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  )
                else
                  ...model.customSymbolSets
                      .map((set) => _buildCustomSetTile(context, model, set))
                      .toList(),

                // Create Custom Set Button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showCreateCustomSetDialog(context, model),
                      icon: const Icon(Icons.add),
                      label: const Text('Create Custom Set'),
                    ),
                  ),
                ),

                const Divider(),

                // Reset to Defaults Button
                if (model.customSymbolSets.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _showResetConfirmDialog(context, model),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset to Defaults'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build a predefined set ListTile
  Widget _buildPredefinedSetTile(
    BuildContext context,
    SymbolBarViewModel model,
    PredefinedSymbolSet set,
  ) {
    final isActive = model.activeSet is PredefinedSymbolSet &&
        (model.activeSet as PredefinedSymbolSet).type == set.type;

    return ListTile(
      leading: Icon(
        isActive ? Icons.check_circle : Icons.radio_button_unchecked,
        color: isActive ? Colors.green : Colors.grey,
      ),
      title: Text(set.type.displayName),
      subtitle: Text(
        '${set.symbols.length} symbols',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: _buildSymbolPreview(set.symbols),
      onTap: () => model.switchToPredefinedSet(set.type),
    );
  }

  /// Build a custom set ListTile with edit/delete options
  Widget _buildCustomSetTile(
    BuildContext context,
    SymbolBarViewModel model,
    CustomSymbolSet set,
  ) {
    final isActive = model.activeSet is CustomSymbolSet &&
        (model.activeSet as CustomSymbolSet).name == set.name;

    return ListTile(
      leading: Icon(
        isActive ? Icons.check_circle : Icons.radio_button_unchecked,
        color: isActive ? Colors.green : Colors.grey,
      ),
      title: Text(set.name),
      subtitle: Text(
        '${set.symbols.length} symbols',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: SizedBox(
        width: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              tooltip: 'Edit',
              onPressed: () => _showEditCustomSetDialog(context, model, set),
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
              tooltip: 'Delete',
              onPressed: () => _showDeleteConfirmDialog(context, model, set),
            ),
          ],
        ),
      ),
      onTap: () => model.switchToCustomSet(set.name),
    );
  }

  /// Build a small preview of symbols
  Widget _buildSymbolPreview(List<String> symbols) {
    final preview = symbols.take(3).join(' ');
    return Tooltip(
      message: symbols.join(', '),
      child: Text(
        preview + (symbols.length > 3 ? '...' : ''),
        style: const TextStyle(
          fontSize: 11,
          fontFamily: 'monospace',
        ),
      ),
    );
  }

  /// Build a section header
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ==================== DIALOGS ====================

  /// Show dialog to create a new custom symbol set
  void _showCreateCustomSetDialog(
    BuildContext context,
    SymbolBarViewModel model,
  ) {
    final nameController = TextEditingController();
    final symbolsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Custom Symbol Set'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Set Name',
                  hintText: 'e.g., My Custom Symbols',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: symbolsController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Symbols (comma-separated)',
                  hintText: 'e.g., (, ), {, }, [, ]',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Separate symbols with commas. Maximum 50 symbols.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final symbolsText = symbolsController.text.trim();

              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a set name')),
                );
                return;
              }

              final symbols = symbolsText
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList();

              if (symbols.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter at least one symbol')),
                );
                return;
              }

              if (symbols.length > 50) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Maximum 50 symbols allowed')),
                );
                return;
              }

              try {
                model.createCustomSet(name: name, symbols: symbols);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Custom set "$name" created')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  /// Show dialog to edit a custom symbol set
  void _showEditCustomSetDialog(
    BuildContext context,
    SymbolBarViewModel model,
    CustomSymbolSet set,
  ) {
    final nameController = TextEditingController(text: set.name);
    final symbolsController = TextEditingController(text: set.symbols.join(', '));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit "${set.name}"'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Set Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: symbolsController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Symbols (comma-separated)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Separate symbols with commas. Maximum 50 symbols.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = nameController.text.trim();
              final symbolsText = symbolsController.text.trim();

              if (newName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a set name')),
                );
                return;
              }

              final symbols = symbolsText
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList();

              if (symbols.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter at least one symbol')),
                );
                return;
              }

              if (symbols.length > 50) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Maximum 50 symbols allowed')),
                );
                return;
              }

              try {
                model.updateCustomSet(
                  currentName: set.name,
                  newName: newName,
                  newSymbols: symbols,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Custom set updated')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  /// Show confirmation dialog to delete a custom set
  void _showDeleteConfirmDialog(
    BuildContext context,
    SymbolBarViewModel model,
    CustomSymbolSet set,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Custom Set?'),
        content: Text(
          'Are you sure you want to delete "${set.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              model.deleteCustomSet(set.name);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Custom set "${set.name}" deleted')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  /// Show confirmation dialog to reset all to defaults
  void _showResetConfirmDialog(
    BuildContext context,
    SymbolBarViewModel model,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Defaults?'),
        content: const Text(
          'This will delete all custom symbol sets and reset to the predefined sets. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              model.resetToDefaults();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reset to defaults')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
