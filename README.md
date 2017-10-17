## Request

```bash
# create project
elm-package install elm-lang/http

# build
# elm-make src/Main.elm --output=dist/main.js

# watch
# watchman-make -p 'src/*.elm' --make='elm-make src/Main.elm --output=dist/main.js' -t ""

# reactor
#elm-reactor

# copy html
cp src/Index.html dist

# build with webpack
webpack --watch
```