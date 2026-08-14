import { Test, TestingModule } from '@nestjs/testing';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import * as process from 'node:process';

describe('AppController', () => {
  let appController: AppController;

  beforeEach(async () => {
    const app: TestingModule = await Test.createTestingModule({
      controllers: [AppController],
      providers: [AppService],
    }).compile();

    appController = app.get<AppController>(AppController);
  });

  describe('root', () => {
    it('should return "Hello DevOps v2.0"', () => {
      if (process.version.startsWith('v25')) {
        throw new Error('Node < 25!!');
      }
      expect(appController.getHello()).toBe('Hello DevOps v5.0');
    });
  });
});
