SELECT
  bd.id,
  bd.description,
  COALESCE(
    json_agg(
      json_build_object(
        'id', br.id,
        'description', br.description
      )
    ),
    '[]'::json
  ) AS badge_reqs
FROM
  badge_defs bd
LEFT JOIN
  badge_reqs br ON bd.id = br.badge_defs_id
GROUP BY
  bd.id, bd.description;
  

  -- Insert data into badges table using SELECT statement
INSERT INTO public.badges (badge_defs_id, data)
SELECT
  bd.id,
  jsonb_build_object(
    'description', bd.description,
    'badge_reqs', COALESCE(
      jsonb_agg(
        jsonb_build_object(
          'id', br.id,
          'description', br.description
        )
      ),
      '[]'::jsonb
    )
  )
FROM
  badge_defs bd
LEFT JOIN
  badge_reqs br ON bd.id = br.badge_defs_id
GROUP BY
  bd.id, bd.description;

  