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
      colors: {
        primary: colors.black,
        secondary: "#FFB800"
      }
    },
  },
  plugins: [require("@tailwindcss/forms")],
}
