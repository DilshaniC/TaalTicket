import { TicketI } from "./ticket.interface";
import { VenueI } from "./venue.interface";

export class ShowI {
  _id: string;
  name: string;
  description: string;
  venues: Array<VenueI>;
  tickets: Array<TicketI>;
  artists: Array<string>;
}
