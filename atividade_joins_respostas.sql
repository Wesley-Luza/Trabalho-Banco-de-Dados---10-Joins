-- Atividade de SQL com JOINS — 

CREATE TABLE aluno (id INTEGER PRIMARY KEY, nome VARCHAR(100) NOT NULL);
CREATE TABLE curso (id INTEGER PRIMARY KEY, nome VARCHAR(80) UNIQUE NOT NULL);
CREATE TABLE instrutor (
  id INTEGER PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  supervisor_id INTEGER NULL REFERENCES instrutor(id) ON DELETE SET NULL
);
CREATE TABLE oferta (
  id INTEGER PRIMARY KEY,
  curso_id INTEGER NOT NULL REFERENCES curso(id) ON DELETE RESTRICT,
  instrutor_id INTEGER NOT NULL REFERENCES instrutor(id) ON DELETE RESTRICT,
  inicio DATE NOT NULL,
  fim DATE NOT NULL
);
CREATE TABLE matricula (
  id INTEGER PRIMARY KEY,
  aluno_id INTEGER NOT NULL REFERENCES aluno(id) ON DELETE RESTRICT,
  oferta_id INTEGER NOT NULL REFERENCES oferta(id) ON DELETE RESTRICT,
  data_matricula DATE NOT NULL,
  situacao VARCHAR(20) NOT NULL
);
CREATE TABLE pagamento (
  id INTEGER PRIMARY KEY,
  matricula_id INTEGER NOT NULL REFERENCES matricula(id) ON DELETE RESTRICT,
  valor NUMERIC(10,2) NOT NULL,
  data_pgto DATE NOT NULL,
  metodo VARCHAR(20) NOT NULL
);

INSERT INTO aluno (id, nome) VALUES (1,'Alice'),(2,'Diego'),(3,'Beatriz'),(4,'Carlos');
INSERT INTO curso (id, nome) VALUES
  (1,'Lógica de Programação'),(2,'HTML e CSS'),(3,'Introdução a Bancos de Dados'),(4,'Python Básico');
INSERT INTO instrutor (id, nome, supervisor_id) VALUES
  (1,'Ana',NULL),(2,'Bruno',1),(3,'Carla',2);
INSERT INTO oferta (id, curso_id, instrutor_id, inicio, fim) VALUES
  (1,1,1,'2025-08-01','2025-10-31'),
  (2,2,2,'2025-08-15','2025-09-30'),
  (3,3,2,'2025-09-01','2025-11-15'),
  (4,4,3,'2025-09-20','2025-12-01'),
  (5,3,3,'2025-10-05','2025-12-20');
INSERT INTO matricula (id, aluno_id, oferta_id, data_matricula, situacao) VALUES
  (1,1,1,'2025-08-02','ativa'),
  (2,1,3,'2025-09-02','ativa'),
  (3,2,2,'2025-08-16','ativa'),
  (4,3,3,'2025-09-05','trancada'),
  (5,4,1,'2025-08-05','ativa');
INSERT INTO pagamento (id, matricula_id, valor, data_pgto, metodo) VALUES
  (1,1,200.00,'2025-08-10','PIX'),
  (2,3,180.00,'2025-08-20','Boleto'),
  (3,4,180.00,'2025-09-10','Cartao');

SELECT 
    a.nome AS aluno,
    c.nome AS curso,
    m.data_matricula
FROM matricula m
INNER JOIN aluno a ON a.id = m.aluno_id
INNER JOIN oferta o ON o.id = m.oferta_id
INNER JOIN curso c ON c.id = o.curso_id
ORDER BY a.nome ASC, m.data_matricula ASC;

SELECT 
    m.id AS matricula,
    a.nome AS aluno,
    c.nome AS curso,
    i.nome AS instrutor,
    m.situacao
FROM matricula m
INNER JOIN aluno a ON a.id = m.aluno_id
INNER JOIN oferta o ON o.id = m.oferta_id
INNER JOIN curso c ON c.id = o.curso_id
INNER JOIN instrutor i ON i.id = o.instrutor_id
ORDER BY c.nome ASC, a.nome ASC;

SELECT 
c.nome AS curso
FROM curso c
LEFT JOIN oferta o ON c.id = o.curso_id
WHERE o.id IS NULL
ORDER BY c.nome ASC;

SELECT 
    o.id AS oferta,
    c.nome AS curso,
    i.nome AS instrutor
FROM oferta o
JOIN curso c ON c.id = o.curso_id
JOIN instrutor i ON i.id = o.instrutor_id
LEFT JOIN matricula m ON m.oferta_id = o.id
WHERE m.id IS NULL
ORDER BY o.id ASC;

SELECT 
    a.nome AS aluno,
    m.oferta_id AS oferta,
    m.situacao AS situacao
FROM aluno a
LEFT JOIN matricula m ON m.aluno_id = a.id
ORDER BY a.nome ASC;

SELECT 
    a.nome AS aluno,
    m.oferta_id AS oferta,
    m.situacao AS situacao
FROM matricula m
RIGHT JOIN aluno a ON m.aluno_id = a.id
ORDER BY a.nome ASC;

SELECT 
    a.nome AS aluno,
    c.nome AS curso,
    i.nome AS instrutor
FROM matricula m
JOIN aluno a ON a.id = m.aluno_id
JOIN oferta o ON o.id = m.oferta_id
JOIN curso c ON c.id = o.curso_id
JOIN instrutor i ON i.id = o.instrutor_id
WHERE c.nome = 'Introdução a Bancos de Dados';

SELECT 
    a.nome AS aluno,
    c.nome AS curso,
    p.metodo,
    p.data_pgto
FROM pagamento p
JOIN matricula m ON m.id = p.matricula_id
JOIN aluno a ON a.id = m.aluno_id
JOIN oferta o ON o.id = m.oferta_id
JOIN curso c ON c.id = o.curso_id
WHERE p.metodo = 'PIX'
ORDER BY p.data_pgto ASC;

SELECT 
    o.id AS oferta,
    c.nome AS curso,
    i.nome AS instrutor,
    o.inicio
FROM oferta o
JOIN curso c ON c.id = o.curso_id
JOIN instrutor i ON i.id = o.instrutor_id
WHERE o.inicio BETWEEN '2025-08-01' AND '2025-09-30'
ORDER BY o.inicio ASC;

SELECT 
    i.nome AS instrutor,
    s.nome AS supervisor
FROM instrutor i
LEFT JOIN instrutor s ON i.supervisor_id = s.id;
