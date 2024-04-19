import { ApiProperty } from '@nestjs/swagger';
import { TicketI } from '../models/ticket.interface';
import { VenueI } from '../models/venue.interface';

export class TikcetDto extends TicketI {
  @ApiProperty({ required: true })
  packageName: string;

  @ApiProperty({ required: true })
  price: number;
}

export class VenueDto extends VenueI {
  @ApiProperty({ required: true })
  location: string;

  @ApiProperty({ required: true, default: new Date() })
  starttime: Date;

  @ApiProperty({ required: true, default: new Date() })
  endtime: Date;
}

export class CreateShowDto {
  @ApiProperty({ required: true })
  name: string;

  @ApiProperty({ required: true })
  description: string;

  @ApiProperty({ required: true })
  venues: Array<VenueDto>;

  @ApiProperty({ required: true })
  tickets: Array<TikcetDto>;

  @ApiProperty({ required: true })
  artists: Array<string>;
}

export class UpdateShowDto {
  @ApiProperty({ required: true })
  name: string;

  @ApiProperty({ required: true })
  description: string;

  @ApiProperty({ required: true })
  venues: Array<VenueDto>;

  @ApiProperty({ required: true })
  tickets: Array<TikcetDto>;

  @ApiProperty({ required: true })
  artists: Array<string>;
}
