import { UpdateQuery } from "mongoose";
import Parser from 'rss-parser';
import { parentPort } from 'worker_threads';
import dbConnect from '../db-connect';
import Episode from '../models/Episode';
import Podcast from '../models/Podcast';
import { feedUrls } from '../podcast-feed-urls.json';

console.log('Job running at', new Date().toISOString());
const parser = new Parser();

(async function () {
  await dbConnect();
  for (const feedUrl of feedUrls) {
    const feed = await parser.parseURL(feedUrl);
    console.log('UPDATING PODCAST', feed.title);
    const podcast = await Podcast.findOneAndUpdate(
      { feedUrl: feedUrl },
      {
        title: feed.title,
        description: feed.description,
        feedUrl: feedUrl,
        podcastLink: feed.link,
        imageLink: feed.image?.url || feed.itunes?.image,
        copyright: feed.copyright,
        numOfEps: feed.items.length,
      } as UpdateQuery<typeof Podcast>,
      {
        new: true,
        upsert: true,
      }
    );
    for (const episode of feed.items) {
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
          publicationDate:
            Date.parse(episode.isoDate!) || Date.parse(episode.pubDate!),
          audioUrl: episode.enclosure?.url,
          duration: episode.itunes?.duration,
        } as UpdateQuery<typeof Episode>,
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
