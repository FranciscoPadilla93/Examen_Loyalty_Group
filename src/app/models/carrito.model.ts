export interface CarritoDetalle {
    idArticulo: number;
    descripcion: string;     
    cantidad: number;
    precioUnitario: number;
    subtotal: number;
    fechaMod?: Date;      
}

export interface CarritoMaestro {
    idCliente: number;
    total: number;
    estatus: string;         // 'Pendiente' o 'Completado'
    fechaAdd: Date;
    detalles: CarritoDetalle[];
}