# Documentação do Migrations - TFT Migrations

## Visão Geral

Sistema de migrações de banco de dados PostgreSQL utilizando golang-migrate para controle de versão e evolução do schema do banco de dados do TFT.

## Stack Tecnológico

- **Migration Tool**: golang-migrate v4.16.2
- **Database**: PostgreSQL 17
- **Container**: Alpine Linux 3.20
- **Shell**: Bash scripting

## Estrutura de Diretórios

```
tft-migrations/
├── Dockerfile              # Container para execução das migrações
├── entrypoint.sh           # Script de inicialização
├── *.up.sql               # Migrações de subida
├── *.down.sql             # Migrações de rollback
└── README.md              # Documentação
```

## Schema da Tabela summoner_cache

### Campos

| Campo | Tipo | Constraints | Descrição |
|-------|------|-------------|-----------|
| `puuid` | VARCHAR(78) | PRIMARY KEY | Identificador único do jogador Riot |
| `game_name` | VARCHAR(32) | NOT NULL | Nome do jogador no jogo |
| `tag_line` | VARCHAR(8) | NOT NULL | Tag do jogador (ex: BR1) |
| `summoner_id` | VARCHAR(63) | NULLABLE | ID do summoner na região |
| `region` | VARCHAR(8) | NOT NULL, DEFAULT 'BR1' | Região do servidor |
| `last_updated` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Última atualização |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Data de criação |

### Índices

- **Primary Key**: `puuid`
- **idx_summoner_cache_name**: (game_name, tag_line) - Busca por nome
- **idx_summoner_cache_region**: (region) - Filtro por região
- **idx_summoner_cache_updated**: (last_updated) - Queries por data

### Triggers

- **update_summoner_cache_timestamp**: Atualiza automaticamente `last_updated` em UPDATEs


### Etapas de Execução

1. **Debug Info**: Exibe variáveis de ambiente
2. **Connectivity Test**: Testa ping e porta do PostgreSQL
3. **Database Connection**: Verifica conexão com o banco
4. **Migration Execution**: Executa migrações pendentes

## Configuração

### Variáveis de Ambiente

```bash
# PostgreSQL
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_USER=tft_user
POSTGRES_PASSWORD=tft_password
POSTGRES_DB=tft_database
POSTGRES_SSL_MODE=disable
```

## Comandos Migrate

### Execução Manual

```bash
# Aplicar todas as migrações
migrate -path ./migrations -database "postgres://user:pass@host:port/db?sslmode=disable" up

# Aplicar N migrações
migrate -path ./migrations -database "postgres://user:pass@host:port/db?sslmode=disable" up 2

# Reverter 1 migração
migrate -path ./migrations -database "postgres://user:pass@host:port/db?sslmode=disable" down 1

# Ir para versão específica
migrate -path ./migrations -database "postgres://user:pass@host:port/db?sslmode=disable" goto 1

# Forçar versão (sem executar migração)
migrate -path ./migrations -database "postgres://user:pass@host:port/db?sslmode=disable" force 1

# Verificar versão atual
migrate -path ./migrations -database "postgres://user:pass@host:port/db?sslmode=disable" version
```

## Boas Práticas

### Nomenclatura de Arquivos

```
001_initial_schema.up.sql
001_initial_schema.down.sql
002_add_indexes.up.sql
002_add_indexes.down.sql
003_add_triggers.up.sql
003_add_triggers.down.sql
```

### Estrutura de Migração

1. **Sempre reversível**: Todo `.up.sql` deve ter `.down.sql`
2. **Idempotente**: Usar `IF EXISTS` e `IF NOT EXISTS`
3. **Transacional**: Migrações são executadas em transações
4. **Documentada**: Comentários explicando mudanças complexas

### Migração Segura

```sql
-- Exemplo de migração segura
BEGIN;

-- Adicionar coluna com valor padrão
ALTER TABLE summoner_cache 
ADD COLUMN IF NOT EXISTS new_field VARCHAR(50) DEFAULT 'default_value';

-- Criar índice concorrentemente (em produção)
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_new_field 
ON summoner_cache(new_field);

COMMIT;
```

### Logs de Debug

```bash
# Executar com debug
migrate -path ./migrations -database "postgres://..." -verbose up

# Verificar logs do container
docker logs tft-migrations
```


## Monitoramento

### Tabela de Controle

```sql
-- Verificar status das migrações
SELECT * FROM schema_migrations;

-- Verificar última migração aplicada
SELECT version FROM schema_migrations ORDER BY version DESC LIMIT 1;
```