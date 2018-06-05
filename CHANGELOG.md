### NEXT

- contributions

### 1.0.1

- [00993](https://github.com/LeFnord/grape-starter/commit/6fef3812fd587ea61c29b9eacde1fb856ad00993) - adds a rudimentary Dockerfile as starting point

### 1.0.0

- [67a5f](https://github.com/LeFnord/grape-starter/commit/b1f32801844ed9a98bc4d5f7c938451ef7667a5f) - supports creating a migration file
- [de26b](https://github.com/LeFnord/grape-starter/commit/22ad2170176b9602cff2239a7d0469c823cde26b) - ci adoptions
- [7ad69](https://github.com/LeFnord/grape-starter/commit/925fa5fb161c8cc26c96834e185d8299a207ad69) - spec improvements

### 0.8.7

- [c7cb2](https://github.com/LeFnord/grape-starter/commit/4be5bd9b7c06611e096d6eaa23d7168136bc7cb2) - updates dependencies; makes rubocop happy
- [d9c6f](https://github.com/LeFnord/grape-starter/commit/2f97247767c3e76c4c33da50eec2ad160bed9c6f) - minor dependencies updates

### 0.8.6

- [362c9](https://github.com/LeFnord/grape-starter/commit/56035384befacb877e89e8a04f7bc62c9e7362c9) - fixes a sequel configuration bug with sqlite3
- [21892](https://github.com/LeFnord/grape-starter/commit/4e249978af71abba35e00b0d4e85ec6ffaa21892) - upgrades minimum ruby version to 2.3

### 0.8.5

- [cbea8](https://github.com/LeFnord/grape-starter/commit/fa5edb5dc7e0883ff099e297e9cbd5bd5ebcbea8) - DRYs up template code; passes rubocop 0.51.0

- [6bbe7](https://github.com/LeFnord/grape-starter/commit/a224b5d8dfa001cb1e8dec3b1a1e28fc9826bbe7) - avoids overriding of dev db by running specs; fixes syntox error

### 0.8.4

- [d8e13](https://github.com/LeFnord/grape-starter/commit/1f5faef958799704163b7db25db07c569cad8e13) -
  fixes error on configuration

- [6baba](https://github.com/LeFnord/grape-starter/commit/e00433dee97509e71c1685a0da9134ce2a66baba) -  
  minor re-working of Rakefile and initializer templates

### 0.8.3

- [3fe13](https://github.com/LeFnord/grape-starter/commit/3fe134c6ce0666dfd86165b5d2c1a219a4629862) - improves sequel rake tasks

### 0.8.2

- [48458…](https://github.com/LeFnord/grape-starter/commit/48458938a341660453052660448a058aee0f8e81) - handles Sequel deprecation warning

### 0.8.1

- [6b16c…](https://github.com/LeFnord/grape-starter/commit/6b16c0bf38e4cad8d486e805269157dcbaefbb64) - removes default ORM value, minor corrections

### 0.8.0

- [#15](https://github.com/LeFnord/grape-starter/pull/15), [2af09…](https://github.com/LeFnord/grape-starter/commit/2af09dddf97f756e96c80c745ee68aad5ab4ccc3) **breaking change** prefix option on create is optional, no default
- [#12](https://github.com/LeFnord/grape-starter/pull/12) - Add base configuration for ActiveRecord - ([@terry90](https://github.com/terry90))

### 0.7.0

- [212e6…](https://github.com/LeFnord/grape-starter/commit/212e6245e10598efe286143dac39f46134c58c54) - makes mounting of doc more secure
- [f3bb6…](https://github.com/LeFnord/grape-starter/commit/f3bb63fdee79df4552316524b1ac3adaebab811a) - adds orm option so that the `add` resource command can optional use configured ORM
- [af138…](https://github.com/LeFnord/grape-starter/commit/af1388ae6479b81646c56ac55f856ea275dc9817) - resource respects configured orm
- [5ac74…](https://github.com/LeFnord/grape-starter/commit/5ac747a7fb44d97eedbeba1e7a11e475846d7743) - improve README
- [eb33c…](https://github.com/LeFnord/grape-starter/commit/eb33c910c623b34db54ccb64ee59af4c639029e4) - adds base storing of configuration
- [751aa…](https://github.com/LeFnord/grape-starter/commit/751aa8ae929bed0ff66ac9830468279238bec252) - adding option to add Sequel support
- [354e6…](https://github.com/LeFnord/grape-starter/commit/354e63abd77751fe0f3a1b405bb49ab754ab1522) - re-organizing of template files
- [6e33e…](https://github.com/LeFnord/grape-starter/commit/6e33e8137aa293eef66913c50010c53d284a0d8d) - Add awesome_print dependency ([@terry90](https://github.com/terry90))

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
