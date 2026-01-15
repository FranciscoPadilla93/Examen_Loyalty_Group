import { Routes } from '@angular/router';
import { Login } from './components/login/login';
import { Tiendas } from './components/tiendas/tiendas';
import { Articulos } from './components/articulos/articulos';
import { Historial } from './components/historial/historial';

export const routes: Routes = [
  { path: '', redirectTo: 'login', pathMatch: 'full' },
  { path: 'login', component: Login },
  { path: 'articulos', component: Articulos },
  { path: 'tiendas', component: Tiendas },
  { path: 'historial', component: Historial }
];
