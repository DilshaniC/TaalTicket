import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes, Types } from 'mongoose';
import { TicketI } from '../models/ticket.interface';
import { VenueI } from '../models/venue.interface';

export type ShowDocument = HydratedDocument<Show>;

@Schema()
export class Show {
  @Prop({ type: SchemaTypes.ObjectId })
  _id: Types.ObjectId

  @Prop()
  name: string;

  @Prop()
  description: string;

  @Prop()
  venues: Array<VenueI>;

  @Prop()
  tickets: Array<TicketI>;
}

export const ShowSchema = SchemaFactory.createForClass(Show);
