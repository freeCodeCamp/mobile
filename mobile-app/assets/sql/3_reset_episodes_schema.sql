DROP TABLE episodes;

CREATE TABLE episodes(
  id TEXT,
  podcastId TEXT,
  title TEXT,
  description TEXT,
  publicationDate TEXT,
  contentUrl TEXT,
  duration TEXT,
  FOREIGN KEY(podcastId) REFERENCES podcasts(id),
  PRIMARY KEY (id, podcastId)
);