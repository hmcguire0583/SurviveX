Basi Map font — installation instructions

This folder should contain the Basi Map font files you downloaded from FontSpace (or the font provider):

- basimap.woff2    (preferred)
- basimap.woff     (fallback)
- basimap.ttf      (optional)

How to install:
1. Download Basi Map from the font provider (FontSpace). Ensure the license permits embedding/website use.
2. Place the downloaded font files in this folder (`public/fonts/`).
3. The site already includes an @font-face declaration in `app/globals.css` which refers to `/fonts/basimap.woff2` and `/fonts/basimap.woff`.
4. After copying the font files, restart the Next dev server (if running) or reload the page. The header title (`.site-logo`) will prefer the local 'Basi Map' font and fall back to the configured display font.

Licensing:
- Verify the license on FontSpace (or the font source) before including the font in your project, especially for commercial projects. Some fonts require attribution or restrict embedding.

If you want, I can:
- Convert the SVG logo text to use the Basi Map path so it always matches the header even if the font isn't loaded.
- Generate PNG/favicons once you provide the font file and confirm the visual style you want.
