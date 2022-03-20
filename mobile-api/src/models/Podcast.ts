import * as mongoose from 'mongoose';

const Schema = mongoose.Schema;

export interface Podcast {
  _id: mongoose.Types.ObjectId;
  title: string;
  description: string;
  feedUrl: string;
  podcastLink: string;
  imageLink: string;
  copyright: string;
  numOfEps: number;
}

const PodcastSchema = new Schema<Podcast>({
  title: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    default: '',
  },
  feedUrl: {
    type: String,
    required: true,
  },
  podcastLink: {
    type: String,
    default: '',
  },
  imageLink: {
    type: String,
    required: true,
  },
  copyright: {
    type: String,
    default: '',
  },
  numOfEps: {
    type: Number,
    required: true,
    default: 0,
  },
});

export default mongoose.models.Podcast ||
  mongoose.model('Podcast', PodcastSchema, 'podcasts');
