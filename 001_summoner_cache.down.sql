DROP TRIGGER IF EXISTS trigger_update_summoner_cache_timestamp ON summoner_cache;

DROP FUNCTION IF EXISTS update_summoner_cache_timestamp();

DROP INDEX IF EXISTS idx_summoner_cache_name;
DROP INDEX IF EXISTS idx_summoner_cache_region;
DROP INDEX IF EXISTS idx_summoner_cache_updated;

DROP TABLE IF EXISTS summoner_cache;