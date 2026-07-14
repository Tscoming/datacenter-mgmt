import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { subscribeCabinetHighFrequencyTelemetry } from './telemetry';

class MockEventSource extends EventTarget {
  static instances: MockEventSource[] = [];

  close = vi.fn();

  constructor(public readonly url: string) {
    super();
    MockEventSource.instances.push(this);
  }
}

describe('subscribeCabinetHighFrequencyTelemetry', () => {
  beforeEach(() => {
    MockEventSource.instances = [];
    vi.restoreAllMocks();
    vi.stubGlobal('EventSource', MockEventSource);
    vi.spyOn(crypto, 'randomUUID').mockReturnValue('00000000-0000-4000-8000-000000000001');
  });

  afterEach(() => {
    vi.unstubAllGlobals();
  });

  it('releases the subscription with sendBeacon when the page is closed', () => {
    const sendBeacon = vi.fn(() => true);
    vi.stubGlobal('navigator', { ...navigator, sendBeacon });
    const fetchSpy = vi.spyOn(globalThis, 'fetch');

    const unsubscribe = subscribeCabinetHighFrequencyTelemetry('cab-bj-002', vi.fn());
    window.dispatchEvent(new PageTransitionEvent('pagehide'));
    unsubscribe();

    expect(MockEventSource.instances[0].close).toHaveBeenCalledTimes(1);
    expect(sendBeacon).toHaveBeenCalledWith(
      '/api/idc/telemetry/cabinets/cab-bj-002/high-frequency-subscriptions/00000000-0000-4000-8000-000000000001/release',
    );
    expect(fetchSpy).not.toHaveBeenCalled();
  });

  it('falls back to a keepalive DELETE when sendBeacon cannot queue the release', () => {
    vi.stubGlobal('navigator', { ...navigator, sendBeacon: vi.fn(() => false) });
    const fetchSpy = vi.spyOn(globalThis, 'fetch').mockResolvedValue(new Response(null, { status: 204 }));

    const unsubscribe = subscribeCabinetHighFrequencyTelemetry('cab-bj-002', vi.fn());
    unsubscribe();

    expect(fetchSpy).toHaveBeenCalledWith(
      '/api/idc/telemetry/cabinets/cab-bj-002/high-frequency-subscriptions/00000000-0000-4000-8000-000000000001',
      { method: 'DELETE', keepalive: true },
    );
  });
});
