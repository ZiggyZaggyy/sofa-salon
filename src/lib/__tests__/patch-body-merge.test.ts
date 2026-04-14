import { textFieldFromPatchOrPreserve } from '@/lib/patch-body-merge';

describe('textFieldFromPatchOrPreserve', () => {
  it('uses incoming when defined (including empty string)', () => {
    expect(textFieldFromPatchOrPreserve('hello', 'old')).toBe('hello');
    expect(textFieldFromPatchOrPreserve('', 'old')).toBe('');
    expect(textFieldFromPatchOrPreserve(null, 'old')).toBe('');
  });

  it('preserves previous when incoming is undefined', () => {
    expect(textFieldFromPatchOrPreserve(undefined, 'stored')).toBe('stored');
    expect(textFieldFromPatchOrPreserve(undefined, null)).toBe('');
  });
});
