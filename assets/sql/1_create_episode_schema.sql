CREATE TABLE episodes(
  guid TEXT PRIMARY KEY,
  title TEXT,
  description TEXT,
  link TEXT,
  publicationDate INTEGER,
  contentUrl TEXT,
  imageUrl TEXT,
  duration INTEGER,
  downloaded INTEGER
);