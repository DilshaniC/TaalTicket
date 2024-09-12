import { ApiProperty } from '@nestjs/swagger';

export class CreateUserDto {
  @ApiProperty({ required: true })
  firstName: string;

  @ApiProperty({ required: true })
  lastName: string;

  @ApiProperty({ required: true })
  userName: string;

  @ApiProperty({ required: true })
  email: string;

  @ApiProperty({ required: true })
  password: string;

  @ApiProperty({ required: true })
  roles: string[];

  @ApiProperty({default: new Date()})
  birthdate: Date;
}

export class UpdateUserDto {
  @ApiProperty({ required: true })
  firstname: string;

  @ApiProperty({ required: true })
  lastname: string;

  @ApiProperty({ required: true })
  email: string;

  @ApiProperty({default: new Date()})
  birthdate: Date;
}