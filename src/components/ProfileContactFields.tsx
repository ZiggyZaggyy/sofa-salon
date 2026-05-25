'use client';

import { useLocale } from '@/components/LocaleProvider';
import {
  CONTACT_PLATFORMS,
  type ContactPlatform,
  normalizeContactPlatform,
} from '@/lib/contact-platform';

interface Props {
  platform: ContactPlatform;
  onPlatformChange: (p: ContactPlatform) => void;
  contactId: string;
  onContactIdChange: (id: string) => void;
  idPrefix?: string;
}

export default function ProfileContactFields({
  platform,
  onPlatformChange,
  contactId,
  onContactIdChange,
  idPrefix = 'contact',
}: Props) {
  const { t } = useLocale();
  const selectId = `${idPrefix}-platform`;
  const inputId = `${idPrefix}-id`;

  const platformLabel = (p: ContactPlatform) => {
    switch (p) {
      case 'wechat':
        return t.profile.contactPlatformWechat;
      case 'whatsapp':
        return t.profile.contactPlatformWhatsapp;
      case 'instagram':
        return t.profile.contactPlatformInstagram;
      case 'discord':
        return t.profile.contactPlatformDiscord;
    }
  };

  const placeholder = (() => {
    switch (platform) {
      case 'wechat':
        return t.profile.contactIdPlaceholderWechat;
      case 'whatsapp':
        return t.profile.contactIdPlaceholderWhatsapp;
      case 'instagram':
        return t.profile.contactIdPlaceholderInstagram;
      case 'discord':
        return t.profile.contactIdPlaceholderDiscord;
    }
  })();

  const fieldLabel = (() => {
    switch (platform) {
      case 'wechat':
        return t.profile.contactIdLabelWechat;
      case 'whatsapp':
        return t.profile.contactIdLabelWhatsapp;
      case 'instagram':
        return t.profile.contactIdLabelInstagram;
      case 'discord':
        return t.profile.contactIdLabelDiscord;
    }
  })();

  return (
    <div className="space-y-3">
      <div>
        <label
          htmlFor={selectId}
          className="block font-mono text-[10px] tracking-[0.2em] uppercase text-[#888888] mb-2"
        >
          {t.profile.contactPlatformLabel}
        </label>
        <select
          id={selectId}
          value={platform}
          onChange={(e) =>
            onPlatformChange(normalizeContactPlatform(e.target.value))
          }
          className="w-full bg-[#1e1e1e] border border-[#2a2a2a] text-[#e8e4dc] font-mono text-[13px] px-4 py-3 min-h-[44px] outline-none focus:border-[#e8c84a]"
          style={{ borderRadius: 0 }}
        >
          {CONTACT_PLATFORMS.map((p) => (
            <option key={p} value={p}>
              {platformLabel(p)}
            </option>
          ))}
        </select>
      </div>
      <div>
        <label
          htmlFor={inputId}
          className="block font-mono text-[10px] tracking-[0.2em] uppercase text-[#888888] mb-2"
        >
          {fieldLabel} <span className="text-[#f87171]">*</span>
        </label>
        <input
          id={inputId}
          type="text"
          value={contactId}
          onChange={(e) => onContactIdChange(e.target.value)}
          className="w-full bg-[#1e1e1e] border border-[#2a2a2a] text-[#e8e4dc] font-mono text-[13px] px-4 py-3 min-h-[44px] outline-none focus:border-[#e8c84a] transition-colors placeholder:text-[#444444]"
          style={{ borderRadius: 0 }}
          placeholder={placeholder}
          required
        />
      </div>
    </div>
  );
}
