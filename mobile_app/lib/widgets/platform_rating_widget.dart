import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme.dart';
import 'package:mobile_app/services/api_service.dart';
import 'package:provider/provider.dart';

class PlatformRatingWidget extends StatefulWidget {
  final VoidCallback? onClose;
  const PlatformRatingWidget({super.key, this.onClose});

  @override
  State<PlatformRatingWidget> createState() => _PlatformRatingWidgetState();
}

class _PlatformRatingWidgetState extends State<PlatformRatingWidget> {
  int _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  bool _submitting = false;

  void _submit() async {
    if (_rating == 0) return;
    setState(() => _submitting = true);
    try {
      await context.read<ApiService>().submitPlatformRating(_rating, _feedbackController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thank you for your feedback!')),
        );
        setState(() {
          _rating = 0;
          _feedbackController.clear();
          _submitting = false;
        });
        if (widget.onClose != null) {
          widget.onClose!();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit: $e')),
        );
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 0,
        color: AppTheme.primaryColor.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.primaryColor, width: 0.5),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rate the platform',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                  ),
                  const SizedBox(height: 8),
                  const Text('How is your experience with QuickServe so far?'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                        onPressed: () => setState(() => _rating = index + 1),
                      );
                    }),
                  ),
                  if (_rating > 0) ...[
                    const SizedBox(height: 16),
                    TextField(
                      controller: _feedbackController,
                      decoration: const InputDecoration(
                        hintText: 'Any specific feedback? (Optional)',
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitting ? null : _submit,
                        child: _submitting
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Submit Feedback'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (widget.onClose != null)
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: widget.onClose,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
