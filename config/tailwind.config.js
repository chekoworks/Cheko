module.exports = {
  important: true,
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim,turbo_stream}",
  ],
  theme: {
    extend: {
      colors: {
        cheko: "rgb(37 99 235)",
      },
      borderWidth: {
        1: "1px",
      },
      height: {
        500: "500px",
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/aspect-ratio"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
  ],
};
