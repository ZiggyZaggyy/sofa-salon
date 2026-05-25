'use client';

import { useState } from 'react';
import { createClient } from '@/lib/supabase/client';
import AvatarRegen from '@/components/AvatarRegen';
import ProfileContactFields from '@/components/ProfileContactFields';
import { jsonToConfig, type AvatarConfig } from '@/lib/avatar';
import {
  getProfileContact,
  isContactIdUniqueViolation,
  profileContactUpsertFields,
  type ContactPlatform,
} from '@/lib/contact-platform';
import { useLocale } from '@/components/LocaleProvider';

interface Props {
  initialDisplayName: string;
  initialContactPlatform: string;
  initialContactId: string;
  initialWechatId: string;
  initialAvatarConfig: unknown;
}

export default function ProfileForm({
  initialDisplayName,
  initialContactPlatform,
  initialContactId,
  initialWechatId,
  initialAvatarConfig,
}: Props) {
  const { t } = useLocale();
  const legacy = getProfileContact({
    contact_platform: initialContactPlatform,
    contact_id: initialContactId,
    wechat_id: initialWechatId,
  });
  const [displayName, setDisplayName] = useState(initialDisplayName);
  const [contactPlatform, setContactPlatform] = useState<ContactPlatform>(legacy.platform);
  const [contactId, setContactId] = useState(
    legacy.id || initialContactId || initialWechatId
  );
  const [avatarConfig, setAvatarConfig] = useState<AvatarConfig>(
    jsonToConfig(initialAvatarConfig)
  );
  const [saving, setSaving] = useState(false);
  const [message, setMessage] = useState('');

  const save = async () => {
    const id = String(contactId).trim();
    if (!id) {
      setMessage(t.profile.contactRequired);
      return;
    }
    setSaving(true);
    setMessage('');
    const supabase = createClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) {
      setMessage(t.profile.notSignedIn);
      setSaving(false);
      return;
    }
    const { error } = await supabase.from('profiles').upsert(
      {
        id: user.id,
        display_name: displayName.trim() || (user.email?.split('@')[0] ?? 'Guest'),
        avatar_config: avatarConfig,
        ...profileContactUpsertFields(contactPlatform, id),
      },
      { onConflict: 'id' }
    );
    setSaving(false);
    if (error) {
      setMessage(
        isContactIdUniqueViolation(error.message)
          ? t.profile.contactIdTaken
          : error.message
      );
      return;
    }
    setMessage(t.profile.saved);
  };

  return (
    <form
      onSubmit={(e) => {
        e.preventDefault();
        save();
      }}
      className="flex flex-col gap-6"
    >
      <div>
        <label
          htmlFor="displayName"
          className="block font-mono text-[10px] tracking-[0.2em] uppercase text-[#888888] mb-2"
        >
          {t.profile.displayName}
        </label>
        <input
          id="displayName"
          type="text"
          value={displayName}
          onChange={(e) => setDisplayName(e.target.value)}
          className="w-full bg-[#1e1e1e] border border-[#2a2a2a] text-[#e8e4dc] font-mono text-[13px] px-4 py-3 min-h-[44px] outline-none focus:border-[#e8c84a] transition-colors placeholder:text-[#444444]"
          style={{ borderRadius: 0 }}
          placeholder={t.profile.displayNamePlaceholder}
        />
      </div>
      <ProfileContactFields
        platform={contactPlatform}
        onPlatformChange={setContactPlatform}
        contactId={contactId}
        onContactIdChange={setContactId}
        idPrefix="profile"
      />
      <AvatarRegen
        initialConfig={avatarConfig}
        onSave={(config) => setAvatarConfig(config)}
      />
      {message && (
        <p
          className={`font-mono text-[13px] ${message === t.profile.saved ? 'text-[#4ade80]' : 'text-[#f87171]'}`}
        >
          {message}
        </p>
      )}
      <button
        type="submit"
        disabled={saving}
        className="w-full bg-[#e8c84a] text-[#0f0f0f] font-mono text-[10px] tracking-[0.2em] uppercase py-3 min-h-[44px] hover:opacity-85 active:scale-[0.97] disabled:opacity-60 transition-all"
        style={{ borderRadius: 0 }}
      >
        {t.profile.save}
      </button>
    </form>
  );
}
