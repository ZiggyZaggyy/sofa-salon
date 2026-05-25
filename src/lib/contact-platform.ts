/** How guests share contact info with the host (profile setup). */
export type ContactPlatform = 'wechat' | 'whatsapp' | 'instagram' | 'discord';

export const CONTACT_PLATFORMS: ContactPlatform[] = [
  'wechat',
  'whatsapp',
  'instagram',
  'discord',
];

export function normalizeContactPlatform(
  value: string | null | undefined
): ContactPlatform {
  if (
    value === 'whatsapp' ||
    value === 'instagram' ||
    value === 'discord' ||
    value === 'wechat'
  ) {
    return value;
  }
  return 'wechat';
}

export type ProfileContactRow = {
  contact_platform?: string | null;
  contact_id?: string | null;
  wechat_id?: string | null;
};

export function getProfileContact(row: ProfileContactRow): {
  platform: ContactPlatform;
  id: string;
} {
  const platform = normalizeContactPlatform(row.contact_platform);
  const id = String(row.contact_id ?? row.wechat_id ?? '').trim();
  return { platform, id };
}

export function hasProfileContact(row: ProfileContactRow | null | undefined): boolean {
  if (!row) return false;
  return getProfileContact(row).id.length > 0;
}

/** Fields written to `profiles` on save. Keeps `wechat_id` in sync when platform is WeChat. */
export function profileContactUpsertFields(
  platform: ContactPlatform,
  contactId: string
): {
  contact_platform: ContactPlatform;
  contact_id: string;
  wechat_id: string;
} {
  const id = contactId.trim();
  return {
    contact_platform: platform,
    contact_id: id,
    wechat_id: platform === 'wechat' ? id : '',
  };
}

/** Admin guest list: WeChat shows id only; others show "WhatsApp ID: …". */
export function formatContactForAdminList(
  platform: ContactPlatform,
  id: string,
  labels: Record<ContactPlatform, string>
): string {
  const trimmed = id.trim();
  if (!trimmed) return '—';
  if (platform === 'wechat') return trimmed;
  return `${labels[platform]}: ${trimmed}`;
}

export function isContactIdUniqueViolation(message: string): boolean {
  return /profiles_display_name_contact_id_unique|profiles_contact_id_lower_unique|duplicate key|unique constraint/i.test(
    message
  );
}

export type AdminContactLabels = Record<ContactPlatform, string>;

export function adminContactFieldLabel(
  platform: ContactPlatform,
  labels: AdminContactLabels
): string {
  return labels[platform];
}
