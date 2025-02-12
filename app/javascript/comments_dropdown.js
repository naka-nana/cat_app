function setupDropdownListeners() {
  // 既存のイベントリスナーを削除
  document.querySelectorAll(".dropdown-icon").forEach(icon => {
    icon.removeEventListener("click", toggleDropdown); // 既存のリスナー削除
    icon.addEventListener("click", toggleDropdown); // 新しく追加
  });
}

function toggleDropdown(event) {
  const icon = event.currentTarget;
  const menuId = icon.id.replace("dropdown-icon-", "dropdown-menu-");
  const menu = document.getElementById(menuId);

  // 他のメニューを閉じる
  document.querySelectorAll(".dropdown-menu").forEach(m => {
    if (m !== menu) m.classList.remove("show");
  });

  // 現在のメニューの表示・非表示を切り替え
  menu.classList.toggle("show");
}
// ✅ `window` に登録してグローバルスコープで使えるようにする
window.setupDropdownListeners = setupDropdownListeners;
// 初回ロード時の設定
document.addEventListener("DOMContentLoaded", setupDropdownListeners);

// Turbo Driveがロードされるたびに再設定
document.addEventListener("turbo:load", setupDropdownListeners);
document.addEventListener("turbo:frame-load", setupDropdownListeners);

