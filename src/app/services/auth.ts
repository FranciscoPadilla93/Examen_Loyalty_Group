import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { AuthResponse } from '../models/user.model';
import { HttpHeaders } from '@angular/common/http';
import { Tienda } from '../models/tienda.model';
import { Articulo } from '../models/articulo.model';
import { CarritoMaestro } from '../models/carrito.model';
import { inject, Injectable } from '@angular/core';
import { Router } from '@angular/router';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  private router = inject(Router);
  private apiUrl = 'https://localhost:7003/api';

  constructor(private http: HttpClient) { }

  login(credentials: any): Observable<AuthResponse> {
    return this.http.post<AuthResponse>(`${this.apiUrl}/Auth/login`, credentials);
  }

  register(userData: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/Auth/register`, userData);
  }

  saveToken(token: string) {
    localStorage.setItem('token', token);
  }

  getTiendas(): Observable<Tienda[]> {
    const token = localStorage.getItem('token');
    const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);

    return this.http.get<Tienda[]>('https://localhost:7003/api/Tienda', { headers });
  }

  getArticulos(): Observable<Articulo[]> {
    const token = localStorage.getItem('token');
    const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
    return this.http.get<Articulo[]>('https://localhost:7003/api/Articulo', { headers });
  }

  registrarVenta(datosVenta: CarritoMaestro): Observable<any> {
    const token = localStorage.getItem('token');

    const headers = new HttpHeaders({
      'Authorization': `Bearer ${token}`
    });

    return this.http.post(`${this.apiUrl}/Carrito`, datosVenta, { headers });
  }
  getHistorial() {
    const idCliente = 1;
    const token = localStorage.getItem('token');
    const headers = new HttpHeaders({
      'Authorization': `Bearer ${token}`
    });
    return this.http.get<any[]>(`${this.apiUrl}/Carrito/GetHistorial/${idCliente}`, { headers });
  }
  isLoggedIn(): boolean {
    const token = localStorage.getItem('token');

    return !!token;
  }
  logout() {
    localStorage.removeItem('token');
    this.router.navigate(['/login']);
  }
}
