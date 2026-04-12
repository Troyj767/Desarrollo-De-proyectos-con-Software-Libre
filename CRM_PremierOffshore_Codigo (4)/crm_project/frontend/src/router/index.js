// frontend/src/router/index.js
import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  { path: '/',             redirect: '/dashboard' },
  { path: '/login',        component: () => import('../views/LoginView.vue'),        meta: { public: true } },
  { path: '/dashboard',    component: () => import('../views/DashboardView.vue'),    meta: { title: 'Dashboard' } },
  { path: '/contactos',    component: () => import('../views/ContactosView.vue'),    meta: { title: 'Contactos' } },
  { path: '/pipeline',     component: () => import('../views/PipelineView.vue'),     meta: { title: 'Pipeline' } },
  { path: '/tareas',       component: () => import('../views/TareasView.vue'),       meta: { title: 'Tareas' } },
  { path: '/usuarios',     component: () => import('../views/UsuariosView.vue'),     meta: { title: 'Usuarios', rol: 'Administrador' } },
  { path: '/auditoria',    component: () => import('../views/AuditoriaView.vue'),    meta: { title: 'Auditoría', rol: 'Administrador' } },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

// Guard: redirige a login si no hay token
router.beforeEach((to) => {
  const token = localStorage.getItem('access_token')
  if (!to.meta.public && !token) return '/login'
})

export default router
