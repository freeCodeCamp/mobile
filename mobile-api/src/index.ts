require('dotenv').config();
import Bree from 'bree';
import express, { Request, Response } from 'express';
import path from 'path/posix';
import dbConnect from './db-connect';
import podcastRoutes from './routes';

Bree.extend(require('@breejs/ts-worker'));

const app = express();
const port = 3000;
const bree = new Bree({
  root: path.join(__dirname, 'jobs'),
  defaultExtension: process.env.NODE_ENV === 'production' ? 'js' : 'ts',
  jobs: [
    {
      name: 'update-podcasts',
      timeout: 0,
      interval: '30m',
    },
  ],
});

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
