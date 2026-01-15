USE App_Store_Loyalty
GO

-- =============================================
-- Author: Francisco Padilla
-- Create date: 04/11/2025
-- Description: Crear una tienda nueva
-- =============================================
CREATE PROCEDURE [dbo].[stp_Set_CreateStore]
	  @Nombre varchar(100)
	, @Direccion varchar(500)
	, @idTienda int output
	, @Success bit output
	, @Message varchar(500) output
AS
BEGIN	
	BEGIN TRY
		SET @Nombre = isnull(@Nombre,'')

		BEGIN TRAN
			IF NOT EXISTS (SELECT idTienda FROM Tienda With(NoLock) WHERE Sucursal = @Nombre)  
			BEGIN
				INSERT INTO Tienda (Sucursal, Direccion) 
				VALUES (@Nombre, @Direccion)	

				SET @Success = 1
				SET @Message = 'Tienda registrada exitosamente.'

				SET @idTienda = SCOPE_IDENTITY()
			END
			ELSE BEGIN
				SET @Success = 0
				SET @Message = 'Ya existe una tienda con el mismo nombre de la sucursal.'
			END

			INSERT INTO App_Log (STP, Params, fechaAdd) 
			VALUES ('stp_Set_CreateStore', CONCAT(@Nombre, '-', @Direccion), CURRENT_TIMESTAMP)	
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SET @Success = 0
		SET @Message = ERROR_MESSAGE()

		INSERT INTO App_Log_Errors
			(ErrorMessage, ErrorProcedure, ErrorLine, ErrorNumber, Params, fechaAdd)
		VALUES
			(ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_NUMBER(), CONCAT(@Nombre,',', @Direccion,','),CURRENT_TIMESTAMP)
	
	END CATCH

	SELECT @Success as [Success], @Message as [Message] 
END
GO

-- =============================================
-- Author: Francisco Padilla
-- Create date: 04/11/2025
-- Description: Actualizar una tienda
-- =============================================
CREATE PROCEDURE [dbo].[stp_Set_UpdateStore]
	  @idTienda int
	, @Nombre varchar(100)
	, @Direccion varchar(500)
	, @Estatus bit
	, @Success bit output
	, @Message varchar(500) output
AS
BEGIN	
	BEGIN TRY
		SET @Nombre = isnull(@Nombre,'')

		BEGIN TRAN
			IF EXISTS (SELECT idTienda FROM Tienda With(NoLock) WHERE idTienda = @idTienda)  
			BEGIN
				UPDATE Tienda SET
				  Sucursal = @Nombre
				, Direccion = @Direccion
				, Estatus = @Estatus
				WHERE idTienda = @idTienda

				SET @Success = 1
				SET @Message = 'Tienda actualizada exitosamente.'
			END
			ELSE BEGIN
				SET @Success = 0
				SET @Message = CONCAT('No existe la tienda con ID: ',@idTienda, '. Verificalo de nuevo.')
			END

			INSERT INTO App_Log (STP, Params, fechaAdd) 
			VALUES ('stp_Set_UpdateStore', CONCAT(@idTienda,',',@Nombre,',', @Direccion,','), CURRENT_TIMESTAMP)	
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SET @Success = 0
		SET @Message = ERROR_MESSAGE()

		INSERT INTO App_Log_Errors
			(ErrorMessage, ErrorProcedure, ErrorLine, ErrorNumber, Params, fechaAdd)
		VALUES
			(ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_NUMBER(), 'Aqui van los parametros',CURRENT_TIMESTAMP)
	
	END CATCH

	SELECT @Success as [Success], @Message as [Message] 
END
GO

-- =============================================
-- Author: Francisco Padilla
-- Create date: 04/11/2025
-- Description: Obtener todo el listado de tiendas
-- =============================================
CREATE PROCEDURE [dbo].[stp_Get_AllStore]
AS
BEGIN
	SELECT 
	idTienda, Sucursal, Direccion, Estatus
	FROM Tienda With(NoLock) 
	WHERE Estatus = 1
	ORDER BY Sucursal 
END
GO

-- =============================================
-- Author: Francisco Padilla
-- Create date: 04/11/2025
-- Description: Obtener la tienda por ID
-- =============================================
CREATE PROCEDURE [dbo].[stp_Get_StoreByID] (@idTienda int)
AS
BEGIN
	SELECT 
	idTienda, Sucursal, Direccion, Estatus
	FROM Tienda With(NoLock)
	WHERE idTienda = @idTienda
END
GO

-- =============================================
-- Author: Francisco Padilla
-- Create date: 04/11/2025
-- Description: Eliminar logicamente una tienda
-- =============================================
CREATE PROCEDURE [dbo].[stp_Set_DeleteStore]
	  @idTienda int
	, @Success bit output
	, @Message varchar(500) output
AS
BEGIN	
	BEGIN TRY
		BEGIN TRAN
			IF EXISTS (SELECT idTienda FROM Tienda With(NoLock) WHERE idTienda = @idTienda)  
			BEGIN
				UPDATE Tienda SET
				Estatus = 0
				WHERE idTienda = @idTienda

				SET @Success = 1
				SET @Message = 'Tienda eliminada exitosamente.'
			END
			ELSE BEGIN
				SET @Success = 0
				SET @Message = CONCAT('No existe la tienda con ID: ',@idTienda, '. Verificalo de nuevo.')
			END

			INSERT INTO App_Log (STP, Params, fechaAdd) 
			VALUES ('stp_Set_DeleteStore', @idTienda, CURRENT_TIMESTAMP)	
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SET @Success = 0
		SET @Message = ERROR_MESSAGE()

		INSERT INTO App_Log_Errors
			(ErrorMessage, ErrorProcedure, ErrorLine, ErrorNumber, Params, fechaAdd)
		VALUES
			(ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_NUMBER(), @idTienda,CURRENT_TIMESTAMP)
	
	END CATCH

	SELECT @Success as [Success], @Message as [Message] 
END
GO

CREATE PROCEDURE [dbo].[stp_Get_AllArticulos]
AS
BEGIN
	SELECT 
	idArticulo, idTienda, Codigo, Descripcion, Precio, Stock, Estatus
	FROM Articulo With(NoLock) 
	WHERE Estatus = 1
	ORDER BY idTienda 
END
GO

CREATE PROCEDURE [dbo].[stp_Get_ArticuloByID] (@idArticulo int)
AS
BEGIN
	SELECT 
	idArticulo, idTienda, Codigo, Descripcion, Precio, Stock, Estatus
	FROM Articulo With(NoLock) 
	WHERE idArticulo  = @idArticulo
END
GO

CREATE PROCEDURE [dbo].[stp_Set_CreateArticulo]
	  @idTienda varchar(100)
	, @Codigo varchar(20)
	, @Descripcion varchar(500)
	, @Precio decimal(18,2)
	, @Stock int
	, @Estatus bit
	, @idArticulo int output
	, @Success bit output
	, @Message varchar(500) output
AS
BEGIN	
	BEGIN TRY
		BEGIN TRAN
			IF EXISTS (SELECT idTienda FROM Tienda With(NoLock) WHERE idTienda = @idTienda)  
			BEGIN
				IF NOT EXISTS(SELECT idArticulo FROM Articulo With(NoLock) WHERE Codigo = @Codigo)
				BEGIN
					INSERT INTO Articulo 
					(idTienda, Codigo, Descripcion, Precio, Stock, Estatus)
					VALUES
					(@idTienda, @Codigo, @Descripcion, @Precio, @Stock, @Estatus)

					SET @Success = 1
					SET @Message = 'Articulo registrado exitosamente.'

					SET @idArticulo = SCOPE_IDENTITY()
				END
				ELSE
				BEGIN
					SET @Success = 0
					SET @Message = CONCAT('El articulo con el codigo: ', @Codigo, ' ya existe.')
				END
			END
			ELSE BEGIN
				SET @Success = 0
				SET @Message = CONCAT('La tienda con ID: ', @idTienda, ' no existe.')
			END

			INSERT INTO App_Log (STP, Params, fechaAdd) 
			VALUES ('stp_Set_CreateArticulo', CONCAT(@idTienda, '-', @Codigo, '-',@Descripcion, '-', @Precio, '-', @Stock, '-', @Estatus), CURRENT_TIMESTAMP)	
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SET @Success = 0
		SET @Message = ERROR_MESSAGE()

		INSERT INTO App_Log_Errors
			(ErrorMessage, ErrorProcedure, ErrorLine, ErrorNumber, Params, fechaAdd)
		VALUES
			(ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_NUMBER(), CONCAT(@idTienda, '-', @Codigo, '-',@Descripcion, '-', @Precio, '-', @Stock, '-', @Estatus),CURRENT_TIMESTAMP)
	
	END CATCH
END
GO

CREATE PROCEDURE [dbo].[stp_Set_UpdateArticulo]
	  @idArticulo int
	, @idTienda int
	, @Codigo varchar(20)
	, @Descripcion varchar(500)
	, @Precio decimal(18,2)
	, @Stock int
	, @Estatus bit
	, @Success bit output
	, @Message varchar(500) output
AS
BEGIN	
	BEGIN TRY
		BEGIN TRAN
			IF EXISTS (SELECT idArticulo FROM Articulo With(NoLock) WHERE idArticulo = @idArticulo)  
			BEGIN
				UPDATE Articulo SET
				  idTienda = @idTienda
				, Codigo = @Codigo
				, Estatus = @Estatus
				, Descripcion = @Descripcion
				, Precio = @Precio
				, Stock = @Stock
				WHERE idArticulo = @idArticulo

				SET @Success = 1
				SET @Message = 'Articulo actualizado exitosamente.'
			END
			ELSE BEGIN
				SET @Success = 0
				SET @Message = CONCAT('No existe el articulo con ID: ',@idArticulo, '. Verificalo de nuevo.')
			END

			INSERT INTO App_Log (STP, Params, fechaAdd) 
			VALUES ('stp_Set_UpdateArticulo', CONCAT(@idArticulo, '-', @idTienda, '-', @Codigo, '-',@Descripcion, '-', @Precio, '-', @Stock, '-', @Estatus), CURRENT_TIMESTAMP)	
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SET @Success = 0
		SET @Message = ERROR_MESSAGE()

		INSERT INTO App_Log_Errors
			(ErrorMessage, ErrorProcedure, ErrorLine, ErrorNumber, Params, fechaAdd)
		VALUES
			(ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_NUMBER(), CONCAT(@idArticulo, '-', @idTienda, '-', @Codigo, '-',@Descripcion, '-', @Precio, '-', @Stock, '-', @Estatus),CURRENT_TIMESTAMP)
	
	END CATCH
END
GO

CREATE PROCEDURE [dbo].[stp_Set_DeleteArticulo]
	  @idArticulo int
	, @Success bit output
	, @Message varchar(500) output
AS
BEGIN	
	BEGIN TRY
		BEGIN TRAN
			IF EXISTS (SELECT idTienda FROM Articulo With(NoLock) WHERE idArticulo = @idArticulo)  
			BEGIN
				UPDATE Articulo SET
				Estatus = 0
				WHERE idArticulo = @idArticulo

				SET @Success = 1
				SET @Message = 'Articulo eliminado exitosamente.'
			END
			ELSE BEGIN
				SET @Success = 0
				SET @Message = CONCAT('No existe el articulo con ID: ',@idArticulo, '. Verificalo de nuevo.')
			END

			INSERT INTO App_Log (STP, Params, fechaAdd) 
			VALUES ('stp_Set_DeleteArticulo', @idArticulo, CURRENT_TIMESTAMP)	
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SET @Success = 0
		SET @Message = ERROR_MESSAGE()

		INSERT INTO App_Log_Errors
			(ErrorMessage, ErrorProcedure, ErrorLine, ErrorNumber, Params, fechaAdd)
		VALUES
			(ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_NUMBER(), @idArticulo,CURRENT_TIMESTAMP)
	
	END CATCH
END
GO

CREATE PROCEDURE [dbo].[stp_Get_AllClientes]
AS
BEGIN
	SELECT 
	idCliente, Nombre, Email, PasswordHash, Apellidos, Direccion, Estatus
	FROM Clientes With(NoLock) 
	WHERE Estatus = 1
	ORDER BY idCliente 
END
GO

CREATE PROCEDURE [dbo].[stp_Get_ClienteByID] (@idCliente int)
AS
BEGIN
	SELECT 
	idCliente, Nombre, Email, PasswordHash, Apellidos, Direccion, Estatus
	FROM Clientes With(NoLock) 
	WHERE idCliente  = @idCliente
END
GO

CREATE PROCEDURE [dbo].[stp_Set_CreateCliente]
	  @Nombre varchar(100)
	, @Apellido varchar(100)
	, @Email VARCHAR(200)
	, @Password varchar(100)
	, @Direccion varchar(500)
	, @Estatus bit
	, @idCliente int output
	, @Success bit output
	, @Message varchar(500) output
AS
BEGIN	
	BEGIN TRY
		BEGIN TRAN
			IF NOT EXISTS(select idCliente from Clientes where Email = @Email)
			BEGIN
				INSERT INTO Clientes 
				(Nombre, Apellidos, Email, PasswordHash, Direccion, Estatus)
				VALUES
				(@Nombre, @Apellido, @Email, @Password, @Direccion, @Estatus)

				SET @Success = 1
				SET @Message = 'Cliente registrado exitosamente.'

				SET @idCliente = SCOPE_IDENTITY()
			
				INSERT INTO App_Log (STP, Params, fechaAdd) 
				VALUES ('stp_Set_CreateCliente', CONCAT(@Nombre, '-', @Apellido, '-',@Email, '-', @Password, '-', @Direccion, '-', @Estatus), CURRENT_TIMESTAMP)	
			END
			ELSE
			BEGIN
				SET @Success = 0
				SET @Message = CONCAT('El Email: ', @Email, ' ya existe registrado en sistema.')
			END
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SET @Success = 0
		SET @Message = ERROR_MESSAGE()

		INSERT INTO App_Log_Errors
			(ErrorMessage, ErrorProcedure, ErrorLine, ErrorNumber, Params, fechaAdd)
		VALUES
			(ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_NUMBER(), CONCAT(@Nombre, '-', @Apellido, '-',@Email, '-', @Password, '-', @Direccion, '-', @Estatus),CURRENT_TIMESTAMP)
	
	END CATCH 
END
GO

CREATE PROCEDURE [dbo].[stp_Set_UpdateCliente]
	  @idCliente int
	, @Nombre varchar(100)
	, @Apellido varchar(100)
	, @Email VARCHAR(200)
	, @Password varchar(100)
	, @Direccion varchar(500)
	, @Estatus bit
	, @Success bit output
	, @Message varchar(500) output
AS
BEGIN	
	BEGIN TRY
		BEGIN TRAN
			IF EXISTS (SELECT @idCliente FROM Clientes With(NoLock) WHERE idCliente = @idCliente)  
			BEGIN
				UPDATE Clientes SET
				  Nombre = @Nombre
				, Apellidos = @Apellido
				, Email = @Email
				, PasswordHash = @Password
				, Direccion = @Direccion
				, Estatus = @Estatus
				WHERE idCliente = @idCliente

				SET @Success = 1
				SET @Message = 'Cliente actualizado exitosamente.'
			END
			ELSE BEGIN
				SET @Success = 0
				SET @Message = CONCAT('No existe el cliente con ID: ',@idCliente, '. Verificalo de nuevo.')
			END

			INSERT INTO App_Log (STP, Params, fechaAdd) 
			VALUES ('stp_Set_UpdateCliente', CONCAT(@idCliente, '-', @Nombre, '-', @Apellido, '-',@Email, '-', @Password, '-', @Direccion, '-', @Estatus), CURRENT_TIMESTAMP)	
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SET @Success = 0
		SET @Message = ERROR_MESSAGE()

		INSERT INTO App_Log_Errors
			(ErrorMessage, ErrorProcedure, ErrorLine, ErrorNumber, Params, fechaAdd)
		VALUES
			(ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_NUMBER(), CONCAT(@idCliente, '-', @Nombre, '-', @Apellido, '-',@Email, '-', @Password, '-', @Direccion, '-', @Estatus),CURRENT_TIMESTAMP)
	
	END CATCH

	SELECT @Success as [Success], @Message as [Message] 
END
GO

CREATE PROCEDURE [dbo].[stp_Set_DeleteCliente]
	  @idCliente int
	, @Success bit output
	, @Message varchar(500) output
AS
BEGIN	
	BEGIN TRY
		BEGIN TRAN
			IF EXISTS (SELECT @idCliente FROM Clientes With(NoLock) WHERE idCliente = @idCliente)  
			BEGIN
				UPDATE Clientes SET
				Estatus = 0
				WHERE idCliente = @idCliente

				SET @Success = 1
				SET @Message = 'Cliente eliminado exitosamente.'
			END
			ELSE BEGIN
				SET @Success = 0
				SET @Message = CONCAT('No existe el cliente con ID: ',@idCliente, '. Verificalo de nuevo.')
			END

			INSERT INTO App_Log (STP, Params, fechaAdd) 
			VALUES ('stp_Set_DeleteCliente', @idCliente, CURRENT_TIMESTAMP)	
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SET @Success = 0
		SET @Message = ERROR_MESSAGE()

		INSERT INTO App_Log_Errors
			(ErrorMessage, ErrorProcedure, ErrorLine, ErrorNumber, Params, fechaAdd)
		VALUES
			(ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_NUMBER(), @idCliente,CURRENT_TIMESTAMP)
	
	END CATCH
END
GO

CREATE PROCEDURE [dbo].[stp_Set_CreateCarrito]
    @idCliente INT,
    @idCarrito INT OUTPUT,
    @Success BIT OUTPUT,
    @Message VARCHAR(500) OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRAN

        IF EXISTS (SELECT 1 FROM Clientes WHERE idCliente = @idCliente)
        BEGIN
            INSERT INTO CarritoCompras (idCliente, fechaAdd, Estatus, Total, fechaMod)
			VALUES (@idCliente, GETDATE(), 0, 0, GETDATE())

			SET @idCarrito = SCOPE_IDENTITY()
			SET @Success = 1
			SET @Message = 'Carrito creado exitosamente.'
        END
		ELSE
		BEGIN
			SET @Success = 0
            SET @Message = CONCAT('No existe el cliente con ID ', @idCliente)
		END
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN
        SET @Success = 0
        SET @Message = ERROR_MESSAGE()
    END CATCH
END
GO

CREATE PROCEDURE [dbo].[stp_Set_AddArticuloCarrito]
    @idCarrito INT,
    @idArticulo INT,
    @cantidad INT,
    @Success BIT OUTPUT,
    @Message VARCHAR(500) OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRAN

        IF NOT EXISTS (SELECT 1 FROM CarritoCompras WHERE idCarrito = @idCarrito)
        BEGIN
            SET @Success = 0
            SET @Message = CONCAT('No existe el carrito con ID: ', @idCarrito)
            ROLLBACK TRAN
            RETURN
        END

        IF NOT EXISTS (SELECT 1 FROM Articulo WHERE idArticulo = @idArticulo)
        BEGIN
            SET @Success = 0
            SET @Message = CONCAT('No existe el artículo con ID: ', @idArticulo)
            ROLLBACK TRAN
            RETURN
        END

        DECLARE @precio DECIMAL(10,2) = (SELECT Precio FROM Articulo WHERE idArticulo = @idArticulo)
        DECLARE @subtotal DECIMAL(10,2) = @precio * @cantidad

        IF EXISTS (SELECT 1 FROM CarritoCompras_Detalle WHERE idCarrito = @idCarrito AND idArticulo = @idArticulo)
        BEGIN
            UPDATE CarritoCompras_Detalle
            SET cantidad = cantidad + @cantidad,
                Subtotal = (cantidad + @cantidad) * @precio,
                precioUnitario = @precio,
                fechaMod = GETDATE()
            WHERE idCarrito = @idCarrito AND idArticulo = @idArticulo

            SET @Message = 'Cantidad actualizada en el carrito.'
        END
        ELSE
        BEGIN
            INSERT INTO CarritoCompras_Detalle (idCarrito, idArticulo, Subtotal, precioUnitario, cantidad, fechaMod)
            VALUES (@idCarrito, @idArticulo, @subtotal, @precio, @cantidad, GETDATE())

            SET @Message = 'Artículo agregado al carrito.'
        END

        DECLARE @total DECIMAL(10,2) = (
            SELECT SUM(Subtotal) FROM CarritoCompras_Detalle WHERE idCarrito = @idCarrito
        )

        UPDATE CarritoCompras
        SET Total = @total,
            fechaMod = GETDATE()
        WHERE idCarrito = @idCarrito

        SET @Success = 1

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN
        SET @Success = 0
        SET @Message = ERROR_MESSAGE()
    END CATCH
END
GO

CREATE PROCEDURE [dbo].[stp_Set_UpdateCantidadCarrito]
    @idCarrito INT,
    @idArticulo INT,
    @cantidad INT,
    @Success BIT OUTPUT,
    @Message VARCHAR(500) OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRAN
        IF NOT EXISTS (SELECT 1 FROM CarritoCompras WHERE idCarrito = @idCarrito)
        BEGIN
            SET @Success = 0
            SET @Message = CONCAT('No existe el carrito con ID: ', @idCarrito)
            ROLLBACK TRAN
            RETURN
        END

        IF NOT EXISTS (SELECT 1 FROM CarritoCompras_Detalle WHERE idCarrito = @idCarrito AND idArticulo = @idArticulo)
        BEGIN
            SET @Success = 0
            SET @Message = CONCAT('El artículo con ID ', @idArticulo, ' no se encuentra en el carrito ', @idCarrito)
            ROLLBACK TRAN
            RETURN
        END

        DECLARE @precio DECIMAL(10,2) = (SELECT Precio FROM Articulo WHERE idArticulo = @idArticulo)
        DECLARE @subtotal DECIMAL(10,2) = @precio * @cantidad

        UPDATE CarritoCompras_Detalle
        SET cantidad = @cantidad,
            Subtotal = @subtotal,
            precioUnitario = @precio,
            fechaMod = GETDATE()
        WHERE idCarrito = @idCarrito AND idArticulo = @idArticulo

        DECLARE @total DECIMAL(10,2) = (
            SELECT SUM(Subtotal) FROM CarritoCompras_Detalle WHERE idCarrito = @idCarrito
        )

        UPDATE CarritoCompras
        SET Total = @total,
            fechaMod = GETDATE()
        WHERE idCarrito = @idCarrito

        SET @Success = 1
        SET @Message = 'Cantidad del artículo actualizada correctamente.'

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN
        SET @Success = 0
        SET @Message = ERROR_MESSAGE()
    END CATCH
END
GO

CREATE PROCEDURE [dbo].[stp_Set_RemoveArticuloCarrito]
    @idCarrito INT,
    @idArticulo INT,
    @Success BIT OUTPUT,
    @Message VARCHAR(500) OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRAN
        IF NOT EXISTS (SELECT 1 FROM CarritoCompras WHERE idCarrito = @idCarrito)
        BEGIN
            SET @Success = 0
            SET @Message = CONCAT('No existe el carrito con ID: ', @idCarrito)
            ROLLBACK TRAN
            RETURN
        END

        IF NOT EXISTS (SELECT 1 FROM CarritoCompras_Detalle WHERE idCarrito = @idCarrito AND idArticulo = @idArticulo)
        BEGIN
            SET @Success = 0
            SET @Message = CONCAT('El artículo con ID ', @idArticulo, ' no se encuentra en el carrito ', @idCarrito)
            ROLLBACK TRAN
            RETURN
        END

        DELETE FROM CarritoCompras_Detalle
        WHERE idCarrito = @idCarrito AND idArticulo = @idArticulo

        DECLARE @total DECIMAL(10,2) = ISNULL(
            (SELECT SUM(Subtotal) FROM CarritoCompras_Detalle WHERE idCarrito = @idCarrito), 0
        )

        UPDATE CarritoCompras
        SET Total = @total,
            fechaMod = GETDATE()
        WHERE idCarrito = @idCarrito

        IF @total = 0
        BEGIN
            UPDATE CarritoCompras SET Estatus = 0 WHERE idCarrito = @idCarrito
        END

        SET @Success = 1
        SET @Message = 'Artículo eliminado correctamente del carrito.'

        INSERT INTO App_Log (STP, Params, fechaAdd)
        VALUES ('stp_Set_RemoveArticuloCarrito', CONCAT('Carrito:', @idCarrito, ', Articulo:', @idArticulo), GETDATE())

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN
        SET @Success = 0
        SET @Message = ERROR_MESSAGE()

        INSERT INTO App_Log_Errors (ErrorMessage, ErrorProcedure, ErrorLine, ErrorNumber, Params, fechaAdd)
        VALUES (ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_NUMBER(),
                CONCAT('Carrito:', @idCarrito, ', Articulo:', @idArticulo),
                GETDATE())
    END CATCH
END
GO

CREATE PROCEDURE [dbo].[stp_Set_DeleteCarrito]
    @idCarrito INT,
    @Success BIT OUTPUT,
    @Message VARCHAR(500) OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRAN

        IF NOT EXISTS (SELECT 1 FROM CarritoCompras WHERE idCarrito = @idCarrito)
        BEGIN
            SET @Success = 0
            SET @Message = CONCAT('No existe el carrito con ID: ', @idCarrito)
            ROLLBACK TRAN
            RETURN
        END

        DELETE FROM CarritoCompras_Detalle
        WHERE idCarrito = @idCarrito

        DELETE FROM CarritoCompras
        WHERE idCarrito = @idCarrito

        INSERT INTO App_Log (STP, Params, fechaAdd)
        VALUES ('stp_Set_DeleteCarrito', CONCAT('Carrito eliminado: ', @idCarrito), GETDATE())

        SET @Success = 1
        SET @Message = 'Carrito eliminado correctamente.'

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN

        SET @Success = 0
        SET @Message = ERROR_MESSAGE()

        INSERT INTO App_Log_Errors (ErrorMessage, ErrorProcedure, ErrorLine, ErrorNumber, Params, fechaAdd)
        VALUES (ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_NUMBER(),
                CONCAT('Carrito:', @idCarrito),
                GETDATE())
    END CATCH
END
GO

CREATE PROCEDURE [dbo].[stp_Get_CarritoByCliente]
    @IdCliente INT
AS
BEGIN
    SELECT 
        c.idCarrito,
        c.idCliente,
        c.Total,
        c.fechaAdd,
        c.fechaMod,
        c.Estatus
    FROM CarritoCompras c
    WHERE c.idCliente = @IdCliente AND c.Estatus = 1

    SELECT 
        d.id,
        d.idCarrito,
        d.idArticulo,
        a.Descripcion AS ArticuloNombre,
        d.cantidad,
        d.precioUnitario,
        d.Subtotal,
        d.fechaMod
    FROM CarritoCompras_Detalle d
    INNER JOIN Articulo a ON a.idArticulo = d.idArticulo
    INNER JOIN CarritoCompras c ON c.idCarrito = d.idCarrito
    WHERE c.idCliente = @IdCliente AND c.Estatus = 1
END
GO

CREATE PROCEDURE [dbo].[stp_Set_AgregarArticuloCarrito]
    @IdCliente INT,
    @IdArticulo INT,
    @Cantidad INT,
    @Success BIT OUTPUT,
    @Message VARCHAR(500) OUTPUT
AS
BEGIN
    BEGIN TRY
        DECLARE @IdCarrito INT
        DECLARE @PrecioUnitario DECIMAL(18,2)
        DECLARE @Subtotal DECIMAL(18,2)

        -- Precio del artículo
        SELECT @PrecioUnitario = Precio FROM Articulo WHERE idArticulo = @IdArticulo
        SET @Subtotal = @PrecioUnitario * @Cantidad

        BEGIN TRAN

        -- Buscar carrito activo del cliente
        SELECT @IdCarrito = idCarrito 
        FROM CarritoCompras 
        WHERE idCliente = @IdCliente AND Estatus = 1

        -- Si no tiene carrito, lo crea
        IF @IdCarrito IS NULL
        BEGIN
            INSERT INTO CarritoCompras (idCliente, fechaAdd, Estatus, Total)
            VALUES (@IdCliente, GETDATE(), 1, 0)

            SET @IdCarrito = SCOPE_IDENTITY()
        END

        -- Verificar si el artículo ya está en el carrito
        IF EXISTS (SELECT 1 FROM CarritoCompras_Detalle WHERE idCarrito = @IdCarrito AND idArticulo = @IdArticulo)
        BEGIN
            UPDATE CarritoCompras_Detalle
            SET cantidad = cantidad + @Cantidad,
                Subtotal = Subtotal + @Subtotal,
                fechaMod = GETDATE()
            WHERE idCarrito = @IdCarrito AND idArticulo = @IdArticulo
        END
        ELSE
        BEGIN
            INSERT INTO CarritoCompras_Detalle (idCarrito, idArticulo, cantidad, precioUnitario, Subtotal, fechaMod)
            VALUES (@IdCarrito, @IdArticulo, @Cantidad, @PrecioUnitario, @Subtotal, GETDATE())
        END

        -- Actualizar total del carrito
        UPDATE CarritoCompras
        SET Total = (SELECT SUM(Subtotal) FROM CarritoCompras_Detalle WHERE idCarrito = @IdCarrito),
            fechaMod = GETDATE()
        WHERE idCarrito = @IdCarrito

        SET @Success = 1
        SET @Message = 'Artículo agregado correctamente al carrito.'

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN
        SET @Success = 0
        SET @Message = ERROR_MESSAGE()
    END CATCH
END
GO

CREATE PROCEDURE [dbo].[stp_Set_DeleteArticuloCarrito]
    @IdCarrito INT,
    @IdArticulo INT,
    @Success BIT OUTPUT,
    @Message VARCHAR(500) OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRAN

        DELETE FROM CarritoCompras_Detalle 
        WHERE idCarrito = @IdCarrito AND idArticulo = @IdArticulo

        -- Recalcular total del carrito
        UPDATE CarritoCompras
        SET Total = ISNULL((SELECT SUM(Subtotal) FROM CarritoCompras_Detalle WHERE idCarrito = @IdCarrito), 0),
            fechaMod = GETDATE()
        WHERE idCarrito = @IdCarrito

        SET @Success = 1
        SET @Message = 'Artículo eliminado del carrito correctamente.'

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN
        SET @Success = 0
        SET @Message = ERROR_MESSAGE()
    END CATCH
END
GO

CREATE PROCEDURE [dbo].[stp_Set_EliminarCarrito]
    @IdCarrito INT,
    @Success BIT OUTPUT,
    @Message VARCHAR(500) OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRAN

        DELETE FROM CarritoCompras_Detalle WHERE idCarrito = @IdCarrito
        DELETE FROM CarritoCompras WHERE idCarrito = @IdCarrito

        SET @Success = 1
        SET @Message = 'Carrito eliminado correctamente.'

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN
        SET @Success = 0
        SET @Message = ERROR_MESSAGE()
    END CATCH
END
GO

CREATE PROCEDURE [dbo].[stp_Auth_LoginCliente]
    @Email VARCHAR(150),
    @Password VARCHAR(150)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Success BIT = 0;
    DECLARE @Message VARCHAR(200) = '';
    
    IF EXISTS (SELECT 1 FROM Clientes WHERE Email = @Email AND PasswordHash = @Password AND Estatus = 1)
    BEGIN
        SELECT TOP 1 
            idCliente,
            Nombre,
            Apellidos,
            Email
        FROM Clientes
        WHERE Email = @Email AND PasswordHash = @Password;

        SET @Success = 1;
        SET @Message = 'Inicio de sesión exitoso.';
    END
    ELSE
    BEGIN
        SET @Success = 0;
        SET @Message = 'Credenciales incorrectas o usuario inactivo.';
    END

    SELECT @Success AS Success, @Message AS Message;
END
GO

CREATE PROCEDURE [dbo].[stp_Get_ClienteByCredenciales]
    @Email VARCHAR(100),
    @Password VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        IdCliente,
        Nombre,
        Email,
        PasswordHash
    FROM Clientes
    WHERE Email = @Email
      AND PasswordHash = @Password
      AND Estatus = 1; -- opcional si tienes campo activo/inactivo
END
GO

CREATE PROCEDURE stp_Get_ArticulosByTienda
    @IdTienda INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        IdArticulo,
        IdTienda,
        Codigo,
        Descripcion,
        Precio,
        Stock,
        Estatus
    FROM Articulo
    WHERE IdTienda = @IdTienda;
END
GO

CREATE PROCEDURE stp_Set_RegistrarDetalleCompra
    @idCarrito INT,
    @idArticulo INT,
    @cantidad INT,
    @precio DECIMAL(18,2),
    @subtotal DECIMAL(18,2)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO CarritoCompras_Detalle (idCarrito, idArticulo, cantidad, precioUnitario, Subtotal, fechaMod)
    VALUES (@idCarrito, @idArticulo, @cantidad, @precio, @subtotal, GETDATE());

    UPDATE Articulo SET Stock = Stock - @cantidad WHERE idArticulo = @idArticulo
END
GO

CREATE PROCEDURE stp_Set_RegistrarCompra
    @idCliente INT,
    @Total DECIMAL(18,2),
    @NuevoIdCarrito INT OUTPUT, -- <--- Parámetro de salida
    @Success BIT OUTPUT,
    @Message VARCHAR(500) OUTPUT
AS
BEGIN
    BEGIN TRY
        INSERT INTO CarritoCompras (idCliente, fechaAdd, Estatus, Total)
        VALUES (@idCliente, GETDATE(), 1, @Total);

        -- Capturamos el ID recién creado
        SET @NuevoIdCarrito = SCOPE_IDENTITY();
        SET @Success = 1;
        SET @Message = 'Encabezado registrado correctamente';
    END TRY
    BEGIN CATCH
        SET @Success = 0;
        SET @Message = ERROR_MESSAGE();
    END CATCH
END
GO