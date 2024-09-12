import {
    Body,
    Controller,
    Get,
    Inject,
    Param,
    Post,
    Put,
    UseGuards,
  } from '@nestjs/common';
  import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
  import { JwtAuthGuard } from '../../auth/jwt-auth.guard';
  import { AllowedRoles } from '../../users/roles.decorator';
  import { Role } from '../../users/enum/role.enum';
  import { Logger } from 'winston';
  import { RolesGuard } from '../../users/roles.guard';
  import { TicketsService } from '../service/tickets.service';
  import { BookedTicket } from '../schemas/ticket.schema';
  import { BookTicketDto } from '../dto/book-ticket.dto';
  
  @ApiTags('Tickets')
  @Controller('tickets')
  export class BookedTicketsController {
    constructor(
      private readonly ticketService: TicketsService,
      @Inject('winston')
      private readonly logger: Logger,
    ) { }
  
    // View all shows
    @Get('viewAll')
    viewAllShows(): Promise<any> {
      return this.ticketService.viewAllTickets();
    }


    // View all shows
    @Get('viewTicketOf/:userId')
    viewTicketsOf(@Param('userId') userId: string): Promise<any> {        
      return this.ticketService.findOne(userId);
    }
  
    // Add new show
    @Post('addNew')
    createNewTicket(@Body() req: BookTicketDto): Promise<BookedTicket> {        
      return this.ticketService.bookNewTicket(
        req.showId,
        req.userId,
        req.location,
        req.ticketCount,
        req.price,
        req.starttime,
        req.endtime,
        req.status
      );
    }
  
    // Add new show
    @Put('update/:id/:status')
    updateTicket(
      @Param('id') id: string,
      @Param('status') status: string,
    ): Promise<any> {      
      return this.ticketService.updateTicket(
        id, status
      );
    }

    @Get('viewCancelled')
    viewCancelled(): Promise<any> {
      return this.ticketService.viewCancelled();
    }
  }
  