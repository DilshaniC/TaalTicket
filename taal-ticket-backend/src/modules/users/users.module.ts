import { Module } from '@nestjs/common';
// import { TypeOrmModule } from '@nestjs/typeorm';
import { MongooseModule } from '@nestjs/mongoose';
// import { UserEntity } from './models/user.entity';
import { UsersService } from './service/users.service';
import { User, UserSchema } from './schemas/user.schema';

@Module({
  // imports: [TypeOrmModule.forFeature([UserEntity])],
  imports: [MongooseModule.forFeature([{ name: User.name, schema: UserSchema }])],
  providers: [UsersService],
  exports: [UsersService],
  controllers: [],
})
export class UsersModule {}
