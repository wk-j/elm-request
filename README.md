
```bash

# create project
elm-package install elm-lang/http

# build
elm-make src/Index.elm --output=dist/index.js

# watch
watchman-make -p 'src/*.elm' --make='elm-make src/Index.elm --output=dist/index.js' -t ""

elm-reactor
```