import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './modules/auth/auth.module';
import { UsersModule } from './modules/users/users.module';
import { ShowsModule } from './modules/shows/shows.module';
import { MongooseModule } from '@nestjs/mongoose';
import { ConfigModule } from '@nestjs/config';
import { WinstonModule } from 'nest-winston';
import * as winston from 'winston';

// eslint-disable-next-line @typescript-eslint/no-var-requires
const path = require('path');
// eslint-disable-next-line @typescript-eslint/no-var-requires
const os = require('os');
// eslint-disable-next-line @typescript-eslint/no-var-requires
const dotenv = require('dotenv');

dotenv.config();

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true, envFilePath: '.env' }),
    MongooseModule.forRoot('mongodb://localhost/ticketbookingapp'),
    WinstonModule.forRoot({
      format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.json(),
      ),
      transports: [
        new winston.transports.Console(),
        new winston.transports.File({
          dirname:
            os.platform() == 'win32'
              ? path.join(__dirname, './../logs/')
              : process.env.LOG_PATH,
          filename: 'logs.txt',
          level: 'info',
          maxsize: 1e8, // 100MB
          zippedArchive: true,
        }),
      ],
    }),
    UsersModule,
    AuthModule,
    ShowsModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
