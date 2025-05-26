// const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
    content: [
        './public/*.html',
        './app/helpers/**/*.rb',
        './app/javascript/**/*.js',
        './app/views/**/*.{erb,haml,html,slim}'
    ],
    theme: {
        extend: {
            colors: {
                'primary': '#6a0dad',
                'lightbluez': '#A7A4F5',
            },
            fontFamily: {
                'varela': ['Varela', 'sans-serif'],
            },
        },
    },
    plugins: [
        // require('@tailwindcss/forms'),
        require('@tailwindcss/typography'),
        // require('@tailwindcss/container-queries'),
    ]
}