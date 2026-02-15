# Contributing to Ease State Helper

First off, thank you for considering contributing to Ease! It's people like you that make Ease such a great tool.

## Ways to Contribute

- **Reporting Bugs**: If you find a bug, please use the [Bug Report template](.github/ISSUE_TEMPLATE/bug_report.md).
- **Suggesting Enhancements**: Have an idea? Use the [Feature Request template](.github/ISSUE_TEMPLATE/feature_request.md).
- **Improving Documentation**: Typos, better examples, or clearer explanations are always welcome.
- **Pull Requests**: We welcome PRs for both bug fixes and new features.

## Setup for Development

Ease uses [Melos](https://melos.invertase.dev/) to manage the monorepo.

```bash
# 1. Install Melos
dart pub global activate melos

# 2. Bootstrap the project (installs dependencies and links packages)
melos bootstrap

# 3. Run initial code generation
melos run generate
```

## Development Workflow

1.  **Create a branch**: `git checkout -b feature/your-feature-name` or `fix/your-fix-name`.
2.  **Make your changes**.
3.  **Run tests**: `melos run test:all`.
4.  **Verify code quality**:
    ```bash
    melos run analyze
    melos run format
    ```
5.  **Commit your changes**: Follow the [Conventional Commits](https://conventionalcommits.org) format.

## Commit Messages

Format: `type: description`

Types:
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that do not affect the meaning of the code (white-space, formatting, etc)
- `refactor`: A code change that neither fixes a bug nor adds a feature
- `perf`: A code change that improves performance
- `test`: Adding missing tests or correcting existing tests
- `chore`: Changes to the build process or auxiliary tools and libraries

Example: `feat: add selector method generation`

## Pull Request Process

1.  Ensure your code passes all tests and linting.
2.  Update the documentation if you're adding or changing a feature.
3.  The PR should ideally fix/implement a single thing.
4.  Once the PR is open, a maintainer will review it.

## Testing

We take testing seriously. Please ensure your contributions include relevant tests.

- **Unit Tests**: Most packages have a `test/` directory.
- **Generator Tests**: Use `source_gen_test` (see `packages/ease_generator/test`).

```bash
melos run test:all
```
