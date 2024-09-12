import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes, Types } from 'mongoose';
import { BookedTicketI } from '../models/bookedticket.interface';

export type BookedTicketDocument = HydratedDocument<BookedTicket>;

@Schema()
export class BookedTicket {
  @Prop({ type: SchemaTypes.ObjectId })
  _id: Types.ObjectId

  @Prop()
  showId: Types.ObjectId

  @Prop()
  userId: Types.ObjectId;

  @Prop()
  location: string;

  @Prop()
  ticketCount: number;

  @Prop()
  price: number;

  @Prop()
  starttime: Date;

  @Prop()
  endtime: Date;

  @Prop()
  status: string;
}

export const BookedTicketSchema = SchemaFactory.createForClass(BookedTicket);
