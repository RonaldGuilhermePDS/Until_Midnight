const esbuild = require('esbuild')

const copyDest = '../priv/static'

let minify = false
let sourcemap = true
let watch_fs = true

if (process.env.NODE_ENV === 'production') {
  minify = true
  sourcemap = false
  watch_fs = false
}

esbuild.build({
  entryPoints: ['./js/app.js'],
  outfile: `${copyDest}/js/app.js`,
  bundle: true,
  minify: minify,
  sourcemap: sourcemap,
  watch: watch_fs
})
 