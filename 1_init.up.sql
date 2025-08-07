CREATE TABLE summoners (
    id SERIAL PRIMARY KEY,
    puuid VARCHAR(78) UNIQUE NOT NULL,
    name VARCHAR(32) NOT NULL,
    region VARCHAR(8) NOT NULL,
    profile_icon_id INTEGER,
    summoner_level BIGINT,
    revision_date BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE matches (
    id SERIAL PRIMARY KEY,
    match_id VARCHAR(64) UNIQUE NOT NULL,
    region VARCHAR(8) NOT NULL,
    game_datetime BIGINT,
    queue_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE leagues (
    id SERIAL PRIMARY KEY,
    summoner_puuid VARCHAR(78) NOT NULL,
    tier VARCHAR(16),
    rank VARCHAR(4),
    league_points INTEGER,
    wins INTEGER,
    losses INTEGER,
    hot_streak BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_summoner FOREIGN KEY(summoner_puuid) REFERENCES summoners(puuid) ON DELETE CASCADE
);

CREATE INDEX idx_summoners_region ON summoners(region);
CREATE INDEX idx_matches_region ON matches(region);
CREATE INDEX idx_leagues_tier_rank ON leagues(tier, rank);