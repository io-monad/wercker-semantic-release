# wercker semantic-release step

A [wercker](http://wercker.com/) step to run [semantic-release](https://github.com/semantic-release/semantic-release)

This step assumes that your `package.json` has `semantic-release` script, which means `npm run semantic-release` on your project root is available. This is generally configured by [semantic-release-cli](https://github.com/semantic-release/cli).

## Usage

In `wercker.yml` of your application:

```yaml
build:
  steps:
    - io-monad/semantic-release:
        github_token: $GH_TOKEN
        npm_token: $NPM_TOKEN
        branch: master
```

`GH_TOKEN` and `NPM_TOKEN` are issued by [semantic-release-cli](https://github.com/semantic-release/cli) and should be set as [protected environment variables](http://devcenter.wercker.com/docs/environment-variables/protected-variables.html).

`branch` is a name of git branch you want to make a release. Note that this is a **build** step, not a deploy step. This is because you cannot call semantic-release in deploy steps due to empty symlinks in `node_modules/.bin`.

## Properties

| Key | Value | Required | Default |
| --- | ----- | -------- | ------- |
| `github_token` | Token value used as `GH_TOKEN` for semantic-release. | No | `$GH_TOKEN` env var |
| `npm_token` | Token value used as `NPM_TOKEN` for semantic-release. | No | `$NPM_TOKEN` env var |
| `branch` | Name of git branch to be released. | No | Any branch |
| `ignore_no_release` | Ignore `ENOCHANGE` (no release) error from semantic-release. | No | `true` |

## Note on ENOCHANGE error

This step ignores `ENOCHANGE` error from semantic-release by default.

`ENOCHANGE` means that semantic-release made no release because there are no relevant changes within commits.

Set `ignore_no_release` property to `false` if you want to treat `ENOCHANGE` as error.

## License

[The MIT License](LICENSE)
