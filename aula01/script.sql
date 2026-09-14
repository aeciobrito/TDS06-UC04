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

INSERT INTO Pedidos(cliente_id, data_hora, valor_total) VALUES
(3, '2026-09-09', 0.00);

-- SELECT * FROM Clientes;
SELECT * FROM Pedidos;
SELECT * FROM Pizzas;
SELECT * FROM Pedido_Itens;


-- 1. Crie uma tabela associativa de pedidos_pizza (o nome pode ser 'Pedido_Itens')
-- 1.1 Proriedades: pedido_id, pizza_id, quantidade, valor_unitario
CREATE TABLE IF NOT EXISTS Pedido_Itens
(
    pedido_id INTEGER NOT NULL,
    pizza_id INTEGER NOT NULL,
    quantidade INTEGER NOT NULL DEFAULT 1 CHECK (quantidade > 0),
    valor_unitario REAL NOT NULL,
    PRIMARY KEY (pedido_id, pizza_id),
    FOREIGN KEY (pedido_id) REFERENCES Pedidos (id) ON DELETE CASCADE,
    FOREIGN KEY (pizza_id) REFERENCES Pizzas (id) ON DELETE RESTRICT
);

-- 2. Insira ao menos 2 itens no pedido 1
INSERT INTO Pedido_Itens (pedido_id, pizza_id, quantidade, valor_unitario) VALUES
(1, 1, 4, 45.00),
(1, 2, 1, 55.00),
(2, 1, 1, 45.00),
(3, 2, 3, 55.00);

-- 3. Realize uma consulta, exibindo: 
-- Pedido.Id, Pizza.Sabor, Pedido_Itens.quantidade, Pedido_Itens.precoUnitario
SELECT Pedidos.id AS id_pedido, Pizzas.sabor, Pedido_Itens.quantidade, Pedido_Itens.valor_unitario
FROM Pedidos
INNER JOIN Pedido_Itens ON Pedido_Itens.pedido_id = Pedidos.id
INNER JOIN Pizzas ON Pedido_Itens.pizza_id = Pizzas.id;