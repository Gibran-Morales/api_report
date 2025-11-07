import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

void main() async {
  final router = Router();

  final reports = [
    {
      'user': 'Mary Jane',
      'location': 'Downtown',
      'image': '🌆',
      'description': 'Banqueta mal construida',
      'time': 'Hace 30 minutos',
    },
    {
      'user': 'Ricky Martin',
      'location': 'Central Park',
      'image': '🌳',
      'description': 'Falta ciclovia',
      'time': 'Hace 1 hora',
    },
    {
      'user': 'Jose Maria',
      'location': 'Calle de atrás',
      'image': '🚧',
      'description': 'Necesita nueva pavimentación',
      'time': 'Hace 2 horas',
    },
    {
      'user': 'Pepé Moncho',
      'location': '4 molinos',
      'image': '🚦',
      'description': 'Falta de 4 altos',
      'time': 'Hace 22 minutos',
    },
  ];

  final users = [
    {"name": "Hernán", "edad": 25, "número de telefono": "6121234567"},
    {"name": "Ricardo", "edad": 20, "número de telefono": "6123456789"}
  ];

  // Endpoints
  router.get('/hello', (Request request) {
    return Response.ok('Hola Mundo');
  });

  router.get('/reports', (Request request) {
    return Response.ok(jsonEncode(reports),
        headers: {'Content-Type': 'application/json'});
  });

  router.get('/users', (Request request) {
    return Response.ok(jsonEncode(users),
        headers: {'Content-Type': 'application/json'});
  });

  final handler =
      const Pipeline().addMiddleware(logRequests()).addHandler(router);

  await io.serve(handler, 'localhost', 8080);
  print('Servidor corriendo en el puerto 8080');
} 