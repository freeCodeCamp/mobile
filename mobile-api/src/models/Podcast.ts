import * as mongoose from 'mongoose';

const Schema = mongoose.Schema;

const Podcast = new Schema({
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
  mongoose.model('Podcast', Podcast, 'podcasts');
