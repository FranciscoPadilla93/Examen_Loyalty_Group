USE App_Store_Loyalty
GO

 
 CREATE TABLE Clientes (
   idCliente int primary key identity(1,1)
 , Nombre varchar(100)
 , Email VARCHAR(200) NOT NULL UNIQUE
 , PasswordHash VARCHAR(255) NOT NULL
 , Apellidos varchar(100)
 , Direccion varchar(500)
 , Estatus bit DEFAULT 1
 )
GO

CREATE TABLE Tienda (
  idTienda int primary key identity(1,1)
, Sucursal varchar(100)
, Direccion varchar(500)
, Estatus bit DEFAULT 1
)
GO

CREATE TABLE Articulo (
  idArticulo int primary key identity(1,1)
, idTienda INT FOREIGN KEY REFERENCES Tienda(idTienda)
, Codigo varchar(20)
, Descripcion varchar(500)
, Precio decimal(18,2)
, Imagen varbinary(max)
, Stock int
, Estatus bit DEFAULT 1
)
GO

CREATE TABLE CarritoCompras (
  idCarrito int primary key identity(1,1)
, idCliente int FOREIGN KEY references Clientes(idCliente)
, fechaAdd datetime
, Total decimal(18,2)
, fechaMod datetime
, Estatus bit DEFAULT 1
)
GO

CREATE TABLE CarritoCompras_Detalle(
  id int primary key identity(1,1)
, idCarrito int FOREIGN KEY references CarritoCompras(idCarrito)
, idArticulo int FOREIGN KEY references Articulo(idArticulo)
, cantidad int
, Subtotal decimal (18,2)
, precioUnitario decimal (18,2)
, fechaMod datetime
)
GO

CREATE TABLE App_Log_Errors (
  id int primary key identity(1,1)
, Usuario varchar(50)
, ErrorMessage varchar(500)
, ErrorProcedure varchar(200)
, ErrorLine int
, ErrorNumber int
, Params varchar(max)
, fechaAdd datetime
)


CREATE TABLE App_Log (
  id int primary key identity(1,1)
, STP varchar(200)
, Params varchar(max)
, fechaAdd datetime
, Usuario varchar(50)
)
GO

CREATE TABLE Usuario (
  id int primary key identity(1,1)
, idCliente int FOREIGN KEY references Clientes(idCliente)
, fechaAdd datetime default CURRENT_TIMESTAMP
)
GO