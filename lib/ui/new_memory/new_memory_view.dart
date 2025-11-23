import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import './widgets/new_memory_appbar.dart';
import './widgets/image_preview.dart';
import './widgets/note_text_field.dart';
import './widgets/add_media.dart';
import './new_memory_view_model.dart';
import '/ui/common/recents_view_model.dart';

// TODO: Tapping on free space below TextField should focus on it if unfocused.

class NewMemoryView extends ConsumerStatefulWidget {
  const NewMemoryView({super.key});

  @override
  ConsumerState<NewMemoryView> createState() => _NewMemoryViewState();
}

class _NewMemoryViewState extends ConsumerState<NewMemoryView>
    with WidgetsBindingObserver {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocusNode = FocusNode();

  late double _lastViewInsetsBottom;

  double get _currentViewInsetsBottom =>
      WidgetsBinding.instance.platformDispatcher.views.first.viewInsets.bottom;

  Future<bool> _confirmDiscardAlert() async {
    final viewModel = ref.read(newMemoryViewModelProvider);
    if (!viewModel.hasContent) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Discard changes?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              "Discard",
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<void> _handleImagePressed() async {
    await ref.read(newMemoryViewModelProvider.notifier).pickImage();
  }

  void _placeholder() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(height: 200, child: Center(child: Text("Placeholder")));
      },
    );
  }

  Future<void> _handleSavePressed() async {
    final success = await ref
        .read(newMemoryViewModelProvider.notifier)
        .saveMemory();

    if (success) {
      ref.invalidate(recentMemoriesProvider);
      if (mounted) Navigator.of(context).pop();
    } else {
      final error = ref.read(newMemoryViewModelProvider).error;
      if (error != null && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      ref
          .read(newMemoryViewModelProvider.notifier)
          .updateNote(_textController.text);
    });
    WidgetsBinding.instance.addObserver(this);
    _lastViewInsetsBottom = _currentViewInsetsBottom;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _textController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottom = _currentViewInsetsBottom;

    // If keyboard went from visible (>0) to hidden (0) and TextField still focused, unfocus it.
    if (_lastViewInsetsBottom > 0 &&
        bottom == 0 &&
        _textFieldFocusNode.hasFocus) {
      _textFieldFocusNode.unfocus();
    }
    _lastViewInsetsBottom = bottom;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(newMemoryViewModelProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _confirmDiscardAlert();
        if (shouldPop && context.mounted) Navigator.of(context).pop(result);
      },
      child: Scaffold(
        appBar: NewMemoryAppbar(
          hasContent: state.hasContent,
          selectedDate: state.selectedDate,
          hasImage: state.pickedImage != null,
          onDateChanged: (newDate) =>
              ref.read(newMemoryViewModelProvider.notifier).updateDate(newDate),
          onSavePressed: _handleSavePressed,
          onImagePressed: _handleImagePressed,
          onVoicePressed: _placeholder,
          onTagsPressed: _placeholder,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 8),
                  children: [
                    ImagePreview(
                      image: state.pickedImage,
                      onRemove: () => ref
                          .read(newMemoryViewModelProvider.notifier)
                          .removeImage(),
                    ),
                    NoteTextField(
                      controller: _textController,
                      focusNode: _textFieldFocusNode,
                    ),
                  ],
                ),
              ),
              if (!state.hasContent)
                SizedBox(
                  height: kToolbarHeight + 8,
                  child: AddMedia(
                    onImagePressed: _handleImagePressed,
                    onVoicePressed: _placeholder,
                  ),
                ),
            ],
          ),
        ),
        bottomNavigationBar: state.hasContent
            ? SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    DateFormat('hh:mm a').format(state.selectedDate),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
