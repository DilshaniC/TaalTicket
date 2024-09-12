import {
    Inject,
    Injectable,
    InternalServerErrorException,
  } from '@nestjs/common';
  import { BookedTicketI } from '../models/bookedticket.interface';
  import { Logger } from 'winston';
  import { Model } from 'mongoose';
  import { InjectModel } from '@nestjs/mongoose';
  import { BookedTicket } from '../schemas/ticket.schema';
  
  @Injectable()
  export class TicketsService {
    constructor(
      @InjectModel(BookedTicket.name)
      private ticketModel: Model<BookedTicket>,
      @Inject('winston')
      private readonly logger: Logger,
    ) {}
  
    /*
     * Inserts new entry to user document
     * @param {[UserI]} user [User Interface]
     * @return {[Promise<UserI & UserEntity>]} [Returns new user's details]
     */
    async bookNewTicket(
      showId: string,
      userId: string,
      location:string,
      ticketCount:number,
      price: number,
      starttime: Date,
      endtime: Date,
      status: string
    ): Promise<BookedTicket> {
      const newTicket: BookedTicketI = {
        _id: null,
        showId,
        userId,
        location,
        ticketCount,
        price,
        starttime,
        endtime,
        status
      };
      const createdTicket = new this.ticketModel(newTicket);
      return createdTicket.save();
    }
  
    /*
     * Selects all entries from show document
     * @return {[Promise<ShowEntity[]>]} [Returns all records from show document]
     */
    async viewAllTickets(): Promise<any> {
      const allTickets = await this.ticketModel.find().exec();
      return { "allTickets": allTickets};
    }
  
    /*
     * Selects a specific show from shows document by username
     * @param {[string]} name [name of the show]
     * @return {[Promise<ShowI | undefined>]} [Returns show details]
     */
    async findOne(userId: string): Promise<any> {
      const allTicketsOfUser = await this.ticketModel.find({ userId: userId }).exec();
      return allTicketsOfUser;
    }
  
    /*
     * Update password field in user document
     * @param {[int]} id [User's id]
     * @param {[string]} newPasswordHash [New value to replace existing value]
     * @return {[Promise<UserI & UserEntity>]} [Returns whether row was updated or not]
     */
    async updateTicket(
      id: string,
      status: string,
    ) {
      try {
        return this.ticketModel.findByIdAndUpdate(id, {
          status
        });
      } catch (error) {
        throw new InternalServerErrorException(error.message);
      }
    }

    async viewCancelled(){
      return this.ticketModel.find({status:"cancelled"}).exec();
    }
  }
  