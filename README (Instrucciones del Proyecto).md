# 🏢 CRM Premier Offshore Solutions

![Estado](https://img.shields.io/badge/Estado-En%20Desarrollo-yellow)
![Licencia](https://img.shields.io/badge/Licencia-MIT-green)
![Base%20de%20Datos](https://img.shields.io/badge/BD-MySQL-blue)
![Framework](https://img.shields.io/badge/Backend-Django%20REST-092E20)
![Frontend](https://img.shields.io/badge/Frontend-Vue.js%203-42b883)

Sistema de Gestión de Clientes (CRM) desarrollado para **Premier Offshore Solutions**, empresa dominicana de servicios de contact center bilingüe (español–inglés). Proyecto académico desarrollado en la asignatura **Desarrollo de Proyectos con Software Libre** — Universidad Abierta para Adultos (UAPA).

---

## 📋 Tabla de Contenidos

- [Descripción](#descripción)
- [Funcionalidades](#funcionalidades)
- [Stack Tecnológico](#stack-tecnológico)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Instalación y Configuración](#instalación-y-configuración)
- [Base de Datos](#base-de-datos)
- [Uso del Sistema](#uso-del-sistema)
- [Equipo](#equipo)

---

## 📌 Descripción

**Premier Offshore Solutions** requería una herramienta centralizada para gestionar sus clientes empresariales, automatizar el seguimiento de interacciones comerciales y generar reportes de rendimiento para su equipo de agentes. Este CRM cubre ese objetivo mediante una aplicación web completa, ligera y de código abierto.

### Objetivos del sistema

- Centralizar la información de clientes y prospectos en una sola plataforma.
- Registrar el historial de interacciones (llamadas, correos, chats) por cliente.
- Gestionar el pipeline de ventas por etapas (Prospecto → Cerrado).
- Asignar y monitorear tareas entre agentes y supervisores.
- Generar reportes y dashboards con KPIs en tiempo real.
- Controlar el acceso mediante roles diferenciados.

---

## ✅ Funcionalidades

| Módulo | Descripción | RF |
|---|---|---|
| **Gestión de Contactos** | CRUD completo de clientes y prospectos con filtros por nombre, empresa y estado | RF-01, RF-02 |
| **Importación CSV** | Importar contactos masivamente desde archivos CSV/Excel | RF-03 |
| **Seguimiento de Interacciones** | Registro de llamadas, correos y chats con historial por cliente | RF-04, RF-05 |
| **Pipeline de Ventas** | Tablero Kanban con etapas: Prospecto, Contactado, Propuesta, Negociación, Cerrado | RF-06, RF-07 |
| **Gestión de Tareas** | Creación, asignación y seguimiento de tareas con prioridad y fecha límite | RF-08 |
| **Notificaciones** | Alertas automáticas por correo al vencer el plazo de una tarea | RF-09 |
| **Reportes** | Reportes de actividad diaria, semanal y mensual por agente | RF-10 |
| **Dashboard KPIs** | Panel con tasa de conversión, contactos nuevos y tareas pendientes | RF-11 |
| **Control de Acceso** | Tres roles: Agente (cartera propia), Supervisor (equipo), Administrador (total) | RF-12 |
| **Auditoría** | Log de acciones críticas con valor anterior/nuevo e IP de origen | RF-13 |

---

## 🛠️ Stack Tecnológico

> Todas las tecnologías utilizadas son **software libre u open source** (RNF-10).

| Capa | Tecnología | Licencia |
|---|---|---|
| Frontend | Vue.js 3 + Tailwind CSS | MIT |
| Backend | Python 3.11 + Django REST Framework | MIT / BSD |
| Base de Datos | MySQL 8.0 | GPL v2 |
| Autenticación | JWT (djangorestframework-simplejwt) | MIT |
| Servidor Web | Nginx + Gunicorn | BSD / MIT |
| Contenedores | Docker + Docker Compose | Apache 2.0 |
| Control de Versiones | Git + GitHub | MIT |
| Gestión del Proyecto | GanttProject | GPL v3 |

---

## 📁 Estructura del Proyecto

```
crm-premier-offshore/
│
├── backend/                        # API REST con Django
│   ├── crm/                        # App principal
│   │   ├── models.py               # Modelos: Contacto, Interacción, Tarea, etc.
│   │   ├── serializers.py          # Serialización de datos (DRF)
│   │   ├── views.py                # Lógica de negocio y endpoints
│   │   ├── urls.py                 # Rutas de la API
│   │   └── admin.py                # Panel de administración Django
│   ├── manage.py
│   └── requirements.txt            # Dependencias Python
│
├── frontend/                       # SPA con Vue.js 3
│   ├── src/
│   │   ├── views/                  # Páginas: Contactos, Pipeline, Tareas, etc.
│   │   ├── components/             # Componentes reutilizables
│   │   ├── router/                 # Vue Router
│   │   └── store/                  # Pinia (estado global)
│   └── package.json
│
├── database/
│   └── CRM_PremierOffshore_DB.sql  # Script SQL completo (tablas + datos de prueba)
│
├── docker-compose.yml              # Orquestación de servicios
├── nginx.conf                      # Configuración del servidor web
└── README.md
```

---

## ⚙️ Instalación y Configuración

### Prerrequisitos

- [Docker](https://www.docker.com/) y Docker Compose instalados
- Git instalado

### Pasos

**1. Clonar el repositorio**

```bash
git clone https://github.com/tu-usuario/crm-premier-offshore.git
cd crm-premier-offshore
```

**2. Configurar variables de entorno**

```bash
cp .env.example .env
# Editar .env con tus valores (ver sección de variables abajo)
```

**3. Levantar los servicios con Docker**

```bash
docker-compose up --build
```

**4. Aplicar migraciones y cargar datos de prueba**

```bash
docker-compose exec backend python manage.py migrate
docker-compose exec backend python manage.py loaddata initial_data.json
```

**5. Acceder al sistema**

| Servicio | URL |
|---|---|
| Frontend (Vue.js) | http://localhost:8080 |
| API REST (Django) | http://localhost:8000/api/ |
| Panel Admin Django | http://localhost:8000/admin/ |

---

### Variables de Entorno (`.env`)

```env
# Base de datos
DB_NAME=CRM_PremierOffshore
DB_USER=crm_user
DB_PASSWORD=tu_password_seguro
DB_HOST=db
DB_PORT=3306

# Django
SECRET_KEY=tu_clave_secreta_django
DEBUG=False
ALLOWED_HOSTS=localhost,127.0.0.1

# JWT
JWT_ACCESS_TOKEN_LIFETIME=60   # minutos
JWT_REFRESH_TOKEN_LIFETIME=7   # días
```

---

## 🗄️ Base de Datos

El esquema está definido en `database/CRM_PremierOffshore_DB.sql` e incluye:

### Tablas principales

```
Roles               → Tipos de usuario (Agente, Supervisor, Administrador)
Usuarios            → Cuentas del sistema con hash bcrypt
Contactos           → Clientes y prospectos con índices de búsqueda
Interacciones       → Historial de llamadas, correos y chats
Oportunidades       → Pipeline de ventas con etapa y probabilidad %
Tareas              → Actividades asignadas con prioridad y notificaciones
Log_Auditoria       → Registro de acciones críticas con trazabilidad completa
```

### Vistas incluidas

```sql
vista_contactos_por_agente   → KPI: contactos activos por agente
vista_pipeline_por_etapa     → KPI: valor del pipeline por etapa
vista_tareas_urgentes        → Tareas vencidas o próximas a vencer
```

### Cargar la base de datos manualmente

```bash
mysql -u root -p < database/CRM_PremierOffshore_DB.sql
```

---

## 🖥️ Uso del Sistema

### Credenciales de prueba

| Usuario | Correo | Rol |
|---|---|---|
| Marcos Valdez | mvaldez@premieroffshore.com | Administrador |
| Daniela Rosario | drosario@premieroffshore.com | Supervisor |
| Javier Castillo | jcastillo@premieroffshore.com | Agente |
| Sofia Reyes | sreyes@premieroffshore.com | Agente |

> ⚠️ **Nota:** Las contraseñas de prueba se configuran al ejecutar `loaddata`. Cambiarlas antes de pasar a producción.

### Flujo básico del sistema

```
1. Login  →  Dashboard con KPIs
2. Crear Contacto  →  Asignar a agente
3. Registrar Interacción  →  Ver historial del contacto
4. Crear Oportunidad  →  Mover en el pipeline Kanban
5. Asignar Tarea  →  Notificación automática al vencer
6. Ver Reportes  →  Exportar actividad del período
```

---

## 👥 Equipo

| Nombre | Rol en el Proyecto | Universidad |
|---|---|---|
| Erasmo | Desarrollador Full-Stack | UAPA |

**Empresa cliente:** Premier Offshore Solutions — Santiago de los Caballeros, República Dominicana.

**Docente:** Asignatura Desarrollo de Proyectos con Software Libre — UAPA, Escuela de Ingeniería y Tecnología.

---

## 📄 Licencia

Este proyecto es de uso académico desarrollado bajo los principios del software libre.  
Todas las tecnologías utilizadas son open source. Ver [LICENSE](LICENSE) para más detalles.

---

> 📌 **Documento de Requerimientos completo:** disponible en la carpeta `/docs` del repositorio.
