import { Component, inject, OnInit, ChangeDetectorRef } from '@angular/core';
import { CommonModule, DatePipe, CurrencyPipe } from '@angular/common';
import { AuthService } from '../../services/auth';

@Component({
  selector: 'app-historial',
  standalone: true,
  imports: [CommonModule, DatePipe, CurrencyPipe],
  templateUrl: './historial.html',
  styleUrl: './historial.css',
})
export class Historial implements OnInit{
private authService = inject(AuthService);
private cdr = inject(ChangeDetectorRef);
  
  ventas: any[] = [];
  cargando: boolean = false;

  ngOnInit() {
    this.obtenerHistorial();
  }

  obtenerHistorial() {
  this.cargando = true;
  this.authService.getHistorial().subscribe({
    next: (data) => {
      console.log('Datos del historial:', data); 
      this.ventas = data;
      this.cargando = false;
      this.cdr.detectChanges();
    },
    error: (err) => {
      console.error('Error al traer el historial', err);
      this.cargando = false;
    }
  });
}
}
