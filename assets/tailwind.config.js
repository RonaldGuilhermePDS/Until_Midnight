/** @type {import('tailwindcss').Config} */

const colors = require("tailwindcss/colors");

module.exports = {
  content: [
    "../lib/**/*.eex",
    "../lib/**/*.leex",
    "../lib/**/*.heex",
    "../lib/**/*_view.ex"
  ],
  theme: {
    extend: {
      theme: {
        colors: {
          black: colors.black
        }
      }
    },
  },
  plugins: [require("@tailwindcss/forms")],
}
