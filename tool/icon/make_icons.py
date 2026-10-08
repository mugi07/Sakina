"""Prépare les ressources de Zahrae Noor depuis app_icon.png (image approuvée).

Usage (depuis la racine du projet) :
    python tool/icon/make_icons.py
    dart run flutter_launcher_icons

Produit tool/icon/app_icon*.png (sources de flutter_launcher_icons) et
l'icône de notification Android (silhouette blanche) dans res/drawable-*.
"""
import math, os, sys
from PIL import Image, ImageDraw, ImageFilter, ImageChops

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = sys.argv[1] if len(sys.argv) > 1 else HERE
RES = os.path.join(HERE, '..', '..', 'android', 'app', 'src', 'main', 'res')
os.makedirs(OUT, exist_ok=True)
SS = 4  # suréchantillonnage

EMERALD_TOP = (22, 140, 108)
EMERALD_BOTTOM = (8, 72, 58)
CREAM = (250, 244, 228)
GOLD_LIGHT = (242, 210, 139)
GOLD = (200, 150, 62)


def gradient(size, top, bottom):
    im = Image.new('RGB', (size, size))
    px = im.load()
    for y in range(size):
        for x in range(size):
            # Diagonale haut-gauche -> bas-droite.
            t = (x * 0.35 + y) / (size * 1.35)
            px[x, y] = tuple(int(top[i] + (bottom[i] - top[i]) * t) for i in range(3))
    return im


def arch_polygon(cx, top_y, bottom_y, width, radius_factor=0.82, steps=200):
    """Arche brisée (mihrab) : deux arcs qui se rejoignent en pointe."""
    xl, xr = cx - width / 2, cx + width / 2
    r = width * radius_factor
    # Ligne de naissance des arcs, calculée pour que la pointe tombe sur top_y.
    rise = math.sqrt(r * r - (r - width / 2) ** 2)
    y0 = top_y + rise
    pts = [(xl, bottom_y), (xl, y0)]
    # Arc gauche : centre (xl + r, y0), de 180° jusqu'à la pointe.
    a_end = math.acos((cx - (xl + r)) / r)  # angle de la pointe
    for i in range(steps + 1):
        a = math.pi - (math.pi - a_end) * i / steps
        pts.append((xl + r + r * math.cos(a), y0 - r * math.sin(a)))
    # Arc droit : symétrique.
    for i in range(steps + 1):
        a = a_end + (math.pi - a_end) * i / steps
        x, y = xr - r - r * math.cos(a), y0 - r * math.sin(a)
        pts.append((x, y))
    pts += [(xr, y0), (xr, bottom_y)]
    return pts


def crescent_mask(size, cx, cy, r, offset, inner_ratio=0.86, angle_deg=-30):
    """Croissant : disque moins un disque décalé (ouverture vers [angle])."""
    m = Image.new('L', (size, size), 0)
    d = ImageDraw.Draw(m)
    d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=255)
    a = math.radians(angle_deg)
    ox, oy = cx + offset * math.cos(a), cy + offset * math.sin(a)
    ri = r * inner_ratio
    d.ellipse([ox - ri, oy - ri, ox + ri, oy + ri], fill=0)
    return m


def star_polygon(cx, cy, r_out, r_in, points=8, rot=0.0):
    pts = []
    for i in range(points * 2):
        r = r_out if i % 2 == 0 else r_in
        a = rot + i * math.pi / points
        pts.append((cx + r * math.sin(a), cy - r * math.cos(a)))
    return pts


def glyph_masks(size, scale=1.0):
    """Masques (arche, croissant, étoile) centrés, pour une toile [size]."""
    s = size * scale
    c = size / 2
    arch = Image.new('L', (size, size), 0)
    width = s * 0.50
    top = c - s * 0.36
    bottom = c + s * 0.34
    ImageDraw.Draw(arch).polygon(arch_polygon(c, top, bottom, width), fill=255)
    # Croissant doré dans le haut de l'arche.
    moon = crescent_mask(size, c + s * 0.012, c - s * 0.04, s * 0.15, s * 0.075, angle_deg=-40)
    star = Image.new('L', (size, size), 0)
    ImageDraw.Draw(star).polygon(
        star_polygon(c + s * 0.055, c - s * 0.105, s * 0.045, s * 0.02, points=4), fill=255)
    return arch, moon, star


def compose(size, background=True, scale=1.0):
    big = size * SS
    arch, moon, star = glyph_masks(big, scale)
    if background:
        im = gradient(big // 8, EMERALD_TOP, EMERALD_BOTTOM).resize((big, big), Image.BICUBIC)
        im = im.convert('RGBA')
        # Ombre douce sous l'arche.
        shadow = arch.filter(ImageFilter.GaussianBlur(big * 0.02))
        sh = Image.new('RGBA', (big, big), (0, 0, 0, 0))
        sh.putalpha(shadow.point(lambda v: int(v * 0.35)))
        sh = ImageChops.offset(sh, 0, int(big * 0.012))
        im = Image.alpha_composite(im, sh)
    else:
        im = Image.new('RGBA', (big, big), (0, 0, 0, 0))
    cream = Image.new('RGBA', (big, big), CREAM + (255,))
    cream.putalpha(arch)
    im = Image.alpha_composite(im, cream)
    gold = gradient(big // 8, GOLD_LIGHT, GOLD).resize((big, big), Image.BICUBIC).convert('RGBA')
    both = ImageChops.lighter(moon, star)
    gold.putalpha(both)
    im = Image.alpha_composite(im, gold)
    return im.resize((size, size), Image.LANCZOS)


def monochrome(size, scale):
    big = size * SS
    arch, moon, star = glyph_masks(big, scale)
    # Arche blanche, croissant et étoile évidés.
    cut = ImageChops.lighter(moon, star)
    mask = ImageChops.subtract(arch, cut)
    im = Image.new('RGBA', (big, big), (255, 255, 255, 0))
    white = Image.new('RGBA', (big, big), (255, 255, 255, 255))
    white.putalpha(mask)
    im = Image.alpha_composite(im, white)
    return im.resize((size, size), Image.LANCZOS)


if __name__ == '__main__':
    # L'image approuvée est la source ; ne jamais la remplacer par l'ancien dessin.
    source = Image.open(os.path.join(HERE, 'app_icon.png')).convert('RGB')
    source.resize((1024, 1024), Image.Resampling.LANCZOS).save(
        os.path.join(OUT, 'app_icon_foreground.png'))
    Image.new('RGB', (1024, 1024), (0, 57, 35)).save(
        os.path.join(OUT, 'app_icon_background.png'))
    # Icône de notification (barre d'état) : 24 dp, silhouette blanche.
    for folder, px in (('mdpi', 24), ('hdpi', 36), ('xhdpi', 48), ('xxhdpi', 72), ('xxxhdpi', 96)):
        d = os.path.join(RES, f'drawable-{folder}')
        os.makedirs(d, exist_ok=True)
        monochrome(px, 1.3).save(os.path.join(d, 'ic_stat_sakinah.png'))
    print('ok')
