import Parser from 'rss-parser';
import { parentPort } from 'worker_threads';
import dbConnect from '../db-connect';
import Episode from '../models/Episode';
import PodcastModel, { Podcast } from '../models/Podcast';
import { feedUrls } from '../podcast-feed-urls.json';

console.log('Job running at', new Date().toISOString());
const parser = new Parser<
  Record<string, unknown>,
  { itunes?: { duration: string } }
>({
  headers: {
    Accept: 'application/rss+xml, text/xml; q=0.1',
  },
});

void (async function () {
  await dbConnect();
  for (const feedUrl of feedUrls) {
    const feed = await parser.parseURL(feedUrl);
    console.log('UPDATING PODCAST', feed.title);
    const podcast = await PodcastModel.findOneAndUpdate<Podcast>(
      { feedUrl: feedUrl },
      {
        title: feed.title,
        description: feed.description,
        feedUrl: feedUrl,
        podcastLink: feed.link,
        imageLink: feed.image?.url || feed.itunes?.image,
        copyright: feed.copyright as string,
        numOfEps: feed.items.length,
      },
      {
        new: true,
        upsert: true,
      }
    );
    for (const episode of feed.items) {
      const dateRaw = episode.isoDate ?? episode.pubDate ?? null;
      const episodeDate = dateRaw ? Date.parse(dateRaw) : null;
      await Episode.findOneAndUpdate(
        {
          podcastId: podcast._id,
          guid: episode.guid,
        },
        {
          guid: episode.guid,
          podcastId: podcast._id,
          title: episode.title,
          description: episode.content,
          publicationDate: episodeDate,
          audioUrl: episode.enclosure?.url,
          duration: episode.itunes?.duration,
        },
        {
          new: true,
          upsert: true,
        }
      );
    }
  }
  if (parentPort) {
    console.log('Job finished at', new Date().toISOString());
    parentPort.postMessage('done');
  } else {
    console.log('Job finished at', new Date().toISOString());
    process.exit(0);
  }
})();
