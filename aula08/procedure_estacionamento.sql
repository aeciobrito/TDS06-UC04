USE EstacionamentoDB;
GO

--DECLARE @entrada DATETIME = '2026-09-24 14:00:00';
--DECLARE @saida DATETIME = '2026-09-24 16:15:00';

--DECLARE @minutos INT = DATEDIFF(MINUTE, @entrada, @saida); --135min
--DECLARE @horasCobradas INT = CEILING(@minutos/60.0); 

--DECLARE @tarifaPrimeiraHora DECIMAL(10,2) = 15.00;
--DECLARE @tarifaAdicional DECIMAL(10,2) = 10.00;
--DECLARE @total DECIMAL(10, 2);

--IF @minutos <= 15
--	SET @total = 0.00; -- Tolerância
--ELSE IF @horasCobradas = 1
--	SET @total = @tarifaPrimeiraHora
--ELSE
--	SET @total = @tarifaPrimeiraHora + (@tarifaAdicional * (@horasCobradas - 1));

-- VISUALIZAÇÃO DO RESULTADO
--SELECT 
--	@minutos AS Minutos,
--	@horasCobradas AS Horas,
--	@total AS TotalAPagar;

-- CRIAÇÃO DE SOTRED PROCEDURE

CREATE OR ALTER PROCEDURE sp_RegistrarSaidaVeiculo
	@registro_id INT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		-- código que pode dar errado
		DECLARE @entrada DATETIME, @saida DATETIME, @minutos INT, @horasCobradas INT, @total DECIMAL(10, 2);		
		DECLARE @tarifaPrimeiraHora DECIMAL(10,2) = 15.00;
		DECLARE @tarifaAdicional DECIMAL(10,2) = 10.00;

		SELECT @entrada = data_hora_entrada, @saida = data_hora_saida
		FROM RegistrosEstacionamento WHERE id = @registro_id;

		IF @entrada IS NULL
			THROW 50001, 'Registro de estacionamento não encontrado.', 1;

		IF @saida IS NOT NULL
			THROW 50002, 'Este veículo já registrou a saída', 1;

		SET @saida = GETDATE();
		SET @minutos = DATEDIFF(MINUTE, @entrada, @saida);
		SET @horasCobradas = CEILING(@minutos/60.0);

		IF @minutos <= 15
			SET @total = 0.00; -- Tolerância
		ELSE IF @horasCobradas = 1
			SET @total = @tarifaPrimeiraHora
		ELSE
			SET @total = @tarifaPrimeiraHora + (@tarifaAdicional * (@horasCobradas - 1));

		UPDATE RegistrosEstacionamento
		SET data_hora_saida = @saida, valor_total = @total
		WHERE id = @registro_id;
	END TRY
	BEGIN CATCH
		-- captura o erro, faz rollback, lança o erro com THROW
		THROW;
	END CATCH
END;
GO

