ALTER TABLE leagues ADD COLUMN IF NOT EXISTS league_id VARCHAR(64);
ALTER TABLE leagues ADD COLUMN IF NOT EXISTS queue_type VARCHAR(32);
ALTER TABLE leagues ADD COLUMN IF NOT EXISTS veteran BOOLEAN DEFAULT FALSE;
ALTER TABLE leagues ADD COLUMN IF NOT EXISTS fresh_blood BOOLEAN DEFAULT FALSE;
ALTER TABLE leagues ADD COLUMN IF NOT EXISTS inactive BOOLEAN DEFAULT FALSE;
ALTER TABLE leagues ADD COLUMN IF NOT EXISTS summoner_name VARCHAR(32);

CREATE TABLE IF NOT EXISTS high_tier_leagues (
    id SERIAL PRIMARY KEY,
    league_id VARCHAR(64) UNIQUE NOT NULL,
    tier VARCHAR(16) NOT NULL,
    name VARCHAR(128) NOT NULL,
    queue VARCHAR(32) NOT NULL,
    region VARCHAR(8) NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS mini_series (
    id SERIAL PRIMARY KEY,
    summoner_puuid VARCHAR(78) NOT NULL,
    target INTEGER NOT NULL,
    wins INTEGER NOT NULL,
    losses INTEGER NOT NULL,
    progress VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_mini_series_summoner FOREIGN KEY(summoner_puuid) REFERENCES summoners(puuid) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_leagues_league_id ON leagues(league_id);
CREATE INDEX IF NOT EXISTS idx_leagues_queue_type ON leagues(queue_type);
CREATE INDEX IF NOT EXISTS idx_high_tier_leagues_tier_region ON high_tier_leagues(tier, region);
CREATE INDEX IF NOT EXISTS idx_high_tier_leagues_league_id ON high_tier_leagues(league_id);
CREATE INDEX IF NOT EXISTS idx_mini_series_summoner_puuid ON mini_series(summoner_puuid);