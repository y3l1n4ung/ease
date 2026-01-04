/**
 * Template for the main ViewModel .dart file
 * No annotation needed - the .ease.dart file is scaffolded directly
 */
export function getViewModelTemplate(
  className: string,
  fileName: string,
  stateType: string,
  isLocal: boolean = false
): string {
  const initialValue = getInitialValue(stateType);

  return `import 'package:ease_state_helper/ease_state_helper.dart';

part '${fileName}.ease.dart';

class ${className} extends StateNotifier<${stateType}> {
  ${className}() : super(${initialValue});
}
`;
}

/**
 * Get a sensible initial value based on the state type
 */
function getInitialValue(stateType: string): string {
  switch (stateType) {
    case 'int':
      return '0';
    case 'double':
      return '0.0';
    case 'String':
      return "''";
    case 'bool':
      return 'false';
    case 'List':
      return 'const []';
    case 'Map':
      return 'const {}';
    default:
      // For custom types like CartState, assume they have a const constructor
      return `const ${stateType}()`;
  }
}
