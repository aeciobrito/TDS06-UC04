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
('Fulano Cicrano', '11111111111', '11911111111'),
('Ana Carolina', '22222222222', '11922222222'),
('Maria Eduarda', '33333333333', '11933333333'),
('Carlos Eduardo', '44444444444', '11944444444');
 
INSERT INTO Veiculos (cliente_id, placa, modelo, cor) VALUES
(1, 'ABC1D23', 'Chevrolet Onix', 'Azul'),
(2, 'EFG4H56', 'Hyundai HB20', 'Cinza'),
(2, 'IJK7L89', 'Jeep Compass', 'Verde'),
(3, 'MNO0P12', 'Toyota Corolla Cross', 'Preto'),
(3, 'QRS3T45', 'Porsche Carrera', 'Vermelho'),
(3, 'UVW6X78', 'BMW M3', 'Roxo'),
(4, 'YZA9B01', 'BYD Dolphin', 'Branco');

/* Ativiade:
- Adicione as tabelas:
    - 'Vagas'(localizacao, tipo)
    - 'RegistrosEstacionamento' (veiculo, vaga, data_hora_entrada/saida, valor_toal)
- Cadastre 4 vagas e 3 registros de estadia (um sem data de saída)
- Escreva as consultas:
    - Identificar quais vagas estão ocupadas no momento
    - Listar vagas que estão livres */

CREATE TABLE IF NOT EXISTS Vagas
(
    id  INTEGER PRIMARY KEY AUTOINCREMENT,
    localizacao TEXT NOT NULL,
    tipo TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS RegistrosEstacionamento
(
    id  INTEGER PRIMARY KEY AUTOINCREMENT,
    veiculo_id INTEGER NOT NULL,
    vaga_id INTEGER NOT NULL,
    data_hora_entrada TEXT NOT NULL,
    data_hora_saida TEXT,
    valor_total REAL,
    FOREIGN KEY (veiculo_id) REFERENCES Veiculos (id) ON DELETE RESTRICT,
    FOREIGN KEY (vaga_id) REFERENCES Vagas (id) ON DELETE RESTRICT
);


-- INSERÇÃO DE VAGAS (4 VAGAS)
INSERT INTO Vagas (localizacao, tipo) VALUES
('Piso 1 - A1', 'Carro'),
('Piso 1 - A2', 'Carro'),
('Piso 2 - B1', 'Moto'),
('Piso 2 - B2', 'Carro');

-- INSERÇÃO DE REGISTROS (3 ESTADIAS - 1 EM ABERTO)
INSERT INTO RegistrosEstacionamento (veiculo_id, vaga_id, data_hora_entrada, data_hora_saida, valor_total) VALUES
(1, 1, '2026-09-14 08:00:00', '2026-09-14 12:00:00', 20.00), -- Finalizado
(2, 2, '2026-09-14 14:00:00', '2026-09-14 16:30:00', 15.50), -- Finalizado
(3, 4, '2026-09-14 19:00:00', NULL, NULL);                  -- Sem data de saída

-- VAGAS OCUPADAS
SELECT Vagas.*
FROM RegistrosEstacionamento
INNER JOIN Vagas ON RegistrosEstacionamento.vaga_id = Vagas.id
WHERE RegistrosEstacionamento.data_hora_saida IS NULL;

SELECT Vagas.*
FROM Vagas
INNER JOIN RegistrosEstacionamento ON RegistrosEstacionamento.vaga_id = Vagas.id
WHERE RegistrosEstacionamento.data_hora_saida IS NULL;

SELECT *
FROM Vagas
WHERE id IN (
    SELECT vaga_id
    FROM RegistrosEstacionamento
    WHERE data_hora_saida IS NULL
);

-- VAGAS VAZIAS:
SELECT *
FROM Vagas
WHERE id NOT IN (
    SELECT vaga_id
    FROM RegistrosEstacionamento
    WHERE data_hora_saida IS NULL
);

SELECT Vagas.*
FROM Vagas
LEFT JOIN RegistrosEstacionamento re ON re.vaga_id = Vagas.id
AND re.data_hora_saida IS NULL
WHERE re.ID IS NULL;



SELECT * FROM RegistrosEstacionamento;






















