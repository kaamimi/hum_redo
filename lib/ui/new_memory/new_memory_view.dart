import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './widgets/new_memory_appbar.dart';
import './widgets/image_preview.dart';
import './widgets/note_text_field.dart';
import './widgets/add_media.dart';
import './new_memory_view_model.dart';
import '/ui/collections/collections_view_model.dart';

// TODO: Tapping on free space below TextField should focus on it if unfocused.

class NewMemoryView extends ConsumerStatefulWidget {
  const NewMemoryView({super.key});

  @override
  ConsumerState<NewMemoryView> createState() => _NewMemoryViewState();
}

class _NewMemoryViewState extends ConsumerState<NewMemoryView>
    with WidgetsBindingObserver {
  File? _pickedImage;
  // File? _pickedVoiceNote;
  DateTime _selectedDate = DateTime.now();

  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocusNode = FocusNode();

  double _lastViewInsetsBottom = 0;

  bool get _hasContent =>
      _pickedImage != null || _textController.text.trim().isNotEmpty;

  Future<bool> _confirmDiscard() async {
    if (!_hasContent) return true;

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

  void _handleImageRemoved() {
    if (mounted) setState(() => _pickedImage = null);
  }

  Future<void> _handleImagePressed() async {
    final picker = ref.read(imageHandlerProvider);
    File? image = await picker.pickFromGallery();
    if (image != null && mounted) setState(() => _pickedImage = image);
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
    final note = _textController.text.trim();

    await ref.read(
      saveMemoryProvider((
        note: note.isNotEmpty ? note : null,
        imageFile: _pickedImage,
        createdAt: _selectedDate,
      )).future,
    );

    // Invalidate the memories provider to refresh the list
    ref.invalidate(allMemoriesProvider);

    if (mounted) Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _textController.addListener(() => setState(() {}));

    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    _lastViewInsetsBottom = view.viewInsets.bottom;
    WidgetsBinding.instance.addObserver(this);
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
    final bottom = WidgetsBinding
        .instance
        .platformDispatcher
        .views
        .first
        .viewInsets
        .bottom;

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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _confirmDiscard();
        if (shouldPop && context.mounted) Navigator.of(context).pop(result);
      },
      child: Scaffold(
        appBar: NewMemoryAppbar(
          hasContent: _hasContent,
          selectedDate: _selectedDate,
          hasImage: _pickedImage != null,
          onDateChanged: (newDate) => setState(() => _selectedDate = newDate),
          onSavePressed: _handleSavePressed,
          onImagePressed: _handleImagePressed,
          onVoicePressed: _placeholder,
          onTagsPressed: _placeholder,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _textFieldFocusNode.requestFocus,
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 8),
                    children: [
                      ImagePreview(
                        image: _pickedImage,
                        onLongPress: _handleImagePressed,
                        onRemove: _handleImageRemoved,
                      ),
                      NoteTextField(
                        controller: _textController,
                        focusNode: _textFieldFocusNode,
                      ),
                    ],
                  ),
                ),
              ),
              if (!_hasContent)
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
      ),
    );
  }
}
