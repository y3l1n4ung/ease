import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';

/// Main widget for the Ease DevTools extension.
class EaseDevToolsExtension extends StatefulWidget {
  const EaseDevToolsExtension({super.key});

  @override
  State<EaseDevToolsExtension> createState() => _EaseDevToolsExtensionState();
}

class _EaseDevToolsExtensionState extends State<EaseDevToolsExtension> {
  List<Map<String, dynamic>> _states = [];
  List<Map<String, dynamic>> _history = [];
  String? _selectedStateId;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _refreshStates();
  }

  Future<void> _refreshStates() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final service = serviceManager.service;
      if (service == null) {
        setState(() {
          _error = 'VM Service not connected';
          _isLoading = false;
        });
        return;
      }

      final isolateId = serviceManager.isolateManager.selectedIsolate.value?.id;
      if (isolateId == null) {
        setState(() {
          _error = 'No isolate selected';
          _isLoading = false;
        });
        return;
      }

      final response = await service.callServiceExtension(
        'ext.ease.getStates',
        isolateId: isolateId,
      );
      // The response.json contains the parsed JSON directly
      final responseJson = response.json ?? {};
      final states = (responseJson['states'] as List?)?.cast<Map<String, dynamic>>() ?? [];

      setState(() {
        _states = states;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load states: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadHistory([String? stateId]) async {
    try {
      final service = serviceManager.service;
      if (service == null) return;

      final isolateId = serviceManager.isolateManager.selectedIsolate.value?.id;
      if (isolateId == null) return;

      final args = stateId != null ? {'stateId': stateId} : <String, String>{};
      final response = await service.callServiceExtension(
        'ext.ease.getHistory',
        isolateId: isolateId,
        args: args,
      );
      // The response.json contains the parsed JSON directly
      final responseJson = response.json ?? {};
      final history = (responseJson['history'] as List?)?.cast<Map<String, dynamic>>() ?? [];

      setState(() {
        _history = history;
        _selectedStateId = stateId;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load history: $e';
      });
    }
  }

  Future<void> _clearHistory() async {
    try {
      final service = serviceManager.service;
      if (service == null) return;

      final isolateId = serviceManager.isolateManager.selectedIsolate.value?.id;
      if (isolateId == null) return;

      await service.callServiceExtension(
        'ext.ease.clearHistory',
        isolateId: isolateId,
      );
      _loadHistory(_selectedStateId);
    } catch (e) {
      setState(() {
        _error = 'Failed to clear history: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          // Left panel - States list
          SizedBox(
            width: 320,
            child: _buildStatesPanel(theme),
          ),
          const VerticalDivider(width: 1),
          // Right panel - History
          Expanded(
            child: _buildHistoryPanel(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildStatesPanel(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPanelHeader(
          theme,
          title: 'States',
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, size: 18),
              onPressed: _refreshStates,
              tooltip: 'Refresh',
            ),
          ],
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _error!,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        if (_isLoading)
          const Expanded(
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_states.isEmpty)
          const Expanded(
            child: Center(
              child: Text('No states registered'),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: _states.length,
              itemBuilder: (context, index) {
                final state = _states[index];
                final isSelected = state['id'] == _selectedStateId;

                return _StateListTile(
                  state: state,
                  isSelected: isSelected,
                  onTap: () => _loadHistory(state['id'] as String?),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildHistoryPanel(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPanelHeader(
          theme,
          title: _selectedStateId != null
              ? 'History: ${_getStateName(_selectedStateId!)}'
              : 'History (All)',
          actions: [
            if (_selectedStateId != null)
              TextButton(
                onPressed: () => _loadHistory(null),
                child: const Text('Show All'),
              ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              onPressed: _clearHistory,
              tooltip: 'Clear History',
            ),
            IconButton(
              icon: const Icon(Icons.refresh, size: 18),
              onPressed: () => _loadHistory(_selectedStateId),
              tooltip: 'Refresh',
            ),
          ],
        ),
        if (_history.isEmpty)
          const Expanded(
            child: Center(
              child: Text('No state changes recorded'),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                // Show newest first
                final record = _history[_history.length - 1 - index];
                return _HistoryListTile(record: record);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildPanelHeader(
    ThemeData theme, {
    required String title,
    List<Widget> actions = const [],
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          ...actions,
        ],
      ),
    );
  }

  String _getStateName(String stateId) {
    final state = _states.firstWhere(
      (s) => s['id'] == stateId,
      orElse: () => {'type': stateId},
    );
    return state['type'] as String? ?? stateId;
  }
}

class _StateListTile extends StatelessWidget {
  const _StateListTile({
    required this.state,
    required this.isSelected,
    required this.onTap,
  });

  final Map<String, dynamic> state;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final type = state['type'] as String? ?? 'Unknown';
    final value = state['value'] as String? ?? '';
    final hasListeners = state['hasListeners'] as bool? ?? false;

    return ListTile(
      selected: isSelected,
      selectedTileColor: theme.colorScheme.primaryContainer.withOpacity(0.3),
      onTap: onTap,
      title: Row(
        children: [
          Expanded(
            child: Text(
              type,
              style: const TextStyle(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (hasListeners)
            Tooltip(
              message: 'Has active listeners',
              child: Icon(
                Icons.hearing,
                size: 14,
                color: theme.colorScheme.primary,
              ),
            ),
        ],
      ),
      subtitle: Text(
        value,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 11,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      dense: true,
    );
  }
}

class _HistoryListTile extends StatelessWidget {
  const _HistoryListTile({required this.record});

  final Map<String, dynamic> record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stateName = record['stateName'] as String? ?? 'Unknown';
    final oldState = record['oldState'] as String? ?? '';
    final newState = record['newState'] as String? ?? '';
    final action = record['action'] as String?;
    final timestamp = record['timestamp'] as String? ?? '';

    // Format timestamp
    String formattedTime = '';
    try {
      final dt = DateTime.parse(timestamp);
      formattedTime = '${dt.hour.toString().padLeft(2, '0')}:'
          '${dt.minute.toString().padLeft(2, '0')}:'
          '${dt.second.toString().padLeft(2, '0')}.'
          '${dt.millisecond.toString().padLeft(3, '0')}';
    } catch (_) {
      formattedTime = timestamp;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    stateName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                if (action != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      action,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                Text(
                  formattedTime,
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _StateValueBox(
                    label: 'Before',
                    value: oldState,
                    color: theme.colorScheme.errorContainer,
                    textColor: theme.colorScheme.onErrorContainer,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Expanded(
                  child: _StateValueBox(
                    label: 'After',
                    value: newState,
                    color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                    textColor: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StateValueBox extends StatelessWidget {
  const _StateValueBox({
    required this.label,
    required this.value,
    required this.color,
    required this.textColor,
  });

  final String label;
  final String value;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: textColor.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              color: textColor,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
