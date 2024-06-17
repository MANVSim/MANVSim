export type StorageItem = "token" | "user"

export function getStorageItem<Item extends StorageItem>(
  item: Item,
): string | null {
  return localStorage.getItem(item)
}

export function setStorageItem<Item extends StorageItem>(
  key: Item,
  value: string,
) {
  localStorage.setItem(key, value)
}
