import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';

class AdjustProfileTestPage extends StatefulWidget {
  final GoRouterState state;

  const AdjustProfileTestPage({super.key, required this.state});

  @override
  State<AdjustProfileTestPage> createState() => _AdjustProfileTestPageState();
}

class _AdjustProfileTestPageState extends State<AdjustProfileTestPage> {
  //*************************** State Variables *****************************//
  bool _showOverlay = true;

  // Captured transform data from adjust card
  double? _savedScale;
  double? _savedPanX;
  double? _savedPanY;

  // Key to access adjust card methods
  final GlobalKey _adjustCardKey = GlobalKey();

  //*************************** Helper Methods ******************************//
  void _hideOverlay() {
    print('🟢 _hideOverlay called! Setting showOverlay to false');
    setState(() {
      _showOverlay = false;
    });
  }

  void _onTransformChanged(double scale, double panX, double panY) {
    print('🎯 Transform data received: Scale=$scale, PanX=$panX, PanY=$panY');
    setState(() {
      _savedScale = scale;
      _savedPanX = panX;
      _savedPanY = panY;
    });
  }

  void _saveAdjustments() {
    print('💾 Save button pressed - capturing current adjustments...');

    // Extract image path for navigation
    final String? imagePath = widget.state.uri.queryParameters['imagePath'];

    // Trigger actual data capture from the component
    if (_adjustCardKey.currentState != null) {
      // This will trigger onTransformChanged callback with real data
      (_adjustCardKey.currentState as dynamic).captureCurrentAdjustments();

      // Navigate with captured data (if we have any)
      if (_savedScale != null && imagePath != null) {
        final String previewUrl =
            '/test/adjust-profile-preview?'
            'imagePath=${Uri.encodeComponent(imagePath)}&'
            'scale=$_savedScale&'
            'panX=$_savedPanX&'
            'panY=$_savedPanY';

        print('🚀 Navigating to: $previewUrl');
        context.push(previewUrl);
      } else {
        print('⚠️ No saved data yet - make some adjustments first!');
      }
    } else {
      print('❌ Could not access adjust card state');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract image path from URL parameters
    final String? imagePath = widget.state.uri.queryParameters['imagePath'];

    print('🟢 Building with showOverlay: $_showOverlay');

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SDeckTopNavigationBar.logoWithSkip(),

            SizedBox(height: SDeckSpace.gap16),

            // Debug information
            _buildDebugInfo(),

            SizedBox(height: SDeckSpace.gap16),

            // ADJUST MODE: User adjusts the image
            Center(
              child: SDeckAdjustProfileCard(
                key: _adjustCardKey,
                imagePath: imagePath,
                showOverlay: _showOverlay,
                hideOverlay: _hideOverlay,
                onTransformChanged: _onTransformChanged,
              ),
            ),

            SizedBox(height: SDeckSpace.gap24),

            // Save button only
            SDeckSolidButton(
              text: 'Save & View Result',
              size: SDeckButtonSize.large,
              onPressed: _saveAdjustments,
            ),
          ],
        ),
      ),
    );
  }

  //*************************** UI Helper Methods ********************************//
  Widget _buildDebugInfo() {
    return Container(
      padding: EdgeInsets.all(SDeckSpace.padding12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius8),
      ),
      child: Column(
        children: [
          Text('Debug Info:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: SDeckSpace.gap4),
          Text('Overlay visible: $_showOverlay'),
          if (_savedScale != null) ...[
            Text('Saved Scale: ${_savedScale!.toStringAsFixed(2)}x'),
            Text('Saved Pan X: ${_savedPanX!.toStringAsFixed(1)}px'),
            Text('Saved Pan Y: ${_savedPanY!.toStringAsFixed(1)}px'),
          ] else
            Text('No saved adjustments yet'),
        ],
      ),
    );
  }
}
