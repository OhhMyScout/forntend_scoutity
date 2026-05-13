# TODO - Routing & Navigation Connect

## Step 1: Audit routes (GetX)
- [x] Review `lib/app/routes/app_pages.dart` to list all registered `GetPage` routes.
- [x] Review `lib/app/routes/app_routes.dart` to confirm constants in `Routes`.

## Step 2: Replace hardcoded navigation with `Routes.*`
- [x] Update Home menu navigation to use `Routes.BERANDA_*`.
- [x] Update TabBar global navigation to use `Routes.*`.
- [ ] Remove/replace any other string routes (scan remaining views/controllers).


## Step 3: Ensure Home menu connects to all pages
- [x] Identified `HomeView` grid navigation via `_navigateByIndex`.
- [ ] Update `HomeController.menuItems` to include route mapping for every menu item.
- [ ] Update `_navigateByIndex` to handle every menu item and navigate to correct registered pages.

## Step 4: Ensure bottom/tab navigation (global)
- [ ] Review `lib/app/modules/theme/tabbar.dart` and connect each tab button to the correct `Routes.*` screens.

## Step 5: Validate other views/controllers
- [ ] Search for remaining `Get.toNamed('/...')` and patch them.
- [ ] Add missing navigation buttons if views contain UI elements that should navigate.

## Step 6: Build/test
- [ ] Run `flutter analyze`.
- [ ] Run `flutter test` (if available).
- [ ] Run app locally and verify navigation.

