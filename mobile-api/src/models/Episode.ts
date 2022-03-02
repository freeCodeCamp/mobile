import * as mongoose from "mongoose";

const Schema = mongoose.Schema;

const Episode = new Schema({
  guid: {
    type: String,
    required: true,
  },
  podcastId: {
    type: Schema.Types.ObjectId,
    ref: "Podcast",
    required: true,
  },
  title: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    default: "",
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

export default mongoose.models.Episode ||
  mongoose.model("Episode", Episode, "episodes");
