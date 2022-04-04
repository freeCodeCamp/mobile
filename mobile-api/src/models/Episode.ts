import * as mongoose from 'mongoose';

const Schema = mongoose.Schema;

export interface Episode {
  _id: mongoose.Types.ObjectId;
  title: string;
  description: string;
  feedUrl: string;
  podcastLink: string;
  imageLink: string;
  copyright: string;
  numOfEps: number;
}

const EpisodeSchema = new Schema({
  guid: {
    type: String,
    required: true,
  },
  podcastId: {
    type: Schema.Types.ObjectId,
    ref: 'Podcast',
    required: true,
  },
  title: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    default: '',
  },
  publicationDate: {
    type: Date,
  },
  audioUrl: {
    type: String,
    required: true,
  },
  duration: {
    type: String,
  },
});

export default (mongoose.models.Episode as mongoose.Model<Episode>) ||
  mongoose.model('Episode', EpisodeSchema, 'episodes');
