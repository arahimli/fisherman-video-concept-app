import 'dart:io';
import 'package:fisherman_video/video_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'services/image_service.dart';
import 'services/video_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? imageFile;
  String? videoPath;
  bool loading = false;
  String loadingMessage = '';

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
        videoPath = null; // Reset video when new image is picked
      });
    }
  }

  Future<void> generateVideo() async {
    if (imageFile == null) return;

    setState(() {
      loading = true;
      loadingMessage = 'Şəkil emal olunur...';
    });

    try {
      final images = await ImageService.processImage(imageFile!);

      setState(() {
        loadingMessage = 'Video yaradılır...';
      });

      final videoFile = await VideoService.generateVideo(images);

      setState(() {
        loading = false;
        videoPath = videoFile;
        loadingMessage = '';
      });

      if (videoFile != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Video hazırlandı ✓")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Video yaradılarkən xəta baş verdi")),
        );
      }
    } catch (e) {
      setState(() {
        loading = false;
        loadingMessage = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Xəta: $e")),
      );
    }
  }

  void showVideoPreview() {
    if (videoPath == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(videoPath: videoPath!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Yaradıcı"),
        centerTitle: true,
      ),
      body: Center(
        child: loading
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              loadingMessage,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        )
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (imageFile != null)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(imageFile!, height: 300),
                    ),
                  ),
                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text("Şəkil seç"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                ElevatedButton.icon(
                  onPressed: imageFile == null ? null : generateVideo,
                  icon: const Icon(Icons.video_call),
                  label: const Text("Video yarat"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),

                if (videoPath != null) ...[
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),

                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Video hazırdır!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: showVideoPreview,
                    icon: const Icon(Icons.play_circle_fill),
                    label: const Text("Videoya bax"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
