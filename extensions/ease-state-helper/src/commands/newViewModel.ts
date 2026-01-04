import * as vscode from 'vscode';
import * as path from 'path';
import * as fs from 'fs';
import { toSnakeCase, ensureViewModelSuffix } from '../utils/naming';
import { getViewModelTemplate } from '../templates/viewModel';
import { getEaseFileTemplate } from '../templates/easeFile';

/**
 * Creates a new ViewModel with its .ease.dart file
 */
export async function newViewModel(uri: vscode.Uri | undefined): Promise<void> {
  // Get the target folder
  let targetFolder: string;

  if (uri) {
    targetFolder = uri.fsPath;
  } else {
    // If no URI, prompt for folder
    const workspaceFolders = vscode.workspace.workspaceFolders;
    if (!workspaceFolders) {
      vscode.window.showErrorMessage('No workspace folder open');
      return;
    }
    targetFolder = workspaceFolders[0].uri.fsPath;
  }

  // Prompt for ViewModel name
  const name = await vscode.window.showInputBox({
    prompt: 'Enter ViewModel name (e.g., Counter, Cart, Auth)',
    placeHolder: 'Counter',
    validateInput: (value) => {
      if (!value) {
        return 'Name is required';
      }
      if (!/^[A-Z][a-zA-Z0-9]*$/.test(value.replace('ViewModel', ''))) {
        return 'Name must start with uppercase letter and contain only alphanumeric characters';
      }
      return null;
    }
  });

  if (!name) {
    return;
  }

  // Prompt for state type
  const stateType = await vscode.window.showInputBox({
    prompt: 'Enter state type (e.g., int, String, CartState)',
    placeHolder: 'int',
    value: 'int',
    validateInput: (value) => {
      if (!value) {
        return 'State type is required';
      }
      return null;
    }
  });

  if (!stateType) {
    return;
  }

  // Generate file names
  const className = ensureViewModelSuffix(name);
  const snakeName = toSnakeCase(className);
  const fileName = snakeName;

  const dartFilePath = path.join(targetFolder, `${fileName}.dart`);
  const easeFilePath = path.join(targetFolder, `${fileName}.ease.dart`);

  // Check if files already exist
  if (fs.existsSync(dartFilePath) || fs.existsSync(easeFilePath)) {
    const overwrite = await vscode.window.showWarningMessage(
      `Files already exist. Overwrite?`,
      'Yes',
      'No'
    );
    if (overwrite !== 'Yes') {
      return;
    }
  }

  // Generate file contents
  const dartContent = getViewModelTemplate(className, fileName, stateType);
  const easeContent = getEaseFileTemplate(className, fileName, stateType);

  try {
    // Write files
    fs.writeFileSync(dartFilePath, dartContent);
    fs.writeFileSync(easeFilePath, easeContent);

    // Open the main dart file
    const doc = await vscode.workspace.openTextDocument(dartFilePath);
    await vscode.window.showTextDocument(doc);

    vscode.window.showInformationMessage(
      `Created ${className} with ${fileName}.dart and ${fileName}.ease.dart`
    );
  } catch (error) {
    vscode.window.showErrorMessage(`Failed to create files: ${error}`);
  }
}
