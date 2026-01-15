import { Component, OnInit, inject, ChangeDetectorRef } from '@angular/core'; // Agregamos inject
import { CommonModule } from '@angular/common';
import { AuthService } from '../../services/auth';
import { FormsModule } from '@angular/forms';
import { Admin } from '../../services/admin';

@Component({
  selector: 'app-tiendas',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './tiendas.html'
})
export class Tiendas implements OnInit {
  private authService = inject(AuthService);
  private adminService = inject(Admin);
  private cdr = inject(ChangeDetectorRef);
  editando: boolean = false;
  idTiendaEnEdicion: number | null = null;

  tiendas: any[] = [];
  nuevaTienda = { sucursal: '', direccion: '' };

  ngOnInit() {
    this.obtenerTiendas();
  }

  prepararEdicion(t: any) {
    this.editando = true;
    this.idTiendaEnEdicion = t.idTienda || t.IdTienda;

    this.nuevaTienda = {
      idTienda: this.idTiendaEnEdicion, 
      sucursal: t.sucursal || t.Sucursal,
      direccion: t.direccion || t.Direccion,
      estatus: t.estatus || t.Estatus || 1
    } as any;
  }

  obtenerTiendas() {
    this.adminService.getTiendas().subscribe({
      next: (data) => {
        this.tiendas = data,
          this.cdr.detectChanges();
      },
      error: (e) => console.error("Error al cargar tiendas", e)
    });
  }

  guardarTienda() {
    if (!this.nuevaTienda.sucursal || !this.nuevaTienda.direccion) {
      alert("Por favor llena todos los campos");
      return;
    }

    this.adminService.crearTienda(this.nuevaTienda).subscribe({
      next: () => {
        this.obtenerTiendas();
        this.nuevaTienda = { sucursal: '', direccion: '' };
        alert("Tienda guardada con éxito");
      },
      error: (err) => console.error("Error al guardar:", err)
    });
  }

  borrarTienda(id: number) {
    if (confirm('¿Estás seguro de que deseas eliminar esta tienda?')) {
      this.adminService.eliminarTienda(id).subscribe({
        next: () => {
          alert("Tienda eliminada con éxito");
          this.obtenerTiendas();
        },
        error: (err) => console.error("Error al borrar:", err)
      });
    }
  }

  procesarTienda() {
    if (this.editando && this.idTiendaEnEdicion) {
      this.adminService.actualizarTienda(this.idTiendaEnEdicion, this.nuevaTienda).subscribe({
        next: () => {
          this.finalizarAccion("Tienda actualizada");
        }
      });
    } else {
      this.adminService.crearTienda(this.nuevaTienda).subscribe({
        next: () => {
          this.finalizarAccion("Tienda creada");
        }
      });
    }
  }

  finalizarAccion(mensaje: string) {
    alert(mensaje);
    this.obtenerTiendas();
    this.nuevaTienda = { sucursal: '', direccion: '' };
    this.editando = false;
    this.idTiendaEnEdicion = null;
    this.cdr.detectChanges();
  }

  cancelarEdicion() {
    this.nuevaTienda = { sucursal: '', direccion: '' };
    this.editando = false;
    this.idTiendaEnEdicion = null;
  }
}
