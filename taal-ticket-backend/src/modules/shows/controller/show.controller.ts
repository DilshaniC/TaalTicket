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
  import { ShowsService } from '../service/shows.service';
  import { Show } from '../schemas/show.schema';
  import { CreateShowDto, UpdateShowDto } from '../dto/create-show.dto';
  
  @ApiTags('Shows')
  @Controller('shows')
  export class ShowsController {
    constructor(
      private readonly showsService: ShowsService,
      @Inject('winston')
      private readonly logger: Logger,
    ) {}
  
    // View all shows
    @ApiBearerAuth('JWT')
    @Get('viewAll')
    @AllowedRoles(Role.ADMIN, Role.DIRECTOR, Role.USER)
    @UseGuards(JwtAuthGuard, RolesGuard)
    viewAllShows(): Promise<Show[]> {
      return this.showsService.viewAllShows();
    }
  
    // Add new show
    @ApiBearerAuth('JWT')
    @Post('addNew')
    @AllowedRoles(Role.ADMIN, Role.DIRECTOR)
    @UseGuards(JwtAuthGuard, RolesGuard)
    addNewShow(@Body() req: CreateShowDto): Promise<Show> {
      return this.showsService.addNewShow(
        req.name,
        req.description,
        req.venues,
        req.tickets,
        req.artists
      );
    }
  
    // Add new show
    @ApiBearerAuth('JWT')
    @Put('update/:id')
    @AllowedRoles(Role.ADMIN, Role.DIRECTOR)
    @UseGuards(JwtAuthGuard, RolesGuard)
    updateShow(
      @Param('id') id: string,
      @Body() req: UpdateShowDto,
    ): Promise<Show> {
      return this.showsService.updateShow(
        id,
        req.name,
        req.description,
        req.venues,
        req.tickets,
        req.artists
      );
    }
  }
  