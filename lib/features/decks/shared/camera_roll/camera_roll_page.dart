/*------------------------ camera_roll_page.dart -----------------------------*/
// Camera Roll page for Decks. Loads albums from the phone and lets the user
// select photos. The grid is mediaTarget cells. The shelf is cardSelectionShelf.
// Selected photos stay in this State until a backend exists.
//
// Usage: context.push(AppPaths.cameraRoll)
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  //*************************** Layout ****************************************//
  // Figma grid: 4 columns, 4px gaps. Photos load in pages as the user scrolls.
  static const int _columns = 4;
  static const int _pageSize = 60;

  //*************************** Loading ***************************************//
  bool _hasPhotoPermission = false;
  bool _isLoadingPhotos = true;
  bool _isLoadingMore = false;
  bool _hasMorePhotos = true;
  int _nextPage = 0;
  int _loadGeneration = 0;
  final ScrollController _gridController = ScrollController();

  //*************************** Albums & Grid *********************************//
  // Albums fill the shelf tabs. _photos is the album currently on screen.
  List<AssetPathEntity> _albums = [];
  int _selectedAlbumIndex = 0;
  List<AssetEntity> _photos = [];

  //*************************** Selection *************************************//
  // Order in this list is the order shown in the shelf.
  // Paths are filled a moment later, because the file is loaded async.
  // Thumbnails are cached so a tap does not reload the whole grid.
  final List<AssetEntity> _selected = [];
  final Map<String, String> _selectedPaths = {};
  final Map<String, Future<Uint8List?>> _thumbnails = {};

  bool get _canSave => _selected.isNotEmpty;

  //*************************** Lifecycle *************************************//
  @override
  void initState() {
    super.initState();
    _gridController.addListener(_onGridScroll);
    _ensurePhotoPermission();
  }

  @override
  void dispose() {
    _gridController.dispose();
    super.dispose();
  }

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(child: _buildBody(context)),
            if (_hasPhotoPermission && _albums.isNotEmpty) _buildShelf(),
          ],
        ),
      ),
    );
  }

  //------------------------------- Top Bar -----------------------------------//
  // Save stays gray until at least one photo is selected.
  Widget _buildTopBar() {
    return SDeckTopNavigationBar(
      left: SDeckTopBarLeft.back,
      type: SDeckTopBarType.subpage,
      right: SDeckTopBarRight.button,
      title: 'Camera Roll',
      rightButtonLabel: 'Save',
      rightButtonSize: SDeckButtonSize.small,
      onRightPressed: _canSave ? _onSavePressed : null,
    );
  }

  //------------------------------- Shelf -------------------------------------//
  // Tabs are the phone's albums. Items are the photos picked so far.
  Widget _buildShelf() {
    return SDeckCardSelectionShelf(
      tabs: _albums.map((album) => album.name).toList(),
      selectedTabIndex: _selectedAlbumIndex,
      onTabSelected: _selectAlbum,
      items: [
        for (final asset in _selected)
          SDeckCardListItem(
            imagePath: _selectedPaths[asset.id],
            onRemove: () => _togglePhoto(asset),
          ),
      ],
    );
  }

  //*************************** Body ******************************************//
  Widget _buildBody(BuildContext context) {
    if (_isLoadingPhotos) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_hasPhotoPermission) {
      return _buildPermissionPrompt(context);
    }

    if (_photos.isEmpty) {
      return Center(
        child: Text(
          'No photos found',
          style: Theme.of(context).textTheme.body,
        ),
      );
    }

    return _buildPhotoGrid();
  }

  Widget _buildPermissionPrompt(BuildContext context) {
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

  Widget _buildPhotoGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.margin16),
      child: GridView.builder(
        controller: _gridController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _columns,
          crossAxisSpacing: SDeckSpace.gap4,
          mainAxisSpacing: SDeckSpace.gap4,
        ),
        itemCount: _photos.length,
        itemBuilder: (context, index) {
          final photo = _photos[index];
          return _PhotoThumbnail(
            thumbnail: _thumbnailFor(photo),
            selected: _isSelected(photo),
            corner: _cornerFor(index, _photos.length),
            onTap: () => _togglePhoto(photo),
          );
        },
      ),
    );
  }

  //*************************** Selection *************************************//
  bool _isSelected(AssetEntity photo) {
    return _selected.any((asset) => asset.id == photo.id);
  }

  // Only the four outside corners of the grid are rounded.
  // A short last row has no bottom-right corner cell.
  SDeckMediaTargetCorner _cornerFor(int index, int count) {
    final isTop = index < _columns;
    final isBottom = index >= ((count - 1) ~/ _columns) * _columns;
    final column = index % _columns;
    final isLeft = column == 0;
    final isRight = column == _columns - 1;
    final lastRowIsFull = count % _columns == 0;

    if (isTop && isLeft) return SDeckMediaTargetCorner.topLeft;
    if (isTop && isRight) return SDeckMediaTargetCorner.topRight;
    if (isBottom && isLeft) return SDeckMediaTargetCorner.bottomLeft;
    if (isBottom && isRight && lastRowIsFull) {
      return SDeckMediaTargetCorner.bottomRight;
    }
    return SDeckMediaTargetCorner.none;
  }

  // Tap adds the photo immediately, then fills in its file path for the shelf.
  // The path check after the await skips a photo the user already removed.
  Future<void> _togglePhoto(AssetEntity photo) async {
    if (_isSelected(photo)) {
      setState(() {
        _selected.removeWhere((asset) => asset.id == photo.id);
        _selectedPaths.remove(photo.id);
      });
      return;
    }

    setState(() => _selected.add(photo));

    final file = await photo.file;
    if (!mounted || file == null || !_isSelected(photo)) return;

    setState(() => _selectedPaths[photo.id] = file.path);
  }

  // Pop the file paths, in shelf order, back to the screen that opened this page.
  Future<void> _onSavePressed() async {
    final paths = <String>[];
    for (final asset in _selected) {
      var path = _selectedPaths[asset.id];
      path ??= (await asset.file)?.path;
      if (path != null) paths.add(path);
    }
    if (!mounted) return;
    context.pop(paths);
  }

  //*************************** Photos ****************************************//
  // Reuse one thumbnail future per photo so selection rebuilds stay smooth.
  Future<Uint8List?> _thumbnailFor(AssetEntity photo) {
    return _thumbnails.putIfAbsent(
      photo.id,
      () => photo.thumbnailDataWithSize(const ThumbnailSize(300, 300)),
    );
  }

  // Ask for access, then load albums. Denied access stops here.
  Future<void> _ensurePhotoPermission() async {
    setState(() => _isLoadingPhotos = true);

    final pmResult = await PhotoManager.requestPermissionExtend();
    var granted = pmResult.isAuth;

    if (!granted) {
      final phStatus = await Permission.photos.request();
      granted = phStatus.isGranted;
    }

    if (!mounted) return;

    if (!granted) {
      setState(() {
        _hasPhotoPermission = false;
        _isLoadingPhotos = false;
      });
      return;
    }

    setState(() => _hasPhotoPermission = true);
    await _loadAlbums();
  }

  // Album names become the shelf tabs. The first album opens by default.
  Future<void> _loadAlbums() async {
    try {
      final albums = await PhotoManager.getAssetPathList(
        onlyAll: false,
        type: RequestType.image,
      );

      if (!mounted) return;

      if (albums.isEmpty) {
        setState(() {
          _albums = [];
          _photos = [];
          _isLoadingPhotos = false;
        });
        return;
      }

      setState(() {
        _albums = albums;
        _selectedAlbumIndex = 0;
      });
      await _loadAlbum(0);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _albums = [];
        _photos = [];
        _isLoadingPhotos = false;
      });
    }
  }

  // Switching albums reloads the grid. The selection list is left alone.
  Future<void> _selectAlbum(int index) async {
    if (index == _selectedAlbumIndex || index < 0 || index >= _albums.length) {
      return;
    }

    setState(() {
      _selectedAlbumIndex = index;
      _isLoadingPhotos = true;
    });
    await _loadAlbum(index);
  }

  // Start this album over at the first page, then keep paging while they scroll.
  Future<void> _loadAlbum(int index) async {
    final generation = ++_loadGeneration;
    setState(() {
      _photos = [];
      _nextPage = 0;
      _hasMorePhotos = true;
      _isLoadingMore = false;
      _isLoadingPhotos = true;
    });
    await _fetchPage(index, generation);
  }

  // Near the bottom of the grid, append the next page of this album.
  void _onGridScroll() {
    if (!_gridController.hasClients) return;
    if (_isLoadingMore || _isLoadingPhotos || !_hasMorePhotos) return;

    final position = _gridController.position;
    if (position.pixels >= position.maxScrollExtent - 480) {
      _loadMorePhotos();
    }
  }

  Future<void> _loadMorePhotos() async {
    if (_isLoadingMore || _isLoadingPhotos || !_hasMorePhotos) return;
    if (_albums.isEmpty) return;

    setState(() => _isLoadingMore = true);
    await _fetchPage(_selectedAlbumIndex, _loadGeneration);
  }

  Future<void> _fetchPage(int index, int generation) async {
    try {
      final page = await _albums[index].getAssetListPaged(
        page: _nextPage,
        size: _pageSize,
      );
      if (!mounted || generation != _loadGeneration) return;

      setState(() {
        _photos = [..._photos, ...page];
        _nextPage += 1;
        _hasMorePhotos = page.length == _pageSize;
        _isLoadingPhotos = false;
        _isLoadingMore = false;
      });

      // A short page may not scroll yet. Pull the next one until it does.
      WidgetsBinding.instance.addPostFrameCallback((_) => _onGridScroll());
    } catch (_) {
      if (!mounted || generation != _loadGeneration) return;
      setState(() {
        _isLoadingPhotos = false;
        _isLoadingMore = false;
        _hasMorePhotos = false;
      });
    }
  }
}

//------------------------------- Photo Thumbnail ---------------------------//
// One grid cell. Waits for the thumbnail, then draws a mediaTarget.
class _PhotoThumbnail extends StatelessWidget {
  final Future<Uint8List?> thumbnail;
  final bool selected;
  final SDeckMediaTargetCorner corner;
  final VoidCallback onTap;

  const _PhotoThumbnail({
    required this.thumbnail,
    required this.selected,
    required this.corner,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: thumbnail,
      builder: (context, snapshot) {
        final bytes = snapshot.data;
        return SDeckMediaTarget(
          image: bytes == null ? null : MemoryImage(bytes),
          selected: selected,
          corner: corner,
          onTap: onTap,
        );
      },
    );
  }
}
