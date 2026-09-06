# -*- coding: utf-8 -*-
import math
import re

with open('/Users/sierra/Documents/photography-field-guide/index.html', 'r', encoding='utf-8') as f:
    html = f.read()

# 1. Check Scene count
scenes = re.findall(r'<article class="scene-card"', html)
print(f"Total scene cards found: {len(scenes)}")
assert len(scenes) == 25, f"Expected 25 scenes, got {len(scenes)}"

assert '<span id="count-all">25</span>' in html, "Scene counter should show 25"

# 2. Check scenes coverage
assert '135mm / 200mm' in html
assert '海岸岩石慢門與海浪拉絲' in html
assert '壯麗雪景與高調雪山' in html
assert '超長焦巨型懸日與懸月' in html
assert '博物館、水族館與玻璃展櫃' in html
assert '櫻花、楓葉與花卉花海' in html
assert '航空飛機與鐵道火車' in html
assert '閃電暴風與雷雨夜空' in html
assert '旋轉星軌與同心圓天體' in html

# 3. Check updated zone focus & group photo
assert '超焦距約為 <strong>5.1 公尺</strong>' in html
assert '2.24 m' in html
assert '2.71 m' in html
assert '4.95 m' in html

# 4. Check Timer enhancements
assert 'navigator.wakeLock' in html
assert 'initAudioContext' in html
assert 'visibilitychange' in html

# 5. Check Viewport
assert 'user-scalable=no' not in html

# 6. Verify DoF Mathematical Formulas:
c = 0.030
f_val = 50.0
N = 7.1
s = 3500.0

H = ((f_val * f_val) / (N * c)) + f_val # in mm
assert round(H / 1000, 2) == 11.79, f"Expected H=11.79m, got {H/1000}"

Dn = (H * s) / (H + (s - f_val))
assert round(Dn / 1000, 2) == 2.71, f"Expected Dn=2.71m, got {Dn/1000}"

Df = (H * s) / (H - (s - f_val))
assert round(Df / 1000, 2) == 4.95, f"Expected Df=4.95m, got {Df/1000}"

total_dof = (Df - Dn) / 1000
assert round(total_dof, 2) == 2.24, f"Expected DoF=2.24m, got {total_dof}"

# Test 35mm f/8:
H_35 = ((35.0 * 35.0) / (8.0 * 0.030)) + 35.0
print(f"35mm f/8 Hyperfocal Distance: {H_35/1000:.2f}m")
assert 5.1 <= (H_35/1000) <= 5.2

# Test NPF Rule: 16mm, f/2.8, 24MP full-frame
p = (35.9 / math.sqrt(24 * 1000000 * 1.5)) * 1000
t_npf = (35 * 2.8 + 30 * p) / 16.0
print(f"NPF 16mm f/2.8 on 24MP: {t_npf:.2f}s")
assert 10 <= t_npf <= 20

# Test ND filter 6 stops from 1/60s:
t_nd64 = (1/60) * (2 ** 6)
assert round(t_nd64, 2) == 1.07

# 7. Test Gear Separation and Click-to-Filter Scene Logic:
scene_tags = re.findall(r'<article class="scene-card"[^>]+>', html)
assert len(scene_tags) == 25
for s in scene_tags:
    assert 'data-lenses=' in s, f"Scene missing data-lenses: {s}"
    assert 'data-filters=' in s, f"Scene missing data-filters: {s}"

assert 'toggleGearLensFilter' in html, "Missing toggleGearLensFilter"
assert 'toggleGearFilterFilter' in html, "Missing toggleGearFilterFilter"
assert 'activeGearFilterNotice' in html, "Missing activeGearFilterNotice"
assert '專屬鏡頭庫' in html, "Lenses should be separated into dedicated section"
assert '光學濾鏡庫' in html, "Filters should be separated into dedicated section"

# 8. Test Lens Sweet Spots, MFD, and Sunstars
assert '光學甜區 (Sweet Spot) 與星芒速查對照表' in html
assert '0.21m (24端) / 0.30m (70端)' in html
assert 'f/8 – f/11 (f/8即成形！不必縮f/16)' in html
assert '4.51' in html
assert '已備 電子定時快門線' in html
assert '拍攝日食/日環食絕對安全紅線' in html
assert '現代數位攝影核心流派：極限後製、多張疊圖' in html

print("All 25 scenes, UI features, optical formulas, lens sweet spots, and gear filtering verified perfectly!")
