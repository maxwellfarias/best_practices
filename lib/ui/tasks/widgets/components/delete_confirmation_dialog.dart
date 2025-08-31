import 'package:flutter/material.dart';
import 'delete_confirmation_dialog.dart';

class DeleteConfirmationScreen extends StatelessWidget {
  const DeleteConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // bg-slate-50
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: DeleteConfirmationDialog(
              taskTitle: "Sample Task",
              onCancel: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Deletion cancelled'),
                    backgroundColor: Color(0xFF6B7280),
                  ),
                );
              },
              onDelete: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Task deleted successfully'),
                    backgroundColor: Color(0xFFEF4444),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}


class DeleteConfirmationDialog extends StatefulWidget {
  final String? taskTitle;
  final VoidCallback? onCancel;
  final VoidCallback? onDelete;

  const DeleteConfirmationDialog({
    super.key,
    this.taskTitle,
    this.onCancel,
    this.onDelete,
  });

  @override
  State<DeleteConfirmationDialog> createState() => _DeleteConfirmationDialogState();
}

class _DeleteConfirmationDialogState extends State<DeleteConfirmationDialog> {
  bool _isCancelHovered = false;
  bool _isDeleteHovered = false;

  // Cores customizadas do tema
  static const Color primary50 = Color(0xFFF0FDF4);
  static const Color primary100 = Color(0xFFDCFCE7);
  static const Color primary200 = Color(0xFFBBF7D0);
  static const Color primary300 = Color(0xFF86EFAC);
  static const Color primary400 = Color(0xFF4ADE80);
  static const Color primary500 = Color(0xFF22C55E);
  static const Color primary600 = Color(0xFF16A34A);
  static const Color primary700 = Color(0xFF15803D);
  static const Color primary800 = Color(0xFF166534);
  static const Color primary900 = Color(0xFF14532D);
  static const Color primary950 = Color(0xFF052E16);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9), // bg-slate-50
          borderRadius: BorderRadius.circular(0),
        ),
        child: Center(
          child: _buildDialog(),
        ),
      ),
    );
  }

  Widget _buildDialog() {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth > 448 ? 448.0 : screenWidth * 0.9;

    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 25,
            offset: const Offset(0, 10),
            spreadRadius: -5,
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(),
          const SizedBox(height: 24),
          _buildTitle(),
          const SizedBox(height: 8),
          _buildDescription(),
          const SizedBox(height: 32),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2), // bg-red-100
        borderRadius: BorderRadius.circular(32),
      ),
      child: const Icon(
        Icons.delete_outline,
        color: Color(0xFFEF4444), // text-red-500
        size: 36,
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Confirm Deletion',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1F2937), // text-gray-800
        fontFamily: 'Spline Sans',
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription() {
    return Text(
      widget.taskTitle != null
          ? 'Are you sure you want to delete "${widget.taskTitle}"? This action cannot be undone.'
          : 'Are you sure you want to delete this task? This action cannot be undone.',
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xFF4B5563), // text-gray-600
        fontFamily: 'Spline Sans',
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildCancelButton(),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDeleteButton(),
        ),
      ],
    );
  }

  Widget _buildCancelButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isCancelHovered = true),
      onExit: (_) => setState(() => _isCancelHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 48,
        child: ElevatedButton(
          onPressed: () {
            if (widget.onCancel != null) {
              widget.onCancel!();
            } else {
              Navigator.of(context).pop(false);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _isCancelHovered 
                ? const Color(0xFFD1D5DB) // hover:bg-gray-300
                : const Color(0xFFE5E7EB), // bg-gray-200
            foregroundColor: const Color(0xFF1F2937), // text-gray-800
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Spline Sans',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isDeleteHovered = true),
      onExit: (_) => setState(() => _isDeleteHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 48,
        child: ElevatedButton(
          onPressed: () {
            if (widget.onDelete != null) {
              widget.onDelete!();
            } else {
              Navigator.of(context).pop(true);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _isDeleteHovered 
                ? const Color(0xFFDC2626) // hover:bg-red-600
                : const Color(0xFFEF4444), // bg-red-500
            foregroundColor: Colors.white,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: const Text(
            'Delete',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Spline Sans',
            ),
          ),
        ),
      ),
    );
  }
}

// Função utilitária para mostrar o dialog
Future<bool?> showDeleteConfirmationDialog(
  BuildContext context, {
  String? taskTitle,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (BuildContext context) {
      return DeleteConfirmationDialog(
        taskTitle: taskTitle,
      );
    },
  );
}