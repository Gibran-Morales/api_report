# Usa imagen oficial de Dart
FROM dart:stable AS build

WORKDIR /app

# Copia archivos
COPY pubspec.* ./
RUN dart pub get

COPY . .

RUN dart pub get --offline

# Compila a ejecutable nativo
RUN dart compile exe bin/api_report.dart -o /server

# Imagen final ligera
FROM debian:stable-slim

WORKDIR /app

COPY --from=build /server /app/server

# Railway asigna el puerto en la variable PORT
ENV PORT=8081

EXPOSE 8081

CMD ["/app/server"]
