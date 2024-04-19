import { ApiProperty } from '@nestjs/swagger';
import { UserI } from 'src/modules/users/models/user.interface';
import { Role } from '../modules/users/enum/role.enum';

export class User {
  @ApiProperty()
  id: number;
  @ApiProperty()
  name: string;
  @ApiProperty()
  userName: string;
  @ApiProperty()
  password: string;
  @ApiProperty()
  roles: string[];
}

export const users: UserI[] = [
  {
    _id: '1',
    firstName: 'saman',
    lastName: 'test',
    birthdate: new Date(),
    email: 'test@test.com',
    userName: 'saman123',
    password: 'samanx',
    roles: [Role.USER],
  }
];
