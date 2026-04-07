# NestJS Module Generator

## Description

Generates complete NestJS modules with proper architecture — Module, Controller, Service, Repository, and Entity files following official NestJS conventions. Creates clean, well-structured code ready for copy-paste into a NestJS project.

## Triggered When

- User says "create a module", "generate NestJS module", "nest new resource"
- User says "tạo module", "tạo NestJS resource", "generate module"
- User says "generate CRUD for [entity]", "create [entity] module"
- User says "scaffold module", "tạo CRUD cho"
- User asks about NestJS project structure
- Starting a new feature that needs full module scaffolding

## Module Anatomy

```
src/
├── entities/              ← Shared domain entities
│   └── user.entity.ts
└── modules/
    └── users/
        ├── users.module.ts
        ├── users.controller.ts
        ├── users.service.ts
        ├── users.repository.ts    ← Only if using TypeORM
        ├── dto/
        │   ├── create-user.dto.ts
        │   └── update-user.dto.ts
        └── enums/
            └── user-role.enum.ts
```

## Controller Template

```typescript
// users.controller.ts
import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';

@Controller('users')
@UseGuards(JwtAuthGuard, RolesGuard)
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Post()
  @Roles('admin')
  create(@Body() createUserDto: CreateUserDto) {
    return this.usersService.create(createUserDto);
  }

  @Get()
  findAll() {
    return this.usersService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.usersService.findOne(id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateUserDto: UpdateUserDto) {
    return this.usersService.update(id, updateUserDto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  remove(@Param('id') id: string) {
    return this.usersService.remove(id);
  }
}
```

## Service Template

```typescript
// users.service.ts
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../entities/user.entity';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly userRepo: Repository<User>,
  ) {}

  async create(dto: CreateUserDto): Promise<User> {
    const user = this.userRepo.create(dto);
    return this.userRepo.save(user);
  }

  async findAll(): Promise<User[]> {
    return this.userRepo.find();
  }

  async findOne(id: string): Promise<User> {
    const user = await this.userRepo.findOne({ where: { id } });
    if (!user) throw new NotFoundException(`User #${id} not found`);
    return user;
  }

  async update(id: string, dto: UpdateUserDto): Promise<User> {
    const user = await this.findOne(id);
    this.userRepo.merge(user, dto);
    return this.userRepo.save(user);
  }

  async remove(id: string): Promise<void> {
    const user = await this.findOne(id);
    await this.userRepo.remove(user);
  }
}
```

## Module Template

```typescript
// users.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from '../entities/user.entity';
import { UsersController } from './users.controller';
import { UsersService } from './users.service';

@Module({
  imports: [TypeOrmModule.forFeature([User])],
  controllers: [UsersController],
  providers: [UsersService],
  exports: [UsersService],
})
export class UsersModule {}
```

## Naming Conventions

| Part | Convention | Example |
|---|---|---|
| Module file | `kebab-case` | `users.module.ts` |
| Controller | `{name}.controller.ts` | `users.controller.ts` |
| Service | `{name}.service.ts` | `users.service.ts` |
| Entity | `{name}.entity.ts` | `user.entity.ts` |
| DTO | `{action}-{name}.dto.ts` | `create-user.dto.ts` |
| Enum | `{name}.enum.ts` | `user-role.enum.ts` |
| Decorator prefix | PascalCase | `@Roles('admin')` |

## Output Format

```
## NestJS Module — [Resource Name]

### Files Generated
- [ ] users.module.ts
- [ ] users.controller.ts
- [ ] users.service.ts
- [ ] dto/create-user.dto.ts
- [ ] dto/update-user.dto.ts

### Module Code
\`\`\`typescript
[full module code]
\`\`\`

### Controller Code
\`\`\`typescript
[full controller code]
\`\`\`

### Service Code
\`\`\`typescript
[full service code]
\`\`\`
```

## Rules

- Always use `@InjectRepository` with TypeORM — never new up the repo
- Throw `NotFoundException` when entity doesn't exist
- Always use async/await, return `Promise<T>` for all service methods
- Mark relations with `LazyLoadingRelations` or `EagerRelations` explicitly
- Group related DTOs in a `dto/` subdirectory
- Use `@ApiTags()` and `@ApiOperation()` from `@nestjs/swagger` for all endpoints
