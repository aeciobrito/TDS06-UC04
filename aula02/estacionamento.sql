PRAGMA foreign_keys = ON;

-- CRIAÇÃO DE TABELAS
CREATE TABLE IF NOT EXISTS Clientes
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    cpf TEXT NOT NULL UNIQUE,
    telefone TEXT
);

CREATE TABLE IF NOT EXISTS Veiculos
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cliente_id INTEGER NOT NULL,
    placa TEXT NOT NULL UNIQUE,
    modelo TEXT NOT NULL,
    cor TEXT,
    FOREIGN KEY (cliente_id) REFERENCES Clientes (id) ON DELETE CASCADE
);

-- INSERÇÃO DE DADOS
INSERT INTO Clientes (nome, cpf, telefone) VALUES
('Joao', '11122233344', '11999887766'),
('Maria', '99922233344', '11444887766');


INSERT INTO Veiculos(cliente_id, placa, modelo, cor) VALUES
(1, 'JQS8877', 'Honda XRZ', 'Preto'),
(1, 'ABC1D23', 'Chevrolet Onix', 'Azul'),
(1, 'EFG4H56', 'Hyundai HB20', 'Cinza'),
(1, 'IJK7L89', 'Jeep Compass', 'Verde'),
(1, 'MNO0P12', 'Toyota Corolla Cross', 'Preto'),
(1, 'QRS3T45', 'Porsche Carrera', 'Vermelho'),
(1, 'UVW6X78', 'BMW M3', 'Roxo'),
(2, 'YZA9B01', 'BYD Dolphin', 'Branco');

-- CONSULTA DE DADOS
SELECT * FROM clientes;
SELECT * FROM Veiculos;

-- DELEÇÃO DE DADOS
PRAGMA foreign_keys = ON;
DELETE FROM Clientes WHERE id = 1;