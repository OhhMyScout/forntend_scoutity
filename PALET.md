# PALET WARNA — Scoutify

Dokumen ini merangkum **palet warna** yang digunakan/diturunkan dari tema Flutter pada proyek ini, supaya konsisten saat membuat **landing page** dan halaman UI lain.

Sumber utama palet:
- `lib/app/modules/theme/theme.dart` (`AppTheme` dan `AppTheme.light`)
- Komponen warna pendukung yang dipakai di beberapa view/game

---

## 1) Palet inti (Core Palette)

### A. Warna utama (Brand)
| Nama | Hex | Dipakai untuk |
|---|---:|---|
| `primary` | `#361F1A` | tombol primary, elemen utama, judul | 
| `secondary` | `#7D562D` | aksen, ikon/teks pendukung | 

### B. Warna latar (Background)
| Nama | Hex | Dipakai untuk |
|---|---:|---|
| `background` | `#FCF9F4` | `Scaffold` background, panel umum |

### C. Warna teks & permukaan (Surface/Text)
| Nama | Hex | Dipakai untuk |
|---|---:|---|
| `onSurfaceVariant` | `#504442` | body text / teks sekunder |
| `surfaceContainerLow` | `#F6F3EE` | card/section lembut, background turunan |
| `surfaceContainerHigh` | `#EBE8E3` | container lebih tegas dari low |
| `surfaceContainerHighest` | `#E5E2DD` | container tertinggi/kontras ringan |

### D. Garis & outline
| Nama | Hex | Dipakai untuk |
|---|---:|---|
| `outlineColor` | `#827471` | border/outline netral |
| `outlineVariantColor` | `#D4C3BF` | border outline varian lembut |

### E. Error
| Nama | Hex | Dipakai untuk |
|---|---:|---|
| `errorColor` | `#BA1A1A` | pesan error, status gagal |

---

## 2) Warna pendukung (UI Game / Komponen)

| Nama | Hex | Peruntukan yang disarankan |
|---|---:|---|
| `secondaryContainer` | `#FFCA98` | highlight kartu game, badge, area sekunder |
| `onSecondaryContainer` | `#7A532A` | teks di atas `secondaryContainer` |

> Catatan: warna-warna ini muncul sebagai tambahan “Tailwind-inspired” pada `AppTheme` untuk kebutuhan UI game.

---

## 3) Petunjuk pemakaian (Landing Page Guidance)

### Struktur rekomendasi
- **Hero/Top Section**
  - Background: `background` (`#FCF9F4`)
  - Judul besar: `primary` (`#361F1A`)
  - Subjudul/body: `onSurfaceVariant` (`#504442`)
  - CTA button (utama): tombol dengan `primary`

- **Section Konten**
  - Card/panel: `surfaceContainerLow` (`#F6F3EE`) atau `surfaceContainerHigh` (`#EBE8E3`)
  - Border card (opsional): `outlineVariantColor` (`#D4C3BF`)

- **Highlight/Badge**
  - Gunakan `secondaryContainer` (`#FFCA98`) untuk highlight
  - Teks di badge: `onSecondaryContainer` (`#7A532A`)

- **Footer / area ringan**
  - Background: `surfaceContainerLowest` (pakai `surfaceContainerLow`) atau tetap `background`
  - Outline/Divider: `outlineColor` (`#827471`)

### Warna aksi & feedback
- Tombol primary: `primary`
- Status error: `errorColor`

---

## 4) Template mapping ke `ThemeData` (Material 3)

Pada proyek ini, tema dibuat menggunakan `useMaterial3: true` dengan `ColorScheme.light` yang diisi seperti berikut:
- `primary` = `#361F1A`
- `secondary` = `#7D562D`
- `secondaryContainer` = `#FFCA98`
- `onSecondaryContainer` = `#7A532A`
- `surface` = `#FCF9F4`
- `surfaceContainerLow` = `#F6F3EE`
- `surfaceContainerHigh` = `#EBE8E3`
- `surfaceContainerHighest` = `#E5E2DD`
- `outline` = `#827471`
- `outlineVariant` = `#D4C3BF`
- `error` = `#BA1A1A`

Untuk konsistensi landing page, sarankan **gunakan**:
- `Theme.of(context).colorScheme.primary` untuk warna utama
- `Theme.of(context).colorScheme.secondary` / `secondaryContainer` untuk aksen
- `Theme.of(context).colorScheme.surfaceContainerLow/High` untuk card
- `Theme.of(context).colorScheme.outlineVariant` untuk border ringan

---

## 5) Daftar ringkas (Quick Reference)

- **Primary** `#361F1A`
- **Secondary** `#7D562D`
- **Background** `#FCF9F4`
- **On Surface Variant** `#504442`
- **Secondary Container** `#FFCA98`
- **On Secondary Container** `#7A532A`
- **Surface Container Low** `#F6F3EE`
- **Surface Container High** `#EBE8E3`
- **Surface Container Highest** `#E5E2DD`
- **Outline** `#827471`
- **Outline Variant** `#D4C3BF`
- **Error** `#BA1A1A`

---

## 6) Checklist konsistensi (sebelum finalisasi landing)

- [ ] Judul/CTA utama pakai **primary** `#361F1A`
- [ ] Body text pakai **onSurfaceVariant** `#504442`
- [ ] Card/section pakai `surfaceContainerLow`/`surfaceContainerHigh`
- [ ] Highlight/badge pakai `secondaryContainer` `#FFCA98`
- [ ] Border pakai `outlineVariantColor` `#D4C3BF`
- [ ] Error pakai `errorColor` `#BA1A1A`

---

## 7) Catatan
Dokumen ini bersifat **sumber kebenaran** (single source of truth) untuk palet warna landing page agar tidak muncul “warna liar” (hex berbeda) yang tidak sengaja.

