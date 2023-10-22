### NEXT

- contributions

### v2.0.0 / 2023-10-21 Imports OApi specs

- [(#38)](https://github.com/LeFnord/grape-starter/pull/38) Handles nested body [LeFnord](https://github.com/LeFnord)
- [(#38)](https://github.com/LeFnord/grape-starter/pull/38) Handle parameters from request body [LeFnord](https://github.com/LeFnord)
- [(#37)](https://github.com/LeFnord/grape-starter/pull/37) Ignores possible version segments in path [LeFnord](https://github.com/LeFnord)
- Sets min ruby to 3.1 [LeFnord](https://github.com/LeFnord)
- [(#36)](https://github.com/LeFnord/grape-starter/pull/36) Handle Parameters [LeFnord](https://github.com/LeFnord)
- Avoids duplicated mount points. [LeFnord](https://github.com/LeFnord)
- Small code smells [LeFnord](https://github.com/LeFnord)
- Sets next version to 2.0.0 [LeFnord](https://github.com/LeFnord)
- [(#31)](https://github.com/LeFnord/grape-starter/pull/31) Import OAPI spec [LeFnord](https://github.com/LeFnord)
- Fix for Dockerfile smell DL3020 [#35](https://github.com/LeFnord/grape-starter/pull/35) [Giovanni Rosa](https://github.com/grosa1)

### v1.6.2 / 2023-03-12

- [(#34)](https://github.com/LeFnord/grape-starter/pull/34) Makes Names a class [LeFnord](https://github.com/LeFnord)
- Re-organises libe files. [LeFnord](https://github.com/LeFnord)
- Minor clean up. [LeFnord](https://github.com/LeFnord)

### v1.6.1 / 2023-02-17 -> yanked

### v1.6.0 / 2023-02-13

- [(#33)](https://github.com/LeFnord/grape-starter/pull/33) Replaces Thin by Puma [LeFnord](https://github.com/LeFnord)
- Minor lint fix. [LeFnord](https://github.com/LeFnord)
- [(#32)](https://github.com/LeFnord/grape-starter/pull/32) Uses Zeitwerk for loading [LeFnord](https://github.com/LeFnord)

### v1.5.2 / 2023-02-11

- Upgrades action. [LeFnord](https://github.com/LeFnord)
- Uses ruby 3.2 [LeFnord](https://github.com/LeFnord)

### v1.5.1 / 2021-12-28

- Fixes ActiveSupport in template. [LeFnord](https://github.com/LeFnord)

### v1.5.0 / 2021-12-28

- Sets minimum ruby version to 2.7 [LeFnord](https://github.com/LeFnord)
- Fixes: uninitialized constant ActiveSupport::XmlMini::IsolatedExecutionState. [LeFnord](https://github.com/LeFnord)
- Sets path via config in Dockerfile. [LeFnord](https://github.com/LeFnord)

### v1.4.3 / 2021-12-20

- Fixes shared mexamples for delete. [LeFnord](https://github.com/LeFnord)

### v1.4.2 / 2021-12-20

- Fixes active-support version to > 6 and < 7. [LeFnord](https://github.com/LeFnord)

### v1.4.1 / 2021-12-17 -> yanked

- Upgrades active-support version. [LeFnord](https://github.com/LeFnord)

### v1.4.0 / 2021-04-08

- Removes `standalone_migration` in favour of AR tasks. [LeFnord](https://github.com/LeFnord)
- Minor README improvements. [LeFnord](https://github.com/LeFnord)
- Adds GH actions for rspec and rubocop. [LeFnord](https://github.com/LeFnord)

### v1.3.0 / 2020-09-15

- Fixes migration name. [LeFnord](https://github.com/LeFnord)
- Fixes rubocop new cops handling. [LeFnord](https://github.com/LeFnord)

### v1.2.4–v1.2.6 / 2020-01-18–2020-08-13

- Prepapre releaase 1.2.6 [LeFnord](https://github.com/LeFnord)
- Updates used default rails deps versions. [LeFnord](https://github.com/LeFnord)
- Create dependabot.yml [peter scholz](https://github.com/LeFnord)
- Prepare release 1.2.5 [LeFnord](https://github.com/LeFnord)
- Minor improvements. [LeFnord](https://github.com/LeFnord)
- Lets run GH actions again. [LeFnord](https://github.com/LeFnord)
- Minor template improvements. [LeFnord](https://github.com/LeFnord)
- Changes ruby.yml to use 2.7 [LeFnord](https://github.com/LeFnord)
- Prepare release 1.2.4 [LeFnord](https://github.com/LeFnord)
- Respects froozen string stuff. [LeFnord](https://github.com/LeFnord)
- [(#23)](https://github.com/LeFnord/grape-starter/pull/23) Updates Ruby and deps [LeFnord](https://github.com/LeFnord)
- Create ruby.yml [LeFnord](https://github.com/LeFnord)

- Fixes gems for sequel. [LeFnord](https://github.com/LeFnord)
- Minor template improvements. [LeFnord](https://github.com/LeFnord)

### v1.2.3 / 2019-12-15

- Removes require pry. [LeFnord](https://github.com/LeFnord) closes [!21](https://github.com/LeFnord/grape-starter/issues/21)
- [#22](https://github.com/LeFnord/grape-starter/pull/22) - accomodate activerecord 6.0 [#22](https://github.com/LeFnord/grape-starter/pull/22) [Ignacio Carrera](https://github.com/nachokb)

### v1.2.2 / 2019-02-28

- Fixes loading of `aplication` instead of `environment` in `config.ru`
- [#19](https://github.com/LeFnord/grape-starter/pull/19) - Adds a module under lib as namespace. [LeFnord](https://github.com/LeFnord)

### v1.2.1 / 2019-02-24

- [#17](https://github.com/LeFnord/grape-starter/pull/17) - Fix script/server shebang for ubuntu. [rawongithub](https://github.com/rawongithub)

### v1.2.0 / 2019-02-24

- Code improvements, now `environment`, `application` and `boot` are used in a more expected way.

### v1.1.0 / 2019-02-22
- Replaces own migration tasks through [standalone-migrations](https://github.com/thuss/standalone-migrations)

### v1.0.3 / 2019-02-10
- Loosens reuby version to 2.4
- prepare release 1.0.2
- Cleans up travis ci.

### before

many things done …
