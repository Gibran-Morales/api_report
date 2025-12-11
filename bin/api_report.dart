import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

final List<Map<String, dynamic>> reports = [
  {
    'id': 1,
    'materia': 'Cálculo I',
    'titulo': 'Tarea',
    'descripcion': 'Ejercicios 1–10 pág. 52',
    'fechaEntrega': '10-12-2025',
    'estado': 'pendiente',
  },
  {
    'id': 2,
    'materia': 'Programación',
    'titulo': 'Examen',
    'descripcion': 'Parcial 2',
    'fechaEntrega': '12-12-2025',
    'estado': 'pendiente',
  },
];

void main() async {
  final router = Router()
    ..get('/reports', _getReportsHandler)
    ..post('/reports', _addReportsHandler)
    ..put('/reports/<id>', _updateReportHandler)   
    ..delete('/reports/<id>', _deleteReportHandler);

  final handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addMiddleware(_corsMiddleware)
      .addHandler(router);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  final server = await io.serve(handler, InternetAddress.anyIPv4, port);
  print('Servidor escuchando en http://${server.address.host}:${server.port}');
}


shelf.Response _getReportsHandler(shelf.Request request) {
  return shelf.Response.ok(
    jsonEncode(reports),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<shelf.Response> _addReportsHandler(shelf.Request request) async {
  final body = await request.readAsString();
  final data = jsonDecode(body) as Map<String, dynamic>;

  final newReport = {
    'id': reports.length + 1,
    'materia': data['materia'],
    'titulo': data['titulo'],
    'descripcion': data['descripcion'],
    'fechaEntrega': data['fechaEntrega'],
    'estado': 'pendiente',
  };

  reports.add(newReport);

  return shelf.Response.ok(
    jsonEncode(newReport),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<shelf.Response> _deleteReportHandler(shelf.Request request) async {
  final idStr = request.params['id'];
  final id = int.tryParse(idStr ?? '');

  if (id == null) {
    return shelf.Response(400, body: 'ID inválido');
  }

  final index = reports.indexWhere((r) => r['id'] == id);
  if (index == -1) {
    return shelf.Response(404, body: 'Reporte no encontrado');
  }

  reports.removeAt(index);

  return shelf.Response.ok(
    jsonEncode({'message': 'deleted', 'id': id}),
    headers: {'Content-Type': 'application/json'},
  );
}


shelf.Middleware get _corsMiddleware {
  return (innerHandler) {
    return (request) async {
      const corsHeaders = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Origin, Content-Type',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      };

      if (request.method == 'OPTIONS'){
        return shelf.Response.ok('', headers: corsHeaders);
      }

      final response = await innerHandler(request);
      return response.change(headers: { 
        ...response.headers,
        ...corsHeaders,
      });
    };
  };
}

  Future<shelf.Response> _updateReportHandler(
  shelf.Request request,
  String id,
) async {
  final body = await request.readAsString();
  final data = jsonDecode(body) as Map<String, dynamic>;
  final reportId = int.parse(id);

  final index = reports.indexWhere((r) => r['id'] == reportId);
  if (index == -1) {
    return shelf.Response.notFound(
      jsonEncode({'error': 'Reporte no encontrado'}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  reports[index] = {
    'id': reportId,
    'materia': data['materia'],
    'titulo': data['titulo'],
    'descripcion': data['descripcion'],
    'fechaEntrega': data['fechaEntrega'],
    'estado': data['estado'] ?? reports[index]['estado'],
  };

  return shelf.Response.ok(
    jsonEncode(reports[index]),
    headers: {'Content-Type': 'application/json'},
  );
}




