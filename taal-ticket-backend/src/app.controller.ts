import {
  Controller,
  Post,
  UseGuards,
  Body,
  HttpException,
  HttpStatus,
  Get,
} from '@nestjs/common';
import { AuthService } from './modules/auth/auth.service';
import { LocalAuthGuard } from './modules/auth/local-auth-guard';
import { AppService } from './app.service';
import { ChangePasswordDto, LoginDto } from './dto/user.dto';
import { ApiBearerAuth } from '@nestjs/swagger';
import { AllowedRoles } from './modules/users/roles.decorator';
import { Role } from './modules/users/enum/role.enum';
import { JwtAuthGuard } from './modules/auth/jwt-auth.guard';
import { RolesGuard } from './modules/users/roles.guard';
import { CreateUserDto } from './modules/users/dto/create-user.dto';

@Controller()
export class AppController {
  constructor(
    private readonly authService: AuthService,
    private readonly appService: AppService,
  ) {}

  //Login the user and return JWT token
  @UseGuards(LocalAuthGuard)
  @Post('login')
  login(@Body() req: LoginDto): any {
    return this.authService.login(req.user);
  }

  // Add new user to the system
  // @ApiBearerAuth('JWT')
  @Post('createUser')
  // @AllowedRoles(Role.ADMIN)
  // @UseGuards(JwtAuthGuard, RolesGuard)
  addUser(@Body() req: CreateUserDto): any {
    return this.authService.register(req);
  }

  @Post('strengthTest')
  strengthTest(@Body() password: string) {
    const strongRegex = new RegExp(
      '^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*])(?=.{8,})$',
    );
    if (strongRegex.test(password)) {
      return true;
    } else {
      throw new HttpException(
        'password strength is not enough',
        HttpStatus.NOT_ACCEPTABLE,
      );
    }
  }

  // Change password to a new one
  @ApiBearerAuth('JWT')
  @Post('resetPassword')
  @AllowedRoles(Role.ADMIN, Role.USER, Role.DIRECTOR)
  @UseGuards(JwtAuthGuard, RolesGuard)
  changePassword(@Body() req: ChangePasswordDto): any {
    if (req.secret != process.env.ADMIN_PASS) {
      return new HttpException('bad secret', HttpStatus.UNAUTHORIZED);
    }
    return this.authService.changePassword(
      req.username,
      req.oldPassword,
      req.newPassword,
    );
  }

  // View current users registered with system
  @ApiBearerAuth('JWT')
  @Get('viewAllUsers')
  @AllowedRoles(Role.ADMIN)
  @UseGuards(JwtAuthGuard, RolesGuard)
  viewAllUsers(): any {
    return this.authService.viewAllUsers();
  }
}
