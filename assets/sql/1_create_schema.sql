CREATE TABLE podcasts(
  id TEXT PRIMARY KEY,
  url TEXT,
  link TEXT,
  title TEXT,
  description TEXT,
  image TEXT,
  copyright TEXT
);

CREATE TABLE episodes(
  guid TEXT,
  podcastId TEXT,
  title TEXT,
  description TEXT,
  link TEXT,
  publicationDate INTEGER,
  contentUrl TEXT,
  imageUrl TEXT,
  duration INTEGER,
  downloaded INTEGER,
  FOREIGN KEY(podcastId) REFERENCES podcasts(id),
  PRIMARY KEY (guid, podcastId)
);