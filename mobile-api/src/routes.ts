import express, { Request, Response } from 'express';
import Parser from 'rss-parser';
import Episode from './models/Episode';
import Podcast from './models/Podcast';
import { feedUrls } from './podcast-feed-urls.json';
import { UpdateQuery } from "mongoose";

const router = express.Router();
const parser = new Parser();

router.get('/', async (req: Request, res: Response) => {
  const podcasts = await Podcast.find({});
  if (feedUrls.length !== podcasts.length) {
    console.log('Fetching missing podcasts');
    for (const url of feedUrls) {
      let feed = await parser.parseURL(url);
      console.log(`${feed.title} ${feed.items.length}`);
      await Podcast.findOneAndUpdate(
        { feedUrl: url },
        {
          title: feed.title,
          description: feed.description,
          feedUrl: url,
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
    }
    res.json(await Podcast.find({}));
  } else {
    console.log('No missing podcasts');
    res.json(podcasts);
  }
});

router.get('/:podcastId/episodes', async (req: Request, res: Response) => {
  console.log('PARAMS', req.params);
  console.log('QUERY', req.query);
  let podcast = await Podcast.findById(req.params.podcastId);
  let feed = await parser.parseURL(podcast.feedUrl);
  // For Debugging
  // console.log(feed.items[Math.floor(Math.random() * feed.items.length)]);
  if (podcast.numOfEps !== feed.items.length) {
    console.log('Fetching missing episodes');
    podcast = await Podcast.findByIdAndUpdate(
      req.params.podcastId,
      {
        numOfEps: feed.items.length,
      } as UpdateQuery<typeof Podcast>,
      {
        new: true,
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
  } else {
    console.log('No missing episodes');
  }
  let episodes = await Episode.find({ podcastId: podcast._id })
    .sort({ publicationDate: -1 })
    .skip(parseInt((req.query?.page as string) || '0') * 20)
    .limit(20);
  console.log(episodes.length);
  res.json({ podcast, episodes });
});

router.get(
  '/:podcastId/episodes/:episodeId',
  async (req: Request, res: Response) => {
    const episode = await Episode.findOne({
      podcastId: req.params.podcastId,
      _id: req.params.episodeId,
    });
    console.log('EPISODE', episode.title);
    res.json(episode);
  }
);

export default router;
