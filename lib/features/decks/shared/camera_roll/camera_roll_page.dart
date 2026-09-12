/*------------------------ camera_roll_page.dart -----------------------------*/
// Camera Roll page — shared photo picker for Decks.
// Step 1: load device photos and show them in a Figma-like 4-column grid.
// Selection / Save return value come later.
// No bottom nav — navigated to via context.push().
/*--------------------------------------------------------------------------*/

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:socialdeck/design_system/index.dart';

//------------------------------- CameraRollPage ----------------------------//
class CameraRollPage extends StatefulWidget {
  const CameraRollPage({super.key});

  @override
  State<CameraRollPage> createState() => _CameraRollPageState();
}

class _CameraRollPageState extends State<CameraRollPage> {
  //*************************** State *****************************************//
  bool _hasPhotoPermission = false;
  bool _isLoadingPhotos = true;
  List<AssetEntity> _photos = [];

  //*************************** Lifecycle *************************************//
  @override
  void initState() {
    super.initState();
    _ensurePhotoPermission();
  }

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation ------------------------//
            SDeckTopNavigationBar(
              left: SDeckTopBarLeft.back,
              type: SDeckTopBarType.subpage,
              right: SDeckTopBarRight.button,
              title: 'Camera Roll',
              rightButtonLabel: 'Save',
              rightButtonSize: SDeckButtonSize.small,
              // Disabled until selection is added
              onRightPressed: null,
            ),

            //------------------------ Photo Grid ----------------------------//
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  //*************************** Body ******************************************//
  Widget _buildBody(BuildContext context) {
    if (_isLoadingPhotos) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_hasPhotoPermission) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(SDeckSpace.margin16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Photo access is needed to show your camera roll.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.body,
              ),
              const SizedBox(height: SDeckSpace.gap16),
              SDeckSolidButton(
                text: 'Allow Photos',
                size: SDeckButtonSize.large,
                onPressed: _ensurePhotoPermission,
              ),
            ],
          ),
        ),
      );
    }

    if (_photos.isEmpty) {
      return Center(
        child: Text(
          'No photos found',
          style: Theme.of(context).textTheme.body,
        ),
      );
    }

    // Figma: margin16 around grid, 4px gaps, 4 columns, outer corners rounded
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        SDeckSpace.margin16,
        0,
        SDeckSpace.margin16,
        SDeckSpace.margin16,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: _photos.length,
          itemBuilder: (context, index) {
            return _PhotoThumbnail(entity: _photos[index]);
          },
        ),
      ),
    );
  }

  //*************************** Permissions & Photos **************************//
  Future<void> _ensurePhotoPermission() async {
    setState(() => _isLoadingPhotos = true);

    final pmResult = await PhotoManager.requestPermissionExtend();
    final grantedByPM = pmResult.isAuth;

    if (!grantedByPM) {
      final phStatus = await Permission.photos.request();
      if (!phStatus.isGranted) {
        setState(() {
          _hasPhotoPermission = false;
          _isLoadingPhotos = false;
        });
        return;
      }
    }

    setState(() => _hasPhotoPermission = true);
    await _loadFirstPage();
  }

  Future<void> _loadFirstPage() async {
    try {
      final albums = await PhotoManager.getAssetPathList(
        onlyAll: false,
        type: RequestType.image,
      );

      if (albums.isEmpty) {
        setState(() {
          _photos = [];
          _isLoadingPhotos = false;
        });
        return;
      }

      // Default to first album (typically Recents)
      const pageSize = 60;
      final firstPage = await albums.first.getAssetListPaged(
        page: 0,
        size: pageSize,
      );

      setState(() {
        _photos = firstPage;
        _isLoadingPhotos = false;
      });
    } catch (_) {
      setState(() {
        _photos = [];
        _isLoadingPhotos = false;
      });
    }
  }
}

//------------------------------- Photo Thumbnail ---------------------------//
class _PhotoThumbnail extends StatelessWidget {
  final AssetEntity entity;

  const _PhotoThumbnail({required this.entity});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: entity.thumbnailDataWithSize(const ThumbnailSize(300, 300)),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Image.memory(
            snapshot.data!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          );
        }
        return ColoredBox(color: context.component.selectionTargetSurface);
      },
    );
  }
}
