import { Controller, Get, Res } from '@nestjs/common';
import { register } from 'prom-client';
import { Response } from 'express';

@Controller('/metrics')
export class MetricsController {
  constructor() {}

  @Get()
  async getMetrics(@Res() res: Response) {
    res.set('Content-type', register.contentType);
    res.end(await register.metrics());
  }
}
