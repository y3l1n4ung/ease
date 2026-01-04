import * as vscode from 'vscode';
import * as path from 'path';
import * as fs from 'fs';
import { getEaseFileTemplate } from '../templates/easeFile';

/**
 * Regenerates the .ease.dart file by parsing the main .dart file
 * to extract the class name and state type
 */
export async function regenerateEaseFile(uri: vscode.Uri): Promise<void> {
  const filePath = uri.fsPath;

  // Must be a .dart file (not .ease.dart)
  if (!filePath.endsWith('.dart') || filePath.endsWith('.ease.dart')) {
    vscode.window.showErrorMessage('Please select a ViewModel .dart file (not .ease.dart)');
    return;
  }

  try {
    // Read the main dart file
    const content = fs.readFileSync(filePath, 'utf-8');

    // Parse class name and state type using regex
    // Matches: class ClassName extends StateNotifier<StateType>
    const classMatch = content.match(/class\s+(\w+)\s+extends\s+StateNotifier<([^>]+)>/);

    if (!classMatch) {
      vscode.window.showErrorMessage(
        'Could not find StateNotifier class. Expected: class MyViewModel extends StateNotifier<MyState>'
      );
      return;
    }

    const className = classMatch[1];
    const stateType = classMatch[2].trim();

    // Get file name without extension
    const fileName = path.basename(filePath, '.dart');
    const easeFilePath = filePath.replace('.dart', '.ease.dart');

    // Generate new .ease.dart content
    const easeContent = getEaseFileTemplate(className, fileName, stateType);

    // Write the file
    fs.writeFileSync(easeFilePath, easeContent);

    vscode.window.showInformationMessage(
      `Regenerated ${fileName}.ease.dart with state type: ${stateType}`
    );

    // Optionally open the file
    const doc = await vscode.workspace.openTextDocument(easeFilePath);
    await vscode.window.showTextDocument(doc, { preview: false });

  } catch (error) {
    vscode.window.showErrorMessage(`Failed to regenerate: ${error}`);
  }
}
