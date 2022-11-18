/** @type {import('tailwindcss').Config} */

module.exports = {
  content: [
    "../lib/**/*.ex",
    "../lib/**/*.eex",
    "../lib/**/*.leex",
    "../lib/**/*.heex",
    "../lib/**/*_view.ex"
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          1: "#101010",
          2: "#181818",
          3: "#272727",
          4: "#343434",
        },
        secondary: "#FFB800",
      }
    },
  },
  plugins: [require("@tailwindcss/forms")],
}
