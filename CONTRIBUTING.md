# Contributing to Ease State Helper

## Setup

```bash
# Install Melos
dart pub global activate melos

# Bootstrap
melos bootstrap

# Run code generation
melos run generate

# Verify
melos run test:all
```

## Development

```bash
# Create branch
git checkout -b feature/your-feature

# After changes
melos run generate   # if modified generator
melos run test:all
melos run analyze
melos run format
```

## Commit Messages

Format: `type: description`

Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`

```
feat: add selector method generation
fix: handle disposed listeners
docs: update installation instructions
```


## Testing

```bash
melos run test:all
```

Generator tests use `source_gen_test`:

```dart
@ShouldGenerate(r'''expected output''')
@ease()
class TestClass extends StateNotifier<int> { ... }
```
