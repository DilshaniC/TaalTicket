import {
  Inject,
  Injectable,
  InternalServerErrorException,
} from '@nestjs/common';
import { ShowI } from '../models/show.interface';
import { Logger } from 'winston';
import { Model } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
import { Show } from '../schemas/show.schema';
import { TicketI } from '../models/ticket.interface';
import { VenueI } from '../models/venue.interface';

@Injectable()
export class ShowsService {
  constructor(
    @InjectModel(Show.name)
    private showModel: Model<Show>,
    @Inject('winston')
    private readonly logger: Logger,
  ) {}

  /*
   * Inserts new entry to user document
   * @param {[UserI]} user [User Interface]
   * @return {[Promise<UserI & UserEntity>]} [Returns new user's details]
   */
  async addNewShow(
    name: string,
    description: string,
    image:string,
    venues: Array<VenueI>,
    tickets: Array<TicketI>,
    artists: Array<string>
  ): Promise<Show> {
    const newShow: ShowI = {
      _id: null,
      name,
      description,
      image,
      venues,
      tickets,
      artists
    };
    const createdShow = new this.showModel(newShow);
    return createdShow.save();
  }

  /*
   * Selects all entries from show document
   * @return {[Promise<ShowEntity[]>]} [Returns all records from show document]
   */
  async viewAllShows(): Promise<any> {
    const allShows = await this.showModel.find().exec();
    return { "allShows": allShows};
  }


  async viewShow(id): Promise<any> {
    const show = await this.showModel.findById(id);
    return show;
  }

  /*
   * Selects a specific show from shows document by username
   * @param {[string]} name [name of the show]
   * @return {[Promise<ShowI | undefined>]} [Returns show details]
   */
  async findOne(name: string): Promise<ShowI | undefined> {
    return this.showModel.findOne({ name });
  }

  /*
   * Update password field in user document
   * @param {[int]} id [User's id]
   * @param {[string]} newPasswordHash [New value to replace existing value]
   * @return {[Promise<UserI & UserEntity>]} [Returns whether row was updated or not]
   */
  async updateShow(
    id: string,
    name: string,
    description: string,
    image: string,
    venues: Array<VenueI>,
    tickets: Array<TicketI>,
    artists: Array<string>
  ) {
    try {
      return this.showModel.findByIdAndUpdate(id, {
        name,
        description,
        image,
        venues,
        tickets,
        artists
      });
    } catch (error) {
      throw new InternalServerErrorException(error.message);
    }
  }
}
