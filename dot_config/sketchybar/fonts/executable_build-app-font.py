#!/usr/bin/env python3
"""Patch sketchybar-app-font with extra icons from this folder.

Every <name>.svg here (viewBox 0 0 1000 1000, filled path) becomes a ligature
":<name>:" in a copy of the installed sketchybar-app-font, saved under its own
family name so Homebrew upgrades to the original font never clobber it.

    python3 ~/.config/sketchybar/fonts/build-app-font.py && sketchybar --reload

Re-run after `brew upgrade font-sketchybar-app-font` to pick up new upstream icons.
"""
import glob, os, re, sys
from fontTools.ttLib import TTFont
from fontTools.pens.ttGlyphPen import TTGlyphPen
from fontTools.pens.cu2quPen import Cu2QuPen
from fontTools.pens.transformPen import TransformPen
from fontTools.svgLib.path import parse_path
from fontTools.ttLib.tables.otTables import Ligature

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.expanduser("~/Library/Fonts/sketchybar-app-font.ttf")
FAMILY = "sketchybar-app-font-plus"
OUT = os.path.expanduser(f"~/Library/Fonts/{FAMILY}.ttf")

font = TTFont(SRC)
order = font.getGlyphOrder()
glyf, hmtx = font["glyf"], font["hmtx"]
advance = hmtx[":default:"][0]                     # every icon shares one advance width
lig = font["GSUB"].table.LookupList.Lookup[0].SubTable[0].ligatures[":"]
cmap = font.getBestCmap()

for svg in sorted(glob.glob(os.path.join(HERE, "*.svg"))):
    name = os.path.splitext(os.path.basename(svg))[0]
    gname = f":{name}:"
    pen = TTGlyphPen(None)
    # SVG is y-down 0..1000; font is y-up 0..1000
    d = " ".join(re.findall(r'\sd="([^"]+)"', open(svg).read()))
    parse_path(d, TransformPen(Cu2QuPen(pen, max_err=1.0, reverse_direction=True), (1, 0, 0, -1, 0, 1000)))
    glyf[gname] = pen.glyph()
    if gname not in order:
        order.append(gname)
    glyf[gname].recalcBounds(glyf)
    hmtx[gname] = (advance, glyf[gname].xMin)
    comps = [cmap[ord(c)] for c in name] + [cmap[ord(":")]]
    lig[:] = [l for l in lig if l.LigGlyph != gname]
    new = Ligature(); new.Component = comps; new.LigGlyph = gname
    lig.insert(0, new)                              # longest-match order doesn't matter: names end in ':'
    print(f"added {gname}")

font.setGlyphOrder(order)
font["maxp"].numGlyphs = len(order)
for rec in font["name"].names:                      # rename family so it can coexist with upstream
    if rec.nameID in (1, 3, 4, 6, 16):
        rec.string = FAMILY
font.save(OUT)
print(f"wrote {OUT}")
