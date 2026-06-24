# Scoutify

## Update Project ke GitHub

### Cek Branch Aktif

```bash
git branch
```

### Ambil Update Terbaru dari Remote

```bash
git pull
```

### Simpan Perubahan

```bash
git add .
git commit -m "Deskripsi perubahan"
```

### Push Perubahan

```bash
git push
```

## Membuat Branch Baru

```bash
git checkout -b nama-branch
git push -u origin nama-branch
```

## Pindah Branch

```bash
git switch nama-branch
```

atau

```bash
git checkout nama-branch
```

## Cek Status Repository

```bash
git status
```

## Catatan

Pastikan file berikut tidak ikut ter-push:

```text
.env
build/
.dart_tool/
```

Jika ada perubahan dari anggota tim lain, selalu lakukan:

```bash
git pull
```

sebelum melakukan:

```bash
git push
```
