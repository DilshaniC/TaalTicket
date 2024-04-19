import {
  Inject,
  Injectable,
  InternalServerErrorException,
} from '@nestjs/common';
import { UserI } from '../models/user.interface';
import { Logger } from 'winston';


import { Model } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
import { User } from '../schemas/user.schema';
import { CreateUserDto } from '../dto/create-user.dto';

@Injectable()
export class UsersService {
  
  constructor(
    @InjectModel(User.name) 
    private userModel: Model<User>,
    @Inject('winston')
    private readonly logger: Logger,
  ) {}

  /*
   * Inserts new entry to user document
   * @param {[UserI]} user [User Interface]
   * @return {[Promise<UserI & UserEntity>]} [Returns new user's details]
   */
  async createUser(newUser: CreateUserDto): Promise<User> {
    const createdUser = new this.userModel(newUser);
    return createdUser.save();
  }

  /*
   * Selects all entries from user document
   * @return {[Promise<UserEntity[]>]} [Returns all rows from user table]
   */
  async findAll(): Promise<User[]> {
    return this.userModel.find().exec();
  }

  /*
   * Selects a specific user from users document by username
   * @param {[string]} username [Username provided by user at registration]
   * @return {[Promise<UserI | undefined>]} [Returns user's details]
   */
  async findOne(userName: string): Promise<UserI | undefined> {
    return this.userModel.findOne({ userName });
  }

  /*
   * Update password field in user document
   * @param {[int]} id [User's id]
   * @param {[string]} newPasswordHash [New value to replace existing value]
   * @return {[Promise<UserI & UserEntity>]} [Returns whether row was updated or not]
   */
  async updatePassword(id: string, newPasswordHash: string) {
    try {
      return this.userModel.findByIdAndUpdate(id, { password: newPasswordHash });
    } catch (error) {
      throw new InternalServerErrorException(error.message);
    }
  }
}
