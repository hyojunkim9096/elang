INSERT INTO site_layout(lang, header_html, footer_html)
VALUES
  ('ko',
   '<header class="site-header"><div class="container"><div class="brand">영어캠프</div><a class="lang-switch" href="/en">ENG</a></div></header>',
   '<footer class="site-footer"><div class="container"><small>© 영어캠프. All rights reserved.</small></div></footer>'
  ),
  ('en',
   '<header class="site-header"><div class="container"><div class="brand">English Camp</div><a class="lang-switch" href="/ko">KOR</a></div></header>',
   '<footer class="site-footer"><div class="container"><small>© English Camp. All rights reserved.</small></div></footer>'
  )
ON DUPLICATE KEY UPDATE
  header_html = header_html,
  footer_html = footer_html;

INSERT INTO site_menu(lang, label, href, sort_order, enabled)
SELECT 'ko', '프로그램', '#program', 10, 1
WHERE NOT EXISTS (SELECT 1 FROM site_menu WHERE lang='ko' AND label='프로그램');

INSERT INTO site_menu(lang, label, href, sort_order, enabled)
SELECT 'en', 'Program', '#program', 10, 1
WHERE NOT EXISTS (SELECT 1 FROM site_menu WHERE lang='en' AND label='Program');
