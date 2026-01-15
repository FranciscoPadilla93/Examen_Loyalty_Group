import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class Admin {
  private http = inject(HttpClient);
  private apiUrl = 'https://localhost:7003/api/Tienda'; 

  getTiendas(): Observable<any[]> {
    return this.http.get<any[]>(this.apiUrl);
  }

  crearTienda(tienda: any): Observable<any> {
    return this.http.post(this.apiUrl, tienda);
  }

  actualizarTienda(id: number, tienda: any): Observable<any> {
    return this.http.put(`${this.apiUrl}`, tienda);
  }

  eliminarTienda(id: number): Observable<any> {
    return this.http.delete(`${this.apiUrl}/${id}`);
  }
}
