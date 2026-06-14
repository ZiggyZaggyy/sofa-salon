-- Expand the random avatar generated for new auth users.
-- Existing avatar_config values remain valid and are normalized by the app.

CREATE OR REPLACE FUNCTION public.handle_new_user() RETURNS TRIGGER AS $$
DECLARE initial_config JSONB;
BEGIN
  initial_config := jsonb_build_object(
    'skinTone',      (ARRAY['#f5c5a0','#d4a574','#c8a880','#a0724a','#7d4e2d','#f5deb3'])[floor(random()*6+1)],
    'hairStyle',     floor(random()*14+1)::int,
    'hairColor',     (ARRAY['#111111','#3a1a00','#8B4513','#DAA520','#FF6B6B','#4169E1','#9370DB'])[floor(random()*7+1)],
    'topStyle',      floor(random()*4+1)::int,
    'topColor',      (ARRAY['#2a4fd6','#e87cb5','#3ab87a','#e8c84a','#7c3ad6','#d63a2f','#e8824a'])[floor(random()*7+1)],
    'bottomStyle',   (ARRAY['jeans','shorts','skirt','wide-leg'])[floor(random()*4+1)],
    'bottomColor',   (ARRAY['#315b96','#27364f','#4d4f58','#63734a','#7a3f54','#92724f'])[floor(random()*6+1)],
    'eyeExpression', (ARRAY['happy','sleepy','excited','neutral'])[floor(random()*4+1)],
    'accessory',     (ARRAY['none','none','round-glasses','baseball-cap','beanie','headphones'])[floor(random()*6+1)]
  );
  INSERT INTO public.profiles (id, display_name, wechat_id, avatar_config)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email,'@',1)),
    '',
    initial_config
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
