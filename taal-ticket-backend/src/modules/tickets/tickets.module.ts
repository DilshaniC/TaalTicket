import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { TicketsService } from './service/tickets.service';
import { BookedTicket, BookedTicketSchema } from './schemas/ticket.schema';
import { BookedTicketsController } from './controller/bookedticket.controller';

@Module({
  imports: [MongooseModule.forFeature([{ name: BookedTicket.name, schema: BookedTicketSchema }])],
  providers: [TicketsService],
  exports: [TicketsService],
  controllers: [BookedTicketsController],
})
export class TicketsModule {}
