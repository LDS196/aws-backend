import { Module } from '@nestjs/common';
import { MetricsController } from './metrics.controller';
import { collectDefaultMetrics } from 'prom-client';

@Module({
  imports: [],
  controllers: [MetricsController],
  providers: [],
})
export class MetricsModule {
  constructor() {
    collectDefaultMetrics();
  }
}
