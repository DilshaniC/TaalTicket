import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { ShowsService } from './service/shows.service';
import { Show, ShowSchema } from './schemas/show.schema';
import { ShowsController } from './controller/show.controller';

@Module({
  imports: [MongooseModule.forFeature([{ name: Show.name, schema: ShowSchema }])],
  providers: [ShowsService],
  exports: [ShowsService],
  controllers: [ShowsController],
})
export class ShowsModule {}
