USE PizzariaDB;
GO

-- STORED PROCEDURE
-- Procedure para cadastrar clientes
CREATE OR ALTER PROCEDURE dbo.sp_CadastrarCliente
	@nome VARCHAR(100),
	@telefone VARCHAR(20),
	@endereco VARCHAR(255) = NULL,
	@novoId INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	-- Validação
	IF EXISTS (SELECT 1 FROM Clientes WHERE telefone = @telefone)
	BEGIN
		RAISERROR('Telefone já cadastrado', 16, 1);
		RETURN;
	END

	INSERT INTO Clientes (nome, telefone, endereco)
	VALUES (@nome, @telefone, @endereco);

	SET @novoId = SCOPE_IDENTITY();
END;
GO