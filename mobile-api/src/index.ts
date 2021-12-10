require('dotenv').config();
import express, { Request, Response } from 'express';
import dbConnect from './db-connect';
import podcastRoutes from './routes';
import Bree from 'bree';
import path from 'path/posix';

const app = express();
const port = 3000;
const bree = new Bree({
  root: path.join(__dirname, 'jobs'),
  defaultExtension: 'ts',
  jobs: [
    {
      name: 'Update Podcasts',
      path: typescript_worker,
      timeout: 0,
      interval: '5m',
      worker: {
        workerData: { __filename: './src/jobs/update-podcasts.ts' },
      },
    },
  ],
});

function typescript_worker() {
  const path = require('path');
  require('ts-node').register();
  const workerData = require('worker_threads').workerData;
  require(path.resolve(__dirname, workerData.__filename));
}

app.get('/', async (req: Request, res: Response) => {
  res.json({ msg: 'Hello World!' });
});

app.use('/podcasts', podcastRoutes);

app.listen(port, async () => {
  await dbConnect();
  console.log(`API listening on port: ${port}`);
  console.log('Initialising jobs...');
  bree.start();
});
