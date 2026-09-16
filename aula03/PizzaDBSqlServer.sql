CREATE DATABASE PizzariaDB;
GO

USE PizzariaDB;
GO

CREATE TABLE Clientes 
(
	id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	telefone VARCHAR(20) NOT NULL UNIQUE,
	endereco VARCHAR(255) NULL
); 
GO

-- 2 CLIENTES
INSERT INTO Clientes (nome, telefone, endereco) VALUES
('Fulano', '1199887755', 'Rua X'),
('Carlos', '5500998877', 'Tv ZZ');

SELECT * FROM Clientes
