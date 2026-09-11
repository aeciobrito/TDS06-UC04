-- Tabela Pai
CREATE TABLE IF NOT EXISTS clientes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    enderco TEXT
);

-- Tabela Filho
CREATE TABLE IF NOT EXISTS pedidos
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cliente_id INTEGER NOT NULL,
    nome TEXT NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE
);

SELECT * FROM clientes;

-- Como inserir dados aqui?
INSERT INTO clientes (nome, email) VALUES
('Ana Silva', 'ana.silva@mail.com'),
('Bruno Souza', 'bruno.souza@mail.com'),
('Carlos Santos', 'carlos.santos@mail.com')
