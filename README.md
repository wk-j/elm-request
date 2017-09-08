## Request

```bash
# create project
elm-package install elm-lang/http

# build
elm-make src/Index.elm --output=dist/main.js

cp src/Index.html dist

# watch
watchman-make -p 'src/*.elm' --make='elm-make src/Main.elm --output=dist/main.js' -t ""

elm-reactor
```
