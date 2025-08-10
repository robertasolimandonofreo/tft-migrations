CREATE TABLE IF NOT EXISTS summoner_cache (
    puuid VARCHAR(78) PRIMARY KEY,
    game_name VARCHAR(32) NOT NULL,
    tag_line VARCHAR(8) NOT NULL,
    summoner_id VARCHAR(63),
    region VARCHAR(8) NOT NULL DEFAULT 'BR1',
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION update_summoner_cache_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER trigger_update_summoner_cache_timestamp
    BEFORE UPDATE ON summoner_cache
    FOR EACH ROW
    EXECUTE FUNCTION update_summoner_cache_timestamp();

CREATE INDEX IF NOT EXISTS idx_summoner_cache_name ON summoner_cache(game_name, tag_line);
CREATE INDEX IF NOT EXISTS idx_summoner_cache_region ON summoner_cache(region);
CREATE INDEX IF NOT EXISTS idx_summoner_cache_updated ON summoner_cache(last_updated);
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_summoner_cache_puuid_region 
ON summoner_cache(puuid, region);
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_summoner_cache_name_tag_region 
ON summoner_cache(game_name, tag_line, region);
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_summoner_cache_active 
ON summoner_cache(last_updated) 
WHERE last_updated > NOW() - INTERVAL '30 days';
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_summoner_cache_summoner_id 
ON summoner_cache(summoner_id) 
WHERE summoner_id IS NOT NULL;