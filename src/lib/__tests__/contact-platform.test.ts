import {
  formatContactForAdminList,
  getProfileContact,
  hasProfileContact,
  normalizeContactPlatform,
  profileContactUpsertFields,
} from '../contact-platform';

const labels = {
  wechat: 'WeChat ID',
  whatsapp: 'WhatsApp ID',
  instagram: 'Instagram ID',
  discord: 'Discord ID',
};

describe('getProfileContact', () => {
  it('prefers contact_id and contact_platform', () => {
    expect(
      getProfileContact({
        contact_platform: 'instagram',
        contact_id: '@ziggy',
        wechat_id: 'old',
      })
    ).toEqual({ platform: 'instagram', id: '@ziggy' });
  });

  it('falls back to wechat_id for legacy rows', () => {
    expect(getProfileContact({ wechat_id: 'wx123' })).toEqual({
      platform: 'wechat',
      id: 'wx123',
    });
  });
});

describe('hasProfileContact', () => {
  it('is false when empty', () => {
    expect(hasProfileContact({ contact_id: '', wechat_id: '' })).toBe(false);
  });

  it('is true with discord id', () => {
    expect(
      hasProfileContact({ contact_platform: 'discord', contact_id: 'user#1' })
    ).toBe(true);
  });
});

describe('profileContactUpsertFields', () => {
  it('syncs wechat_id only for wechat platform', () => {
    expect(profileContactUpsertFields('wechat', ' abc ')).toEqual({
      contact_platform: 'wechat',
      contact_id: 'abc',
      wechat_id: 'abc',
    });
    expect(profileContactUpsertFields('whatsapp', '123')).toEqual({
      contact_platform: 'whatsapp',
      contact_id: '123',
      wechat_id: '',
    });
  });
});

describe('formatContactForAdminList', () => {
  it('shows id only for wechat', () => {
    expect(formatContactForAdminList('wechat', 'ziggy_wx', labels)).toBe('ziggy_wx');
  });

  it('prefixes label for other platforms', () => {
    expect(formatContactForAdminList('whatsapp', '12345', labels)).toBe(
      'WhatsApp ID: 12345'
    );
  });
});

describe('isContactIdUniqueViolation', () => {
  it('matches display_name + contact_id unique index name', async () => {
    const { isContactIdUniqueViolation } = await import('../contact-platform');
    expect(
      isContactIdUniqueViolation(
        'duplicate key value violates unique constraint "profiles_display_name_contact_id_unique"'
      )
    ).toBe(true);
  });
});

describe('normalizeContactPlatform', () => {
  it('defaults unknown to wechat', () => {
    expect(normalizeContactPlatform('telegram')).toBe('wechat');
  });
});
