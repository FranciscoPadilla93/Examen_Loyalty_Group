export interface Articulo {
    idArticulo: number;
    codigo: string;
    descripcion: string;
    precio: number;
    stock: number;
    imagen?: string;
}