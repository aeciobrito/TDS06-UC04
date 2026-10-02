
CREATE DATABASE HospedagemDB;
GO

USE HospedagemDB;
GO

-- ----------------------------------------------------------------------------
-- 1. CRIAÇÃO DAS TABELAS (DDL)
-- ----------------------------------------------------------------------------

-- Tabela de Clientes
CREATE TABLE dbo.Clientes (
    id INT IDENTITY(1,1) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    rg VARCHAR(20) NOT NULL,
    endereco VARCHAR(150) NULL,
    bairro VARCHAR(60) NULL,
    cidade VARCHAR(60) NULL,
    estado CHAR(2) NOT NULL,
    cep VARCHAR(10) NULL,
    data_nascimento DATE NOT NULL,
    CONSTRAINT PK_Clientes PRIMARY KEY CLUSTERED (id),
    CONSTRAINT UQ_Clientes_RG UNIQUE (rg)
);
GO

-- Tabela de Telefones do Cliente (Entidade Fraca / 1:N)
CREATE TABLE dbo.Telefones (
    cliente_id INT NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    tipo VARCHAR(20) NOT NULL CONSTRAINT DF_Telefones_Tipo DEFAULT 'Celular',
    CONSTRAINT PK_Telefones PRIMARY KEY CLUSTERED (cliente_id, telefone),
    CONSTRAINT FK_Telefones_Clientes 
        FOREIGN KEY (cliente_id) REFERENCES dbo.Clientes (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

-- Tabela de Chalés
CREATE TABLE dbo.Chales (
    id INT IDENTITY(1,1) NOT NULL,
    localizacao VARCHAR(100) NOT NULL,
    capacidade INT NOT NULL CONSTRAINT CK_Chales_Capacidade CHECK (capacidade > 0),
    valor_alta_estacao DECIMAL(10,2) NOT NULL CONSTRAINT CK_Chales_ValorAlta CHECK (valor_alta_estacao > 0),
    valor_baixa_estacao DECIMAL(10,2) NOT NULL CONSTRAINT CK_Chales_ValorBaixa CHECK (valor_baixa_estacao > 0),
    CONSTRAINT PK_Chales PRIMARY KEY CLUSTERED (id)
);
GO

-- Tabela de Itens / Comodidades do Chalé
CREATE TABLE dbo.Itens (
    id INT IDENTITY(1,1) NOT NULL,
    nome VARCHAR(50) NOT NULL,
    descricao VARCHAR(200) NULL,
    CONSTRAINT PK_Itens PRIMARY KEY CLUSTERED (id),
    CONSTRAINT UQ_Itens_Nome UNIQUE (nome)
);
GO

-- Tabela Associativa N:N (Chale_Itens)
CREATE TABLE dbo.Chale_Itens (
    chale_id INT NOT NULL,
    item_id INT NOT NULL,
    CONSTRAINT PK_Chale_Itens PRIMARY KEY CLUSTERED (chale_id, item_id),
    CONSTRAINT FK_ChaleItens_Chales 
        FOREIGN KEY (chale_id) REFERENCES dbo.Chales (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_ChaleItens_Itens 
        FOREIGN KEY (item_id) REFERENCES dbo.Itens (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

-- Tabela de Serviços Adicionais
CREATE TABLE dbo.Servicos (
    id INT IDENTITY(1,1) NOT NULL,
    nome VARCHAR(60) NOT NULL,
    valor DECIMAL(10,2) NOT NULL CONSTRAINT CK_Servicos_Valor CHECK (valor >= 0),
    CONSTRAINT PK_Servicos PRIMARY KEY CLUSTERED (id),
    CONSTRAINT UQ_Servicos_Nome UNIQUE (nome)
);
GO

-- Tabela de Hospedagens (Contrato Central)
CREATE TABLE dbo.Hospedagens (
    id INT IDENTITY(1,1) NOT NULL,
    cliente_id INT NOT NULL,
    chale_id INT NOT NULL,
    estado VARCHAR(20) NOT NULL CONSTRAINT DF_Hospedagens_Estado DEFAULT 'Aberta',
    data_inicio DATETIME NOT NULL,
    data_fim DATETIME NOT NULL,
    qtd_pessoas INT NOT NULL CONSTRAINT CK_Hospedagens_QtdPessoas CHECK (qtd_pessoas > 0),
    desconto DECIMAL(5,2) NOT NULL CONSTRAINT DF_Hospedagens_Desconto DEFAULT 0.00,
    valor_final DECIMAL(10,2) NULL,
    CONSTRAINT PK_Hospedagens PRIMARY KEY CLUSTERED (id),
    CONSTRAINT FK_Hospedagens_Clientes 
        FOREIGN KEY (cliente_id) REFERENCES dbo.Clientes (id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    CONSTRAINT FK_Hospedagens_Chales 
        FOREIGN KEY (chale_id) REFERENCES dbo.Chales (id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    CONSTRAINT CK_Hospedagens_Datas CHECK (data_fim >= data_inicio),
    CONSTRAINT CK_Hospedagens_Desconto CHECK (desconto >= 0.00 AND desconto <= 100.00)
);
GO

-- Tabela de Serviços Consumidos na Hospedagem (N:N com Histórico de Data e Preço)
CREATE TABLE dbo.Hospedagem_Servicos (
    hospedagem_id INT NOT NULL,
    servico_id INT NOT NULL,
    data_servico DATETIME NOT NULL,
    valor_servico DECIMAL(10,2) NOT NULL CONSTRAINT CK_HospServ_Valor CHECK (valor_servico >= 0),
    CONSTRAINT PK_Hospedagem_Servicos PRIMARY KEY CLUSTERED (hospedagem_id, servico_id, data_servico),
    CONSTRAINT FK_HospServ_Hospedagens 
        FOREIGN KEY (hospedagem_id) REFERENCES dbo.Hospedagens (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_HospServ_Servicos 
        FOREIGN KEY (servico_id) REFERENCES dbo.Servicos (id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
);
GO

-- ----------------------------------------------------------------------------
-- 2. STORED PROCEDURES DE NEGÓCIO (Indicador 2)
-- ----------------------------------------------------------------------------

-- Procedure 1: Adicionar Serviço Consumido com Captura do Preço Vigente
CREATE OR ALTER PROCEDURE dbo.sp_AdicionarServicoHospedagem
    @hospedagem_id INT,
    @servico_id INT,
    @data_servico DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @preco_vigente DECIMAL(10,2);

        IF @data_servico IS NULL
            SET @data_servico = GETDATE();

        -- Busca valor de catálogo do serviço
        SELECT @preco_vigente = valor FROM dbo.Servicos WHERE id = @servico_id;

        IF @preco_vigente IS NULL
        BEGIN
            RAISERROR('Serviço informado não cadastrado.', 16, 1);
            RETURN;
        END

        INSERT INTO dbo.Hospedagem_Servicos (hospedagem_id, servico_id, data_servico, valor_servico)
        VALUES (@hospedagem_id, @servico_id, @data_servico, @preco_vigente);
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

-- Procedure 2: Finalizar Hospedagem e Calcular Conta
CREATE OR ALTER PROCEDURE dbo.sp_FinalizarHospedagem
    @hospedagem_id INT,
    @alta_estacao BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @chale_id INT, @inicio DATETIME, @fim DATETIME, @diarias INT;
        DECLARE @tarifa_diaria DECIMAL(10,2), @total_diarias DECIMAL(10,2), @total_servicos DECIMAL(10,2);
        DECLARE @desconto DECIMAL(5,2), @valor_bruto DECIMAL(10,2), @valor_final DECIMAL(10,2);

        SELECT 
            @chale_id = h.chale_id,
            @inicio = h.data_inicio,
            @fim = h.data_fim,
            @desconto = h.desconto,
            @tarifa_diaria = CASE WHEN @alta_estacao = 1 THEN c.valor_alta_estacao ELSE c.valor_baixa_estacao END
        FROM dbo.Hospedagens h
        INNER JOIN dbo.Chales c ON h.chale_id = c.id
        WHERE h.id = @hospedagem_id;

        IF @chale_id IS NULL
        BEGIN
            RAISERROR('Hospedagem informada não existe.', 16, 1);
            RETURN;
        END

        -- Calcula diárias (mínimo de 1 diária)
        SET @diarias = DATEDIFF(DAY, @inicio, @fim);
        IF @diarias < 1 SET @diarias = 1;

        SET @total_diarias = @diarias * @tarifa_diaria;

        -- Soma serviços adicionais
        SELECT @total_servicos = ISNULL(SUM(valor_servico), 0.00)
        FROM dbo.Hospedagem_Servicos
        WHERE hospedagem_id = @hospedagem_id;

        SET @valor_bruto = @total_diarias + @total_servicos;
        SET @valor_final = @valor_bruto - (@valor_bruto * (@desconto / 100.0));

        -- Atualiza hospedagem com status e valor final
        UPDATE dbo.Hospedagens
        SET estado = 'Encerrada',
            valor_final = @valor_final
        WHERE id = @hospedagem_id;

        SELECT 
            @hospedagem_id AS hospedagem_id,
            @diarias AS diarias,
            @total_diarias AS total_diarias,
            @total_servicos AS total_servicos,
            @desconto AS desconto_aplicado,
            @valor_final AS total_a_pagar;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

-- ----------------------------------------------------------------------------
-- 3. CARGA DE DADOS DE TESTE (DML)
-- ----------------------------------------------------------------------------

-- Clientes
INSERT INTO dbo.Clientes (nome, rg, endereco, bairro, cidade, estado, cep, data_nascimento) VALUES
('Lucas Almeida', '12.345.678-9', 'Rua das Palmeiras, 10', 'Jardins', 'São Paulo', 'SP', '01400-000', '1990-05-15'),
('Camila Rodrigues', '98.765.432-1', 'Av. Afonso Pena, 500', 'Centro', 'Belo Horizonte', 'MG', '30130-000', '1988-11-20');

-- Telefones
INSERT INTO dbo.Telefones (cliente_id, telefone, tipo) VALUES
(1, '(11) 98888-1111', 'Celular'),
(1, '(11) 3214-5555', 'Residencial'),
(2, '(31) 97777-2222', 'Celular');

-- Chalés
INSERT INTO dbo.Chales (localizacao, capacidade, valor_alta_estacao, valor_baixa_estacao) VALUES
('Bosque das Araucárias - Chalé 01', 4, 450.00, 280.00),
('Vista da Montanha - Chalé 02', 6, 650.00, 420.00),
('Canto dos Pássaros - Chalé 03', 2, 320.00, 200.00);

-- Comodidades (Itens)
INSERT INTO dbo.Itens (nome, descricao) VALUES
('Lareira', 'Lareira a lenha no quarto principal'),
('Hidromassagem', 'Banheira com vista panorâmica'),
('Wi-Fi Fibra', 'Internet de alta velocidade');

-- Associação Chale_Itens
INSERT INTO dbo.Chale_Itens (chale_id, item_id) VALUES
(1, 1),
(1, 3),
(2, 1),
(2, 2),
(2, 3),
(3, 3);

-- Serviços do Catálogo
INSERT INTO dbo.Servicos (nome, valor) VALUES
('Café da Manhã no Quarto', 65.00),
('Passeio a Cavalo', 120.00),
('Massagem Relaxante', 180.00);

-- Hospedagem de Lucas Almeida no Chalé 01
INSERT INTO dbo.Hospedagens (cliente_id, chale_id, estado, data_inicio, data_fim, qtd_pessoas, desconto)
VALUES (1, 1, 'Aberta', '2025-07-10 14:00:00', '2025-07-13 12:00:00', 3, 5.00);

-- Adicionando serviços consumidos
EXEC dbo.sp_AdicionarServicoHospedagem @hospedagem_id = 1, @servico_id = 1; -- Café da manhã
EXEC dbo.sp_AdicionarServicoHospedagem @hospedagem_id = 1, @servico_id = 2; -- Passeio a cavalo
GO

-- Fechando a conta
EXEC dbo.sp_FinalizarHospedagem @hospedagem_id = 1, @alta_estacao = 1;
GO

-- ----------------------------------------------------------------------------
-- 4. CONSULTA RELATÓRIO CONSOLIDADO
-- ----------------------------------------------------------------------------

SELECT 
    h.id AS hospedagem_id,
    c.nome AS hospede,
    ch.localizacao AS chale,
    h.data_inicio,
    h.data_fim,
    h.estado,
    h.valor_final AS total_final_pago
FROM dbo.Hospedagens h
INNER JOIN dbo.Clientes c ON h.cliente_id = c.id
INNER JOIN dbo.Chales ch ON h.chale_id = ch.id;
GO