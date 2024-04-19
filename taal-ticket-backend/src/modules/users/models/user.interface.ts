import { Role } from '../enum/role.enum';

export class UserI {
  _id: string;
  firstName: string;
  lastName: string;
  email: string;
  birthdate: Date;
  userName: string;
  password: string;
  roles: Role[];
}
