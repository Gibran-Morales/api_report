# API UniTrack - Backend
Esta es una API REST desarrollada en Dart utilizando el framework **Shelf**, diseñada para gestionar actividades académicas (tareas, exámenes, proyectos, etc.).
La API permite **crear, consultar, actualizar y eliminar reportes**.
Además, está configurado para funcionar en Railway, incluyendo manejo de CORS y uso de variables de entorno para el puerto de despliegue.

#**Características principales**
  API REST creada con Shelf + Shelf Router.
  Endpoints CRUD: /reports.
  Middleware personalizado para manejo de CORS.
  Servidor preparado para despliegue en Railway usando PORT.
  Datos de ejemplo gestionados en memoria.
  Totalmente compatible con Flutter Web o App Móvil.

  Endpoints disponibles

#**Obtener todas las actividades**
**GET** `/reports`

#**Crear nueva actividad**
**POST** `/reports`

#**Actualizar actividad**
**PUT** /reports/{id}

#**Eliminar actividad**
**DELETE** /reports/{id}


Cómo ejecutar el proyecto localmente
1. Clonar este repositorio:
   git clone https://github.com/TU-USUARIO/api_report.git

Body JSON:
```json
{
  "materia": "Apps Moviles",
  "titulo": "Tarea 1",
  "descripcion": "Ejercicios 1–10",
  "fechaEntrega": "2025-12-10",
  "estado": "pendiente"
}


