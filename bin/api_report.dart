import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

void main() async {
  final router = Router();

  router.get('/api', (Request request){
    return Response.ok('Hola Mundo');
  });

  final handler = const Pipeline()
    .addMiddleware(logRequests())
    .addHandler(router);

  await io.serve(handler, 'localhost', 8080);
  print('El servidor esta corriendo en el puerto 8080');
}