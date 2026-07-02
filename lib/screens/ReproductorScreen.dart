import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ReproductorScreen extends StatefulWidget {
  final dynamic pelicula;

  const ReproductorScreen({super.key, required this.pelicula});

  @override
  State<ReproductorScreen> createState() => _ReproductorScreenState();
}

class _ReproductorScreenState extends State<ReproductorScreen> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  bool _isError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _inicializarReproductor();
  }

  void _inicializarReproductor() {
    try {
      final videoUrl = widget.pelicula['video_url'] ?? '';
      
      if (videoUrl.isEmpty) {
        setState(() {
          _isLoading = false;
          _isError = true;
          _errorMessage = 'No hay video disponible para esta pelicula';
        });
        return;
      }

      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
      );

      _videoController.initialize().then((_) {
        _chewieController = ChewieController(
          videoPlayerController: _videoController,
          autoPlay: true,
          looping: false,
          showControls: true,
          materialProgressColors: ChewieProgressColors(
            playedColor: Colors.red,
            handleColor: Colors.red,
            backgroundColor: Colors.grey,
            bufferedColor: Colors.grey.shade600,
          ),
          placeholder: Container(
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
          ),
          allowFullScreen: true,
          allowMuting: true,
          allowPlaybackSpeedChanging: true,
          showOptions: true,
        );

        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          _isLoading = false;
          _isError = true;
          _errorMessage = 'Error al cargar el video: $error';
        });
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isError = true;
        _errorMessage = 'Error al inicializar el reproductor: $e';
      });
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.pelicula['name'] ?? 'Reproduciendo',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.fullscreen, color: Colors.white),
            onPressed: () {
              _chewieController?.enterFullScreen();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Cargando video...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            )
          : _isError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          'Volver',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              : Chewie(
                  controller: _chewieController!,
                ),
    );
  }
}