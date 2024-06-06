# Setup linting, pre-commit hooks

```sh
chmod +x setup-hooks.sh
./setup-hooks.sh
```

## commit rules

Example:

```text
add(game): [#5] - commit message
```

* trailing: fix | add | wip | chore | refactor | doc | style | test | perf
* feature: optional - short feature name
* issue id: optional - issue id
* message: required - commit message

### Must format before commit

```sh
 dart fix --apply
```

## Generating Assets

```sh
dart run build_runner build
```

[flutter-flame-brick-breaker](https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker)
