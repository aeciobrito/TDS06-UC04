USE EstacionamentoDB
GO

CREATE OR ALTER PROCEDURE sp_RegistrarEntradaVeiculo
	@placa VARCHAR(100),
	@vaga_id INT,
	@registro_id INT OUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @veiculo_id INT;
	SELECT @veiculo_id = id FROM Veiculos WHERE placa = @placa;

	IF @veiculo_id IS NULL
	BEGIN
		RAISERROR('Veículo com esta placa não enocntrado', 16, 1);
		RETURN;
	END

	INSERT INTO RegistrosEstacionamento (veiculo_id, vaga_id, data_hora_entrada)
	VALUES (@veiculo_id, @vaga_id, GetDate());

	SET @registro_id = SCOPE_IDENTITY();
END;
GO
