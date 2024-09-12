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

import * as fs from 'fs';
import * as path from 'path';
import { v4 as uuidv4 } from 'uuid';

@ApiTags('Shows')
@Controller('shows')
export class ShowsController {
  constructor(
    private readonly showsService: ShowsService,
    @Inject('winston')
    private readonly logger: Logger,
  ) { }

  // View all shows
  // @ApiBearerAuth('JWT')
  @Get('viewAll')
  // @AllowedRoles(Role.ADMIN, Role.DIRECTOR, Role.USER)
  // @UseGuards(JwtAuthGuard, RolesGuard)
  viewAllShows(): Promise<any> {
    return this.showsService.viewAllShows();
  }

  @Get('viewOne/:id')
  // @AllowedRoles(Role.ADMIN, Role.DIRECTOR, Role.USER)
  // @UseGuards(JwtAuthGuard, RolesGuard)
  viewShow(@Param('id') id: string): Promise<any> {
    return this.showsService.viewShow(id);
  }

  // Add new show
  // @ApiBearerAuth('JWT')
  @Post('addNew')
  // @AllowedRoles(Role.ADMIN, Role.DIRECTOR)
  // @UseGuards(JwtAuthGuard, RolesGuard)
  addNewShow(@Body() req: CreateShowDto): Promise<Show> {
    // Save the image
    const base64Image = req.image.split(';base64,').pop();
    const filename = `${uuidv4()}.jpg`; // or any other extension based on your needs

    // Use __dirname to resolve the correct path, considering both development and production environments
    const directoryPath = path.join(__dirname, '..', '..', 'assets', 'shows');
    const filePath = path.join(directoryPath, filename);

    // Ensure directory exists
    if (!fs.existsSync(directoryPath)) {
      fs.mkdirSync(directoryPath, { recursive: true });
    }

    // Save the base64 image to the file
    fs.writeFileSync(filePath, base64Image, { encoding: 'base64' });

    const fullImagePath = path.resolve(filePath);

    return this.showsService.addNewShow(
      req.name,
      req.description,
      fullImagePath,
      req.venues,
      req.tickets,
      req.artists
    );
  }

  // Add new show
  // @ApiBearerAuth('JWT')
  @Put('update/:id')
  // @AllowedRoles(Role.ADMIN, Role.DIRECTOR)
  // @UseGuards(JwtAuthGuard, RolesGuard)
  updateShow(
    @Param('id') id: string,
    @Body() req: UpdateShowDto,
  ): Promise<Show> {
    return this.showsService.updateShow(
      id,
      req.name,
      req.description,
      req.image,
      req.venues,
      req.tickets,
      req.artists
    );
  }
}
