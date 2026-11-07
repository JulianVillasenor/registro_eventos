import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/estadisticas.dart';
import 'qr_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Estadisticas? estadisticas;
  bool cargando = true;
  String? error;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    setState(() {
      cargando = true;
      error = null;
    });

    try {
      final resultado = await ApiService.obtenerEstadisticas();

      if (!mounted) return;

      setState(() {
        estadisticas = resultado;
        cargando = false;
        error = null;
      });
    } catch (e) {
      debugPrint('ERROR AL CONSULTAR API: ${e.runtimeType}: $e');

      if (!mounted) return;

      setState(() {
        cargando = false;
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Control de acceso',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Evento de demostración',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Registrados',
                      //
                      value: cargando
                          ? '...'
                          : (estadisticas?.registrados ?? 0).toString(),
                      icon: Icons.people_alt_outlined,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StatCard(
                      title: 'Ingresaron',
                      value: cargando
                          ? '...'
                          : (estadisticas?.ingresaron ?? 0).toString(),
                      icon: Icons.check_circle_outline,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 160,
                child: FilledButton(
                  onPressed: () async {
                    final String? contenido = await Navigator.push<String>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QRScreen(),
                      ),
                    );

                    if (!context.mounted || contenido == null) return;

                    debugPrint('QR escaneado: $contenido');

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('QR leído: $contenido'),
                        duration: const Duration(seconds: 4),
                      ),
                    );
                  },

                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.qr_code_scanner,
                        size: 58,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'ESCANEAR QR',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 36),

              const Text(
                'Últimos accesos',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              const _AccessItem(
                name: 'Ana López',
                time: '18:42',
              ),
              const _AccessItem(
                name: 'Carlos Pérez',
                time: '18:40',
              ),
              const _AccessItem(
                name: 'María García',
                time: '18:37',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 30,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 18),
          Text(
            value,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccessItem extends StatelessWidget {
  final String name;
  final String time;

  const _AccessItem({
    required this.name,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            child: Icon(Icons.check),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}