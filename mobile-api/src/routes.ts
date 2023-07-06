import express, { Request, Response } from 'express';
import Parser from 'rss-parser';
import Episode from './models/Episode';
import Podcast from './models/Podcast';
import { feedUrls } from './podcast-feed-urls.json';

const router = express.Router();
const parser = new Parser();

router.get('/', (req, res, next) => {
  getPodcasts(req, res).catch(next);
});

async function getPodcasts(req: Request, res: Response) {
  const podcasts = await Podcast.find({});
  if (feedUrls.length !== podcasts.length) {
    console.log('Fetching missing podcasts');
    for (const url of feedUrls) {
      const feed = await parser.parseURL(url);

      if (feed.title) {
        console.log(`${feed.title} ${feed.items.length}`);
      } else {
        console.error(`title of ${url} missing ${feed.items.length}`);
      }
      await Podcast.findOneAndUpdate(
        { feedUrl: url },
        {
          title: feed.title,
          description: feed.description,
          feedUrl: url,
          podcastLink: feed.link,
          imageLink: feed.image?.url || feed.itunes?.image,
          copyright: feed.copyright as string,
          numOfEps: feed.items.length,
        },
        {
          new: true,
          upsert: true,
        },
      );
    }
    res.json(await Podcast.find({}));
  } else {
    console.log('No missing podcasts');
    res.json(podcasts);
  }
}

router.get('/:podcastId/episodes', (req, res, next) => {
  getEpisodes(req, res).catch(next);
});

async function getEpisodes(req: Request, res: Response) {
  const podcast = await Podcast.findById(req.params.podcastId);
  if (!podcast) throw Error('Podcast not found');
  const episodes = await Episode.find({ podcastId: podcast._id })
    .sort({ publicationDate: -1 })
    .skip(parseInt((req.query?.page as string) || '0') * 20)
    .limit(20);
  res.json({ podcast, episodes });
}

router.get('/:podcastId/episodes/:episodeId', (req, res, next) => {
  getEpisode(req, res).catch(next);
});

async function getEpisode(req: Request, res: Response) {
  const episode = await Episode.findOne({
    podcastId: req.params.podcastId,
    _id: req.params.episodeId,
  });
  if (!episode) throw Error('Episode not found');
  res.json(episode);
}

export default router;
