Release Process
===============

Process for releasing new versions.


Version
-------
The following files must be updated with the `N.E.W` version:
+ `VERSION`: Version used by the documentation scripts.
+ `readme.md`: Link to latest, and all example links.
+ `documentation.md`: Add released versions and update latest.
+ `release-notes.md`: Add notes of latest.
+ `.spi.yml`: Swift Package Index documentation.
+ `deploy-pages.yml`: In the docs worktree, link to display after documentation is built and deployed to Github pages.



Builds and Tests
----------------
+ Package project must build and test successfully in Xcode.
+ Illustrations-App must build and test successfully.
+ Documentation must build without warnings. 



Rebuild Documentation
---------------------
Rebuild documentation:
```zsh
./scripts/generate-static-docs
```

Verify build documentation:
```zsh
./scripts/serve-documentation
```

+ In the documentation worktree, commit and push to a `documentation/vN.E.W` branch.
+ Run the documentation build in GitHub for this branch. `N.E.W` documentation should be available afterwards.


### Other Documents
+ Confirm `release-notes.md` has a `N.E.W` section complete.
+ Confirm last release has been dated.



Branches and Merges
-------------------

+ Merge all `feature/name` branches into `develop`. All pull-requests must use a _squash_ merge.
+ Create and merge a `Release N.E.W - Description` pull request into `main`. This pull request must use a _merge_ commit.
+ Create release for `PreviewUtilities N.E.W` from `main`.
+ Create a `BackMerge N.E.W` from `main` into `develop`, with a merge-commit.


### Documentation

+ Create a `Documentation N.E.W` pull request from `documentation/N.E.W` to `documentation/main`. This pull request must use a _squash_ commit.
+ The push to `main` should trigger an automatic documentation build.
+ Update `documentation/develop` with the latest `main`. This update should be a _fast-forward_.
