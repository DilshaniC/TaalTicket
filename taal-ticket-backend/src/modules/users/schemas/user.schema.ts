import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes, Types } from 'mongoose';

export type UserDocument = HydratedDocument<User>;

@Schema()
export class User {
  @Prop({ type: SchemaTypes.ObjectId })
  _id: Types.ObjectId

  @Prop()
  firstName: string;

  @Prop()
  lastName: string;

  @Prop()
  userName: string;

  @Prop()
  email: string;

  @Prop()
  birthdate: Date;

  @Prop()
  password: string;

  @Prop()
  roles: string[];
}

export const UserSchema = SchemaFactory.createForClass(User);
