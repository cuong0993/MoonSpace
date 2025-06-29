import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:example/carousel/carouselmain.dart';
import 'package:example/l10n/app_localizations.dart';
import 'package:example/main.dart';
import 'package:example/pages/manager.dart';
import 'package:example/pages/music.dart';
import 'package:example/pages/quiz.dart';
import 'package:example/pages/recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:widgetbook/widgetbook.dart';

import 'package:path_provider/path_provider.dart';

import 'package:device_frame_plus/device_frame_plus.dart';

class DeviceFrameAddon extends WidgetbookAddon<DeviceFrameSetting> {
  DeviceFrameAddon({
    required List<DeviceInfo> devices,
    this.initialDevice = NoneDevice.instance,
  }) : assert(devices.isNotEmpty, 'devices cannot be empty'),
       assert(
         initialDevice == NoneDevice.instance ||
             devices.contains(initialDevice),
         'initialDevice must be in devices',
       ),
       this.devices = [NoneDevice.instance, ...devices],
       super(name: 'Device');

  final DeviceInfo initialDevice;
  final List<DeviceInfo> devices;

  @override
  List<Field> get fields {
    return [
      ListField<DeviceInfo>(
        name: 'name',
        values: devices,
        initialValue: initialDevice,
        labelBuilder: (device) => device.name,
      ),
      ListField<Orientation>(
        name: 'orientation',
        values: Orientation.values,
        initialValue: Orientation.portrait,
        labelBuilder: (orientation) =>
            orientation.name.substring(0, 1).toUpperCase() +
            orientation.name.substring(1),
      ),
      ListField<bool>(
        name: 'frame',
        values: [false, true],
        initialValue: true,
        labelBuilder: (hasFrame) => hasFrame ? 'Device Frame' : 'None',
      ),
    ];
  }

  @override
  DeviceFrameSetting valueFromQueryGroup(Map<String, String> group) {
    return DeviceFrameSetting(
      device: valueOf('name', group)!,
      orientation: valueOf('orientation', group)!,
      hasFrame: valueOf('frame', group)!,
    );
  }

  final GlobalKey _globalKey = GlobalKey();

  Future<void> _capturePng() async {
    try {
      // Find the RenderObject from the global key
      RenderRepaintBoundary boundary =
          _globalKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;

      // Capture the image
      ui.Image image = await boundary.toImage(pixelRatio: 4.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Save the file
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/${DateTime.now()}.png';
      final file = File(path);
      await file.writeAsBytes(pngBytes);

      print('Saved to $path');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget buildUseCase(
    BuildContext context,
    Widget child,
    DeviceFrameSetting setting,
  ) {
    if (setting.device is NoneDevice) {
      return child;
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Center(
              child: RepaintBoundary(
                key: _globalKey,
                child: DeviceFrame(
                  orientation: setting.orientation,
                  device: setting.device,
                  isFrameVisible: setting.hasFrame,
                  screen: Navigator(
                    onGenerateRoute: (_) => PageRouteBuilder(
                      pageBuilder: (context, _, __) =>
                          setting.hasFrame ? child : SafeArea(child: child),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: _capturePng,
              icon: Icon(Icons.camera),
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}

class MyWidgetbook extends StatelessWidget {
  const MyWidgetbook({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Widgetbook.material(
        themeMode: Theme.of(context).brightness == Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light,
        addons: [
          // BuilderAddon(
          //   name: 'Accessibility',
          //   builder: (context, child) => AccessibilityTools(child: child),
          // ),
          DeviceFrameAddon(
            devices: [
              Devices.android.samsungGalaxyS20,
              Devices.ios.iPad12InchesGen4,
              Devices.ios.iPhone14Pro,
              Devices.ios.iPhone13Mini,
            ],
          ),
          SemanticsAddon(),
          MaterialThemeAddon(
            themes: [WidgetbookTheme(name: "Theme", data: Theme.of(context))],
          ),
          LocalizationAddon(
            locales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
          ),
        ],
        directories: [
          WidgetbookCategory(
            name: 'Components',
            children: [
              WidgetbookComponent(
                name: "Images",
                useCases: [
                  WidgetbookUseCase(
                    name: "Images",
                    builder: (context) => ImageGridApp(),
                  ),
                ],
              ),
              WidgetbookComponent(
                name: 'Pages',
                useCases: [
                  WidgetbookUseCase(name: 'Home', builder: (context) => Home()),
                  WidgetbookUseCase(name: 'Quiz', builder: (context) => Quiz()),
                  WidgetbookUseCase(
                    name: 'Manager',
                    builder: (context) => ManagerApp(),
                  ),
                  WidgetbookUseCase(
                    name: 'Recipe',
                    builder: (context) => RecipeApp(),
                  ),
                  WidgetbookUseCase(
                    name: 'MusicApp',
                    builder: (context) => MusicApp(),
                  ),
                  WidgetbookUseCase(
                    name: 'ColorScheme',
                    builder: (context) => ColorSchemeExample(),
                  ),
                  WidgetbookUseCase(
                    name: 'Carousel',
                    builder: (context) => Carouselmain(),
                  ),
                  WidgetbookUseCase(
                    name: 'First',
                    builder: (context) =>
                        Scaffold(body: ListView(children: first(context))),
                  ),
                  WidgetbookUseCase(
                    name: 'Second',
                    builder: (context) =>
                        Scaffold(body: ListView(children: second(context))),
                  ),
                  WidgetbookUseCase(
                    name: 'Third',
                    builder: (context) =>
                        Scaffold(body: ListView(children: third(context))),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ImageGridApp extends StatelessWidget {
  const ImageGridApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ImageGridScreen());
  }
}

class ImageGridScreen extends StatefulWidget {
  const ImageGridScreen({super.key});

  @override
  State<ImageGridScreen> createState() => _ImageGridScreenState();
}

class _ImageGridScreenState extends State<ImageGridScreen> {
  List<File> imageFiles = [];
  Set<int> selectedIndexes = {};

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Future<void> loadImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync();

    final images =
        files
            .whereType<File>()
            .where(
              (file) =>
                  file.path.toLowerCase().endsWith('.png') ||
                  file.path.toLowerCase().endsWith('.jpg') ||
                  file.path.toLowerCase().endsWith('.jpeg'),
            )
            .toList()
          ..sort(
            (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
          );

    setState(() {
      imageFiles = images;
      selectedIndexes = Set.from(List.generate(files.length, (i) => i));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Screenshots')),
      body: imageFiles.isEmpty
          ? const Center(child: Text('No images found.'))
          : Stack(
              children: [
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.5,
                  ),
                  itemCount: imageFiles.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedIndexes.contains(index);
                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            print("hello $index $selectedIndexes");
                            setState(() {
                              if (!selectedIndexes.contains(index)) {
                                selectedIndexes.add(index);
                              } else {
                                selectedIndexes.remove(index);
                              }
                            });
                          },
                          child: Opacity(
                            opacity: isSelected ? 1.0 : 0.3,
                            child: Image.file(
                              imageFiles[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              size: 20,
                              color: ui.Color.fromARGB(255, 255, 86, 86),
                            ),
                            onPressed: () {
                              setState(() {
                                imageFiles[index].deleteSync();
                                imageFiles.removeAt(index);
                                selectedIndexes.remove(index);

                                // Rebuild indexes
                                selectedIndexes = selectedIndexes
                                    .map((i) => i > index ? i - 1 : i)
                                    .toSet();
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),

                // Screenshot trigger button
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: () async {
                      final selectedFiles = selectedIndexes
                          .map((i) => imageFiles[i])
                          .toList();
                      if (selectedFiles.isNotEmpty) {
                        await createUniformHeightGrid(
                          imageFiles: selectedFiles,
                          xCount: 3,
                          targetHeight: 3000,
                          xPad: 16,
                          yPad: 24,
                        );
                        // await createGridImageFromFiles(selectedFiles, 3);
                      }
                    },
                    child: const Icon(Icons.camera_alt),
                  ),
                ),
              ],
            ),
    );
  }
}

class GridImage {
  final ui.Image image;
  final double width;
  final double height;

  GridImage(this.image)
    : width = image.width.toDouble(),
      height = image.height.toDouble();
}

Future<void> createGridImageFromFiles(
  List<File> imageFiles,
  int columns,
) async {
  const spacing = 16.0;

  // Load all images and get their sizes
  final images = <GridImage>[];
  for (final file in imageFiles) {
    final bytes = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    images.add(GridImage(frame.image));
  }

  // Calculate max width per column and row heights
  final columnWidths = List.filled(columns, 0.0);
  final rowHeights = <double>[];

  for (int i = 0; i < images.length; i++) {
    final col = i % columns;
    final row = i ~/ columns;

    if (rowHeights.length <= row) {
      rowHeights.add(0.0);
    }

    columnWidths[col] = math.max(columnWidths[col], images[i].width);
    rowHeights[row] = math.max(rowHeights[row], images[i].height);
  }

  final totalWidth =
      columnWidths.reduce((a, b) => a + b) + spacing * (columns + 1);
  final totalHeight =
      rowHeights.reduce((a, b) => a + b) + spacing * (rowHeights.length + 1);

  // Begin drawing
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final paint = Paint();

  double y = spacing;

  for (int row = 0; row < rowHeights.length; row++) {
    double x = spacing;

    for (int col = 0; col < columns; col++) {
      int i = row * columns + col;
      if (i >= images.length) break;

      final gridImage = images[i];
      canvas.drawImage(gridImage.image, Offset(x, y), paint);
      x += columnWidths[col] + spacing;
    }

    y += rowHeights[row] + spacing;
  }

  final picture = recorder.endRecording();
  final image = await picture.toImage(totalWidth.toInt(), totalHeight.toInt());

  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final pngBytes = byteData!.buffer.asUint8List();

  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/grid_dynamic.png');
  await file.writeAsBytes(pngBytes);

  log('✅ Image saved: ${file.path}');
}

Future<void> createUniformHeightGrid({
  required List<File> imageFiles,
  int xCount = 3,
  double targetHeight = 200.0,
  double xPad = 16.0,
  double yPad = 16.0,
}) async {
  // Step 1: Load all images
  final loadedImages = <ui.Image>[];
  final widths = <double>[];

  for (final file in imageFiles) {
    final bytes = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    final aspectRatio = image.width / image.height;
    final scaledWidth = targetHeight * aspectRatio;

    loadedImages.add(image);
    widths.add(scaledWidth);
  }

  // Step 2: Layout calculations
  final int totalImages = loadedImages.length;
  final int yCount = (totalImages / xCount).ceil();

  final rowWidths = List.generate(yCount, (_) => 0.0);
  final rowMaxHeights = List.filled(yCount, targetHeight);

  int index = 0;
  for (int row = 0; row < yCount; row++) {
    for (int col = 0; col < xCount; col++) {
      if (index >= totalImages) break;
      rowWidths[row] += widths[index] + xPad;
      index++;
    }
    rowWidths[row] -= xPad; // Remove last xPad for trailing image
  }

  final canvasWidth = rowWidths.reduce((a, b) => a > b ? a : b);
  final canvasHeight = yCount * targetHeight + (yCount - 1) * yPad;

  // Step 3: Draw
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final paint = Paint();

  double y = 0;
  index = 0;

  for (int row = 0; row < yCount; row++) {
    double x = 0;
    for (int col = 0; col < xCount; col++) {
      if (index >= totalImages) break;
      final image = loadedImages[index];
      final width = widths[index];

      final srcRect = Rect.fromLTWH(
        0,
        0,
        image.width.toDouble(),
        image.height.toDouble(),
      );
      final dstRect = Rect.fromLTWH(x, y, width, targetHeight);

      canvas.drawImageRect(image, srcRect, dstRect, paint);

      x += width + xPad;
      index++;
    }
    y += targetHeight + yPad;
  }

  final picture = recorder.endRecording();
  final finalImage = await picture.toImage(
    canvasWidth.toInt(),
    canvasHeight.toInt(),
  );
  final byteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);
  final pngBytes = byteData!.buffer.asUint8List();

  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/grid_uniform_height.png');
  await file.writeAsBytes(pngBytes);

  print('✅ Grid saved to ${file.path}');
}
