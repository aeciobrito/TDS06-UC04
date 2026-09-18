CREATE DATABASE EstacionamentoDB;
GO

USE EstacionamentoDB;
GO

-- CRIAÇÃO DE TABELAS
CREATE TABLE Clientes
(
    id INTEGER IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(20)
);
GO

CREATE TABLE Veiculos
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    cliente_id INT NOT NULL,
    placa VARCHAR(100) NOT NULL UNIQUE,
    modelo VARCHAR(30) NOT NULL,
    cor VARCHAR(30),
    CONSTRAINT FK_Veiculo_Cliente FOREIGN KEY (cliente_id) REFERENCES Clientes (id) ON DELETE CASCADE
);
GO

CREATE TABLE Vagas
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    localizacao VARCHAR(30) NOT NULL,
    tipo VARCHAR(30) NOT NULL
);
GO

CREATE TABLE RegistrosEstacionamento
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    veiculo_id INTEGER NOT NULL,
    vaga_id INTEGER NOT NULL,
    data_hora_entrada DATETIME NOT NULL,
    data_hora_saida DATETIME,
    valor_total DECIMAL(10,2),
    CONSTRAINT FK_RegEstacionamento_Veiculo FOREIGN KEY (veiculo_id) REFERENCES Veiculos (id),
    CONSTRAINT FK_RegEstacionamento_Vaga FOREIGN KEY (vaga_id) REFERENCES Vagas (id)
);
GO

