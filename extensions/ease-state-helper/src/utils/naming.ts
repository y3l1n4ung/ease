/**
 * Converts PascalCase to camelCase
 * Example: CounterViewModel -> counterViewModel
 */
export function toCamelCase(text: string): string {
  if (!text) {
    return text;
  }
  return text[0].toLowerCase() + text.slice(1);
}

/**
 * Converts PascalCase to snake_case
 * Example: CounterViewModel -> counter_view_model
 */
export function toSnakeCase(text: string): string {
  if (!text) {
    return text;
  }
  return text
    .replace(/([A-Z])/g, '_$1')
    .toLowerCase()
    .replace(/^_/, '');
}

/**
 * Converts snake_case to PascalCase
 * Example: counter_view_model -> CounterViewModel
 */
export function toPascalCase(text: string): string {
  if (!text) {
    return text;
  }
  return text
    .split('_')
    .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
    .join('');
}

/**
 * Ensures the name ends with ViewModel
 * Example: Counter -> CounterViewModel
 */
export function ensureViewModelSuffix(name: string): string {
  if (name.endsWith('ViewModel')) {
    return name;
  }
  return name + 'ViewModel';
}
