import { Component, inject, OnInit, ChangeDetectorRef } from '@angular/core';
import { CommonModule, CurrencyPipe } from '@angular/common';
import { AuthService } from '../../services/auth';
import { CarritoDetalle, CarritoMaestro } from '../../models/carrito.model';
import { Admin } from '../../services/admin';

@Component({
  selector: 'app-articulos',
  standalone: true,
  imports: [CommonModule, CurrencyPipe],
  templateUrl: './articulos.html',
  styleUrl: './articulos.css',
})

export class Articulos implements OnInit {
  private cdr = inject(ChangeDetectorRef);
  private authService = inject(AuthService);

  articulos: any[] = [];
  carrito: CarritoDetalle[] = [];
  totalCompra: number = 0;
  cargando: boolean = false

  ngOnInit() {
    this.cargarCatalogo();
  }

  cargarCatalogo() {
    this.authService.getArticulos().subscribe({
      next: (data) => {
        this.articulos = data;
        this.cdr.detectChanges();
      },
      error: (err) => console.error('Error al cargar artículos', err)
    });
  }

  agregarAlCarrito(art: any) {
    const itemExistente = this.carrito.find(item => item.idArticulo === art.idArticulo);
    const cantidadActual = itemExistente ? itemExistente.cantidad : 0;

    if (cantidadActual + 1 > art.stock) {
      alert(`⚠️ No puedes agregar más. Solo quedan ${art.stock} unidades de ${art.descripcion}.`);
      return;
    }

    if (itemExistente) {
      itemExistente.cantidad++;
      itemExistente.subtotal = itemExistente.cantidad * itemExistente.precioUnitario;
    } else {
      const nuevoItem: CarritoDetalle = {
        idArticulo: art.idArticulo,
        descripcion: art.descripcion,
        cantidad: 1,
        precioUnitario: art.precio,
        subtotal: art.precio
      };
      this.carrito.push(nuevoItem);
    }
    this.actualizarTotal();
  }

  eliminarDelCarrito(index: number) {
    this.carrito.splice(index, 1);
    this.actualizarTotal();
  }

  actualizarTotal() {
    this.totalCompra = this.carrito.reduce((acc, item) => acc + item.subtotal, 0);
  }

  finalizarCompra() {
    if (this.carrito.length === 0) return;
    this.cargando = true;

    const venta: CarritoMaestro = {
      idCliente: 1,
      total: this.totalCompra,
      estatus: '1',
      fechaAdd: new Date(),
      detalles: [...this.carrito]
    };

    this.authService.registrarVenta(venta).subscribe({
      next: () => {
        this.cargando = false;

        alert('✅ ¡Venta registrada con éxito!');

        this.reiniciarPantalla();
      },
      error: (err) => {
        this.cargando = false;
        alert('❌ Error: ' + err.message);
      }
    });
  }

  reiniciarPantalla() {
    this.carrito = [];     
    this.totalCompra = 0;   
    this.cargarCatalogo(); 
    this.cdr.markForCheck();
    this.cdr.detectChanges();
  }
}