CREATE TABLE IF NOT EXISTS Clientes
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL, 
    telefone TEXT NOT NULL UNIQUE,
    endereco TEXT
);

INSERT INTO Clientes (nome, telefone, endereco) VALUES
('Fulano da Silva', '1199887766', 'Rua B'),
('Beltrano de Souza', '1188997755', 'Av 7'),
('Ze Neto', '11557788844', 'Tv X');

CREATE TABLE IF NOT EXISTS Pizzas
(
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   sabor TEXT NOT NULL UNIQUE,
   ingredientes TEXT,
   valor REAL CHECK (valor > 0)
);

CREATE TABLE IF NOT EXISTS Pedidos
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cliente_id INTEGER,
    data_hora TEXT,
    status TEXT DEFAULT 'Em preparo',
    valor_total REAL DEFAULT 0.0,
    FOREIGN KEY (cliente_id) REFERENCES Clientes (id) ON DELETE SET NULL
);

INSERT INTO Pizzas(sabor, ingredientes, valor) VALUES
('Calabresa', 'Molho de tomate, mussarela, calabresa, cebola', 45.00),
('Quatro queijos', 'Provolone, mussarela, gorgonzola, parmesão', 55.00);

INSERT INTO Pedidos(cliente_id, data_hora, status, valor_total) VALUES
(1, '2026-01-05', 'Entregue', 45.00),
(2, '2026-02-25', 'Cancelado', 65.00),
(1, '2026-01-05', 'Em preparo', 55.00);

SELECT * FROM Clientes;
SELECT * FROM Pedidos;
SELECT * FROM Pizzas;

-- Faça uma consulta, que mostre os pedidos com o nome do cliente
SELECT Pedidos.id, Clientes.nome, Clientes.endereco, Pedidos.status, Pedidos.valor_total
FROM Pedidos
LEFT JOIN Clientes ON Pedidos.cliente_id = Clientes.id;