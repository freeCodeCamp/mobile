import 'dotenv/config';
import fetch from 'node-fetch';
import { Podcast } from '../models/Podcast';
import { Episode } from '../models/Episode';
interface pingEndpoint {
  msg: string;
}

interface episodeEndpoint {
  podcast: Podcast;
  episodes: Array<Episode>;
}

describe('podcast api', () => {
  const url = process.env.DEV_URL ?? 'https://api.mobile.freecodecamp.dev';

  let localPodcastId = '';
  let localEpisodeId = '';

  // test('the url should be available in the .env', () => {
  //     expect(url.length).toBeGreaterThan(0);
  // })

  test('it should be able to ping', async () => {
    const req = await fetch(`${url}/ping`);

    const res: pingEndpoint = (await req.json()) as pingEndpoint;

    expect(res.msg).toBe('pong');
  });

  test('it should have atleast 1 podcast available', async () => {
    const req = await fetch(`${url}/podcasts`);

    const res: Array<Podcast> = (await req.json()) as Array<Podcast>;

    expect(res.length).toBeGreaterThan(0);
  });

  jest.setTimeout(30000);

  // this test is only viable when there are less than 10 podcast available as the time-out already is above normal

  test('all podcast should have episodes available', async () => {
    const req = await fetch(`${url}/podcasts`);

    const res: Array<Podcast> = (await req.json()) as Array<Podcast>;

    for (let i = 0; i < res.length; i++) {
      const podcastId = res[i]._id.toString();

      const podcastRequest = await fetch(
        `${url}/podcasts/${podcastId}/episodes?page=1`,
      );

      const podcastResult: episodeEndpoint =
        (await podcastRequest.json()) as episodeEndpoint;

      expect(podcastResult.episodes.length).toBeGreaterThan(0);
      expect(podcastResult.episodes.length).toBeLessThanOrEqual(20);

      localPodcastId = podcastResult.podcast._id.toString();
      localEpisodeId = podcastResult.episodes[0]._id.toString();
    }
  });

  test(`a podcast should be available with the id: ${localPodcastId}`, async () => {
    expect(localPodcastId.length).toBeGreaterThan(0);
    expect(localEpisodeId.length).toBeGreaterThan(0);

    const req = await fetch(
      `${url}/podcasts/${localPodcastId}/episodes/${localEpisodeId}`,
    );

    const res: Episode = (await req.json()) as Episode;

    expect(res.description.length).toBeGreaterThan(0);
  });
});
