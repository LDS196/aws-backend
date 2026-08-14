import {Controller, Get, HttpException, HttpStatus, ParseBoolPipe, Query} from '@nestjs/common';
import {ReadinessService} from "./readiness.service";

@Controller('app')
export class HealthController {
  constructor(private readonly readinessService: ReadinessService) {}

  @Get('/health')
  health(): string {
    return 'success'
  }

  @Get('/ready')
  ready(): string {
    if (!this.readinessService.isReady()) {
      throw new HttpException('not ready', HttpStatus.SERVICE_UNAVAILABLE); // 503
    }
    return 'success';
  }
  @Get('/set-ready')
  setIsReady(
      @Query('isReady', ParseBoolPipe) isReady: boolean
  ) {
     this.readinessService.setIsReady(isReady)
  }


  @Get('/set-health')
  setHealth(
  ) {
    this.readinessService.setHealth()
  }
}
