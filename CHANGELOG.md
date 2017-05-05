### NEXT

### 0.6.0

**breaking changes** renames all api stuff under lib to models (includes, of course, the namespace):
  - `lib/api.rb` -> `lib/models.rb`
  - `lib/api/` -> `lib/models/`

### < 0.5.4

- simplyfies request specs, **breaking change**: takes route from spec description
- adds option to set prefix, defaults to api
- sets prefix after project name
- refactores rack api mounting
- adds ruby 2.4.0 support
- server command supports port, thin tag would be named after project
- adds redoc oapi documentation viewer
- default rake task now only spec, rubocop would be done via hound
- adds hound ci service
- fix: add mount point to api base
- adds inch.yml
- improves specs
- fix: removes mount point from api base
- renames `remove` to `rm`
- adds params to POST, PUT and PATCH specs
- removes duplication and warning
- allows entity removing
- adds `remove` command
- adds request specs shared examples
- corrects path param for specific endpoints
- corrects adding of endpoints, if no http verb was given
- adds flag for entity creating
- moves back dependencies to gemspec
- adds rubygems badge
- cleans up dependencies
- adds `force` option to add
- adds specifying http verbs
