import { ApiProperty } from '@nestjs/swagger';

class user {
  @ApiProperty()
  name: string;
  @ApiProperty()
  password: string;
}

export class LoginDto {
  @ApiProperty()
  user: user;
}

export class ChangePasswordDto {
  @ApiProperty()
  username: string;
  @ApiProperty()
  oldPassword: string;
  @ApiProperty()
  newPassword: string;
  @ApiProperty()
  secret: string;
}
