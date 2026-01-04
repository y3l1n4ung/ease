import * as vscode from 'vscode';
import { newViewModel } from './commands/newViewModel';
import { regenerateEaseFile } from './commands/regenerateEaseFile';

/**
 * Called when the extension is activated
 */
export function activate(context: vscode.ExtensionContext) {
  console.log('Ease State Helper extension is now active');

  // Register commands
  const newViewModelCmd = vscode.commands.registerCommand(
    'ease.newViewModel',
    (uri: vscode.Uri) => newViewModel(uri)
  );

  const regenerateCmd = vscode.commands.registerCommand(
    'ease.regenerateEaseFile',
    (uri: vscode.Uri) => regenerateEaseFile(uri)
  );

  context.subscriptions.push(newViewModelCmd, regenerateCmd);
}

/**
 * Called when the extension is deactivated
 */
export function deactivate() {}
