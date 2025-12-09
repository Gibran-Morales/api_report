# Imagen base oficial de Dart
FROM dart:stable

# Crea carpeta dentro del contenedor
WORKDIR /app

# Copia pubspec primero para optimizar build
COPY pubspec.* ./

# Descarga dependencias
RUN dart pub get

# Copia todo el proyecto
COPY . .

# Compila a kernel JIT (no AOT porque es server)
RUN dart pub get

# Railway asignará PORT automáticamente
ENV PORT=8080

# Expone el puerto
EXPOSE 8080

# Comando de ejecución
CMD ["dart", "bin/api_report.dart"]
