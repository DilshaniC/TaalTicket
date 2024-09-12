import { ApiProperty } from '@nestjs/swagger';



export class BookTicketDto {
  @ApiProperty({ required: true })
  userId: string;

  @ApiProperty({ required: true })
  showId: string;

  @ApiProperty({ required: true })
  location: string;

  @ApiProperty({ required: true })
  ticketCount: number;

  @ApiProperty({ required: true })
  price: number;

  @ApiProperty({ required: true })
  starttime: Date;

  @ApiProperty({ required: true })
  endtime: Date;

  @ApiProperty({ required: true })
  status: string;
}
