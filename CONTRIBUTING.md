# Contributing to Ease

Thank you for your interest in contributing to Ease! This document provides guidelines and instructions for contributing.

## Getting Started

### Prerequisites

- Flutter SDK (>=3.22.0)
- Dart SDK (>=3.5.0)
- [Melos](https://melos.invertase.dev/) for monorepo management

### Setup

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/ease.git
   cd ease
   ```

3. Install Melos:
   ```bash
   dart pub global activate melos
   ```

4. Bootstrap the project:
   ```bash
   melos bootstrap
   ```

5. Run code generation:
   ```bash
   melos run generate
   ```

6. Verify everything works:
   ```bash
   melos run test:all
   melos run analyze
   ```

## Development Workflow

### Making Changes

1. Create a new branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes

3. Run code generation if you modified generator:
   ```bash
   melos run generate
   ```

4. Run tests:
   ```bash
   melos run test:all
   ```

5. Check for analysis issues:
   ```bash
   melos run analyze
   ```

6. Format your code:
   ```bash
   melos run format
   ```

### Commit Messages

We follow conventional commits. Format: `type(scope): description`

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

Examples:
```
feat(generator): add selector method generation
fix(state_notifier): handle disposed listeners
docs(readme): update installation instructions
```

### Pull Requests

1. Push your branch:
   ```bash
   git push origin feature/your-feature-name
   ```

2. Open a Pull Request on GitHub

3. Fill in the PR template with:
   - Description of changes
   - Related issues
   - Testing done
   - Screenshots (if UI changes)

4. Wait for CI checks to pass

5. Request review from maintainers

## Project Structure

```
packages/
├── ease/                  # Core runtime library
├── ease_annotation/       # @ease annotation
├── ease_generator/        # Code generator
└── ease_devtools_extension/  # DevTools UI

apps/
└── example/               # Example application
```

## Testing

### Unit Tests

```bash
# Run all tests
melos run test:all

# Run specific package tests
cd packages/ease && flutter test
cd packages/ease_generator && dart test
```

### Generator Tests

Generator tests use `source_gen_test`:

```dart
@ShouldGenerate(r'''expected output''')
@ease
class TestClass extends StateNotifier<int> { ... }
```

## Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use `dart format` for formatting
- Keep lines under 80 characters
- Add documentation for public APIs

## Reporting Issues

When reporting issues, please include:

1. Ease version
2. Flutter/Dart version
3. Minimal reproduction code
4. Expected vs actual behavior
5. Error messages/stack traces

## Questions?

Feel free to open a [Discussion](https://github.com/b14ckc0d3/ease/discussions) for questions or ideas.

Thank you for contributing!
